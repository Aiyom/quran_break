import 'dart:async';
import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/app_settings.dart';
import '../models/ayah_model.dart';

typedef BreakIntentHandler = void Function();

/// Main-window-side bridge that spawns and controls the break overlay window.
/// Uses [desktop_multi_window] + [WindowMethodChannel] for IPC.
class BreakWindowBridge {
  BreakWindowBridge._();
  static final BreakWindowBridge instance = BreakWindowBridge._();

  static const String channelName = 'quran_break.break_overlay';
  static const String businessId = 'break_overlay';

  static const _channel = WindowMethodChannel(
    channelName,
    mode: ChannelMode.bidirectional,
  );

  WindowController? _controller;
  bool _overlayReady = false;
  Map<String, dynamic> _pendingState = {};

  BreakIntentHandler? onSkip;
  BreakIntentHandler? onAnother;
  BreakIntentHandler? onNext;
  BreakIntentHandler? onPrevious;

  bool get isOpen => _controller != null;

  /// Call once at app startup on the main window side to register handler.
  void attachMainHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'ready':
          _overlayReady = true;
          if (_pendingState.isNotEmpty) {
            await _pushRaw(_pendingState);
            _pendingState = {};
          }
          return null;
        case 'skip':
          onSkip?.call();
          return null;
        case 'another':
          onAnother?.call();
          return null;
        case 'next':
          onNext?.call();
          return null;
        case 'previous':
          onPrevious?.call();
          return null;
      }
      return null;
    });
  }

  /// Opens the break overlay window with the provided initial state.
  /// Re-uses an existing hidden overlay if one exists (hide-not-destroy
  /// lifecycle), which avoids crashes from repeatedly spawning/destroying
  /// FlutterEngines on macOS.
  Future<void> open({
    required AppSettings settings,
    required AyahModel? ayah,
    required int remainingSeconds,
    required int totalSeconds,
    required bool isOffline,
  }) async {
    final payload = _payload(
      settings: settings,
      ayah: ayah,
      remainingSeconds: remainingSeconds,
      totalSeconds: totalSeconds,
      isOffline: isOffline,
    );

    if (_controller != null) {
      // Reuse hidden overlay from a previous break: push fresh state, tell
      // the overlay to re-show + re-engage kiosk, and bring the NSWindow
      // back (native show) for good measure.
      await _pushRaw(payload);
      try {
        await _channel.invokeMethod('show');
      } catch (e) {
        if (kDebugMode) debugPrint('overlay reuse show ipc failed: $e');
      }
      try {
        await _controller!.show();
      } catch (e) {
        if (kDebugMode) debugPrint('overlay reuse show controller failed: $e');
      }
      return;
    }

    _overlayReady = false;
    _pendingState = payload; // will flush once overlay reports 'ready'

    final args = jsonEncode({
      'businessId': businessId,
      ...payload,
    });

    try {
      final controller = await WindowController.create(
        WindowConfiguration(
          // CRITICAL: hide-at-launch. The plugin's CreateWindow calls
          // orderFront(nil) before our setOnWindowCreatedCallback fires,
          // which pins the NSWindow to the main window's Space. With
          // hiddenAtLaunch: true the plugin immediately follows with
          // setIsVisible(false) — the window never actually registers on
          // Space 1. Our callback then sets .canJoinAllSpaces before the
          // FIRST real orderFront happens (inside KioskController.enable),
          // so the flag actually takes effect and the overlay surfaces on
          // whichever Space the user is currently on.
          hiddenAtLaunch: true,
          arguments: args,
        ),
      );
      _controller = controller;
    } catch (e) {
      if (kDebugMode) debugPrint('BreakWindowBridge.open failed: $e');
    }
  }

  /// Pushes state delta (timer tick, ayah change, etc.) to the overlay.
  Future<void> push({
    AppSettings? settings,
    AyahModel? ayah,
    bool ayahExplicit = false,
    int? remainingSeconds,
    int? totalSeconds,
    bool? isOffline,
  }) async {
    if (_controller == null) return;
    final delta = <String, dynamic>{};
    if (settings != null) {
      delta.addAll(_settingsJson(settings));
    }
    if (ayahExplicit) {
      delta['ayah'] = ayah?.toJson();
    }
    if (remainingSeconds != null) delta['remainingSeconds'] = remainingSeconds;
    if (totalSeconds != null) delta['totalSeconds'] = totalSeconds;
    if (isOffline != null) delta['isOffline'] = isOffline;

    if (!_overlayReady) {
      _pendingState.addAll(delta);
      return;
    }
    await _pushRaw(delta);
  }

  Future<void> _pushRaw(Map<String, dynamic> delta) async {
    if (delta.isEmpty) return;
    try {
      await _channel.invokeMethod('update', jsonEncode(delta));
    } on WindowChannelException catch (e) {
      if (kDebugMode) debugPrint('push failed: ${e.message}');
    } on PlatformException catch (e) {
      if (kDebugMode) debugPrint('push platform error: ${e.message}');
    }
  }

  /// Hides the overlay window (we keep the sub-window engine alive across
  /// breaks — the overlay's 'close' handler uses windowManager.hide() rather
  /// than destroy(), which would NSApp.terminate the whole process).
  Future<void> close() async {
    if (_controller == null) return;
    try {
      await _channel.invokeMethod('close');
    } catch (_) {}
    // Do NOT null out _controller — we re-use it on the next break.
  }

  Map<String, dynamic> _payload({
    required AppSettings settings,
    required AyahModel? ayah,
    required int remainingSeconds,
    required int totalSeconds,
    required bool isOffline,
  }) {
    return {
      ..._settingsJson(settings),
      'ayah': ayah?.toJson(),
      'remainingSeconds': remainingSeconds,
      'totalSeconds': totalSeconds,
      'isOffline': isOffline,
    };
  }

  Map<String, dynamic> _settingsJson(AppSettings s) {
    return {
      'appLocale': s.appLocale.name,
      'translationLocale': s.translationLocale.name,
      'showTranslation': s.showTranslation,
      'showTafsir': s.showTafsir,
      'tafsirName': s.tafsirChoice == TafsirChoice.primary
          ? s.primaryTafsirName
          : s.secondaryTafsirName,
      'contentMode': s.contentMode.name,
    };
  }
}

/// Used by main.dart to peek at the current window's arguments before
/// deciding which entry point to run.
Future<String?> currentWindowBusinessId() async {
  try {
    final controller = await WindowController.fromCurrentEngine();
    final raw = controller.arguments;
    if (raw.isEmpty) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return json['businessId'] as String?;
  } catch (_) {
    return null;
  }
}
