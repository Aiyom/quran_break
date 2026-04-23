import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'l10n/app_locale.dart';
import 'providers/quran_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/timer_provider.dart';
import 'screens/home_screen.dart';
import 'screens/language_picker_dialog.dart';
import 'screens/settings_screen.dart';
import 'services/autostart_service.dart';
import 'services/break_window_bridge.dart';
import 'services/notification_service.dart';
import 'services/tafsir_service.dart';
import 'services/tray_service.dart';
import 'constants/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class QuranBreakApp extends StatefulWidget {
  const QuranBreakApp({super.key});

  @override
  State<QuranBreakApp> createState() => _QuranBreakAppState();
}

class _QuranBreakAppState extends State<QuranBreakApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _afterFirstFrame());
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    // Minimize to dock + keep tray icon; actual quit only via tray "Quit".
    await windowManager.minimize();
  }

  Future<void> _afterFirstFrame() async {
    final sp = context.read<SettingsProvider>();
    final timer = context.read<TimerProvider>();
    final quran = context.read<QuranProvider>();
    final bridge = BreakWindowBridge.instance;

    // Wire bridge intents from overlay window.
    bridge.onSkip = () => timer.skipBreak(sp.settings);
    bridge.onAnother = () async {
      await quran.loadAnother(sp.settings);
      await bridge.push(
        ayah: quran.currentAyah,
        ayahExplicit: true,
        isOffline: quran.isOffline,
      );
    };
    bridge.onNext = () async {
      await quran.loadNext(sp.settings);
      await bridge.push(
        ayah: quran.currentAyah,
        ayahExplicit: true,
        isOffline: quran.isOffline,
      );
    };
    bridge.onPrevious = () async {
      await quran.loadPrevious(sp.settings);
      await bridge.push(
        ayah: quran.currentAyah,
        ayahExplicit: true,
        isOffline: quran.isOffline,
      );
    };

    // Keep overlay ayah in sync whenever QuranProvider state changes
    // (tafsir loaded asynchronously, etc.).
    quran.addListener(() {
      if (!bridge.isOpen) return;
      bridge.push(
        ayah: quran.currentAyah,
        ayahExplicit: true,
        isOffline: quran.isOffline,
      );
    });

    // Wire timer callbacks — spawn overlay window, no main-window fullscreen.
    timer.onBreakStart = () async {
      if (sp.settings.notificationsEnabled) {
        unawaited(NotificationService.showBreakAlert(
          strings: sp.strings,
          onTap: () async {
            await windowManager.show();
            await windowManager.focus();
          },
        ));
      }
      await TrayService.instance.setActiveIcon(true);
      await bridge.open(
        settings: sp.settings,
        ayah: quran.currentAyah,
        remainingSeconds: timer.breakSecondsRemaining,
        totalSeconds: timer.totalBreakSeconds,
        isOffline: quran.isOffline,
      );
    };
    timer.onBreakEnd = () async {
      await bridge.close();
      await TrayService.instance.setActiveIcon(false);
      await TrayService.instance.updateState(
        isRunning: true,
        nextBreakAt: timer.nextBreakAt,
        autostartEnabled: AutostartService.isEnabled(),
      );
    };
    timer.onTick = (secondsRemaining) {
      if (secondsRemaining % 30 == 0) {
        TrayService.instance.updateState(
          isRunning: true,
          nextBreakAt: timer.nextBreakAt,
          autostartEnabled: AutostartService.isEnabled(),
        );
      }
    };
    timer.onBreakTick = (remaining) {
      bridge.push(
        remainingSeconds: remaining,
        totalSeconds: timer.totalBreakSeconds,
      );
    };

    // Wire tray callbacks.
    final tray = TrayService.instance;
    tray.onShowHide = () {
      toggleMainWindow();
    };
    tray.onToggleTimer = () {
      timer.toggle(sp.settings);
    };
    tray.onOpenSettings = () async {
      await windowManager.show();
      await windowManager.focus();
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      );
    };
    tray.onToggleAutostart = () async {
      await AutostartService.toggle();
      await sp.setAutostartEnabled(AutostartService.isEnabled());
      await TrayService.instance.updateState(
        autostartEnabled: AutostartService.isEnabled(),
      );
    };
    tray.onQuit = () async {
      await windowManager.setPreventClose(false);
      await windowManager.close();
      exit(0);
    };

    // First-run language picker.
    if (!sp.settings.languageChosen) {
      final picked = await LanguagePickerDialog.show(
        navigatorKey.currentContext ?? context,
        initialLocale: sp.settings.appLocale,
      );
      if (picked != null) {
        await sp.setAppLocale(picked);
        await sp.setTranslationLocale(picked);
      } else {
        sp.settings.languageChosen = true;
        await sp.settings.save();
      }
    }

    // Refresh tafsir IDs if translation locale changed or first run.
    await initTafsirIdsIfNeeded(sp.settings);
    if (mounted) sp.refresh();

    // Update tray strings with current locale.
    await TrayService.instance.updateStrings(sp.strings);
    await TrayService.instance.updateState(
      isRunning: false,
      autostartEnabled: AutostartService.isEnabled(),
      nextBreakAt: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SettingsProvider>();
    final locale = sp.settings.appLocale;
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Quran Break',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      builder: (context, child) {
        return Directionality(
          textDirection: locale.textDirection,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomeScreen(),
      routes: {
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
