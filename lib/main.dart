import 'dart:convert';
import 'dart:io';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';
import 'models/app_settings.dart';
import 'overlay/break_overlay_app.dart';
import 'providers/quran_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/timer_provider.dart';
import 'services/break_window_bridge.dart';
import 'services/notification_service.dart';
import 'services/tray_service.dart';

bool _isLaunchedMinimized() =>
    Platform.executableArguments.contains('--minimized');

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // Sub-window detection: desktop_multi_window stores arguments in the
  // current engine's WindowController; main window returns empty string.
  final currentWindow = await WindowController.fromCurrentEngine();
  final rawArgs = currentWindow.arguments;
  if (rawArgs.isNotEmpty) {
    try {
      final json = jsonDecode(rawArgs) as Map<String, dynamic>;
      if (json['businessId'] == BreakWindowBridge.businessId) {
        await runBreakOverlay(rawArgs);
        return;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[quran_break] overlay arg parse failed: $e');
    }
  }

  const windowOptions = WindowOptions(
    size: Size(520, 680),
    minimumSize: Size(420, 560),
    center: true,
    title: 'Quran Break',
    titleBarStyle: TitleBarStyle.normal,
    skipTaskbar: false,
  );

  final startMinimized = _isLaunchedMinimized();

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    if (!startMinimized) {
      await windowManager.show();
      await windowManager.focus();
    }
    await windowManager.setPreventClose(true);
  });

  final settings = await AppSettings.load();

  await NotificationService.init();

  final settingsProvider = SettingsProvider(settings);
  final quranProvider = QuranProvider();
  final timerProvider = TimerProvider(quranProvider);

  BreakWindowBridge.instance.attachMainHandler();

  await TrayService.instance.init(strings: settingsProvider.strings);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: quranProvider),
        ChangeNotifierProvider.value(value: timerProvider),
      ],
      child: const QuranBreakApp(),
    ),
  );
}
