import 'dart:async';
import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MethodChannel;
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

import '../constants/app_theme.dart';
import '../services/break_window_bridge.dart';
import 'break_overlay_screen.dart';
import 'overlay_state.dart';

/// Native kiosk channel — implemented in macos/Runner/MainFlutterWindow.swift
/// (KioskController). Raises window level, spans all Spaces, hides menu bar
/// and dock, blocks Cmd+Tab / Cmd+Q for the duration of the break.
const _kioskChannel = MethodChannel('quran_break.kiosk');

Future<void> _kioskEnable() async {
  try {
    await _kioskChannel.invokeMethod('enable');
  } catch (e) {
    debugPrint('[overlay] kiosk enable failed: $e');
  }
}

Future<void> _kioskDisable() async {
  try {
    await _kioskChannel.invokeMethod('disable');
  } catch (e) {
    debugPrint('[overlay] kiosk disable failed: $e');
  }
}

Future<void> _kioskHide() async {
  try {
    await _kioskChannel.invokeMethod('hide');
  } catch (e) {
    debugPrint('[overlay] kiosk hide failed: $e');
  }
}

/// Entry point for the break overlay sub-window.
/// Assumes WidgetsFlutterBinding + windowManager are already initialized
/// by main() prior to the branch decision.
Future<void> runBreakOverlay(String argumentsJson) async {
  debugPrint('[overlay] runBreakOverlay entered');
  const options = WindowOptions(
    titleBarStyle: TitleBarStyle.hidden,
    skipTaskbar: true,
    alwaysOnTop: true,
  );
  try {
    await windowManager.waitUntilReadyToShow(options, () async {
      debugPrint('[overlay] waitUntilReadyToShow callback running');
      try {
        final display = await screenRetriever.getPrimaryDisplay();
        debugPrint('[overlay] display size=${display.size}');
        await windowManager.setSize(display.size);
        await windowManager.setPosition(Offset.zero);
      } catch (e) {
        debugPrint('[overlay] display setup failed: $e');
      }
      await windowManager.setAlwaysOnTop(true);
      // Do NOT call windowManager.show() — its macOS impl invokes
      // NSApp.activate(ignoringOtherApps:) which teleports the user's
      // Space to our app. Kiosk enable below surfaces the window via
      // orderFrontRegardless on the user's ACTIVE Space instead.
      await _kioskEnable();
      debugPrint('[overlay] kiosk engaged (show handled natively)');
    });
  } catch (e, st) {
    debugPrint('[overlay] window setup error: $e\n$st');
  }

  final initial = <String, dynamic>{};
  if (argumentsJson.isNotEmpty) {
    try {
      initial.addAll((jsonDecode(argumentsJson) as Map).cast<String, dynamic>());
    } catch (_) {}
  }

  final state = BreakOverlayData()..apply(initial);

  const channel = WindowMethodChannel(
    BreakWindowBridge.channelName,
    mode: ChannelMode.bidirectional,
  );
  channel.setMethodCallHandler((call) async {
    switch (call.method) {
      case 'update':
        final arg = call.arguments;
        if (arg is String) {
          try {
            state.apply((jsonDecode(arg) as Map).cast<String, dynamic>());
          } catch (_) {}
        } else if (arg is Map) {
          state.apply(arg.cast<String, dynamic>());
        }
        return null;
      case 'show':
        // Reuse path: re-engage kiosk (native show via orderFrontRegardless
        // on user's active Space — no NSApp.activate, no Space-teleport).
        await _kioskEnable();
        return null;
      case 'close':
        // CRITICAL: do NOT call windowManager.destroy() — its macOS
        // implementation is NSApp.terminate(nil) which kills the WHOLE
        // process. Do not use windowManager.hide() either — it uses
        // NSApp.activate elsewhere in the call chain. Native kiosk hide
        // does a plain orderOut(nil).
        await _kioskDisable();
        await _kioskHide();
        return null;
    }
    return null;
  });

  // Inform main window that overlay is ready to receive updates.
  unawaited(() async {
    try {
      await channel.invokeMethod('ready');
    } catch (_) {}
  }());

  runApp(_BreakOverlayRoot(state: state));
}

class _BreakOverlayRoot extends StatelessWidget {
  final BreakOverlayData state;

  const _BreakOverlayRoot({required this.state});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: BreakOverlayScreen(state: state),
    );
  }
}
