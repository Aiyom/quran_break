import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import '../l10n/app_locale.dart';

typedef VoidAction = void Function();

class TrayService with TrayListener {
  TrayService._();
  static final TrayService instance = TrayService._();

  AppStrings? _strings;
  bool _isRunning = false;
  bool _autostartEnabled = false;
  String _nextBreakAt = '';
  bool _iconIsActive = false;

  VoidAction? onShowHide;
  VoidAction? onToggleTimer;
  VoidAction? onOpenSettings;
  VoidAction? onToggleAutostart;
  VoidAction? onQuit;

  Future<void> init({required AppStrings strings}) async {
    _strings = strings;
    trayManager.addListener(this);
    await trayManager.setIcon(
      'assets/icons/tray_icon.png',
      isTemplate: Platform.isMacOS,
    );
    await trayManager.setToolTip('Quran Break');
    await rebuildMenu();
  }

  Future<void> updateStrings(AppStrings strings) async {
    _strings = strings;
    await rebuildMenu();
  }

  Future<void> updateState({
    bool? isRunning,
    bool? autostartEnabled,
    String? nextBreakAt,
  }) async {
    _isRunning = isRunning ?? _isRunning;
    _autostartEnabled = autostartEnabled ?? _autostartEnabled;
    _nextBreakAt = nextBreakAt ?? _nextBreakAt;
    await rebuildMenu();
  }

  Future<void> setActiveIcon(bool active) async {
    if (_iconIsActive == active) return;
    _iconIsActive = active;
    try {
      await trayManager.setIcon(
        active
            ? 'assets/icons/tray_icon_active.png'
            : 'assets/icons/tray_icon.png',
        isTemplate: Platform.isMacOS,
      );
    } catch (e) {
      if (kDebugMode) debugPrint('Tray icon error: $e');
    }
  }

  Future<void> rebuildMenu() async {
    final s = _strings;
    if (s == null) return;
    final statusLabel = _isRunning
        ? '${s.nextBreakAt} $_nextBreakAt'
        : s.timerStopped;
    final menu = Menu(items: [
      MenuItem(key: 'show_hide', label: s.showHide),
      MenuItem.separator(),
      MenuItem(key: 'status', label: statusLabel, disabled: true),
      MenuItem(
        key: 'toggle',
        label: _isRunning ? '⏸  ${s.pauseTimer}' : '▶  ${s.startTimer}',
      ),
      MenuItem.separator(),
      MenuItem(key: 'settings', label: '⚙  ${s.settings}'),
      MenuItem.separator(),
      MenuItem.checkbox(
        key: 'autostart',
        label: s.autostart,
        checked: _autostartEnabled,
      ),
      MenuItem.separator(),
      MenuItem(key: 'quit', label: s.quit),
    ]);
    await trayManager.setContextMenu(menu);
  }

  @override
  void onTrayIconMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show_hide':
        onShowHide?.call();
        break;
      case 'toggle':
        onToggleTimer?.call();
        break;
      case 'settings':
        onOpenSettings?.call();
        break;
      case 'autostart':
        onToggleAutostart?.call();
        break;
      case 'quit':
        onQuit?.call();
        break;
    }
  }

  Future<void> dispose() async {
    trayManager.removeListener(this);
    await trayManager.destroy();
  }
}

Future<void> toggleMainWindow() async {
  final visible = await windowManager.isVisible();
  final minimized = await windowManager.isMinimized();
  if (!visible || minimized) {
    // Bring to front.
    if (minimized) await windowManager.restore();
    await windowManager.show();
    await windowManager.focus();
    return;
  }
  final focused = await windowManager.isFocused();
  if (focused) {
    // Minimize instead of hide — keeps dock icon + tray icon visible.
    await windowManager.minimize();
  } else {
    await windowManager.focus();
  }
}
