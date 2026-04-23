import 'dart:io';

class AutostartService {
  static bool isEnabled() {
    if (Platform.isLinux) return _isEnabledLinux();
    if (Platform.isWindows) return _isEnabledWindows();
    if (Platform.isMacOS) return _isEnabledMacOS();
    return false;
  }

  static Future<void> enable() async {
    if (Platform.isLinux) await _enableLinux();
    if (Platform.isWindows) await _enableWindows();
    if (Platform.isMacOS) await _enableMacOS();
  }

  static Future<void> disable() async {
    if (Platform.isLinux) await _disableLinux();
    if (Platform.isWindows) await _disableWindows();
    if (Platform.isMacOS) await _disableMacOS();
  }

  static Future<bool> toggle() async {
    if (isEnabled()) {
      await disable();
      return false;
    } else {
      await enable();
      return true;
    }
  }

  static String autostartPath() {
    if (Platform.isLinux) return _linuxDesktopFile().path;
    if (Platform.isWindows) return _windowsStartupFile().path;
    if (Platform.isMacOS) return _macOSPlistFile().path;
    return '';
  }

  // ─── LINUX ─────────────────────────────────────────────────────────────
  static File _linuxDesktopFile() {
    final home = Platform.environment['HOME'] ?? '';
    return File('$home/.config/autostart/quran_break.desktop');
  }

  static bool _isEnabledLinux() => _linuxDesktopFile().existsSync();

  static Future<void> _enableLinux() async {
    final file = _linuxDesktopFile();
    file.parent.createSync(recursive: true);
    final exec = Platform.resolvedExecutable;
    await file.writeAsString('''[Desktop Entry]
Type=Application
Name=Quran Break
Comment=Quran Break Timer
Exec=$exec --minimized
Icon=$exec
Terminal=false
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
X-GNOME-Autostart-Delay=5
''');
  }

  static Future<void> _disableLinux() async {
    final file = _linuxDesktopFile();
    if (file.existsSync()) file.deleteSync();
  }

  // ─── WINDOWS ───────────────────────────────────────────────────────────
  static File _windowsStartupFile() {
    final appData = Platform.environment['APPDATA'] ?? '';
    return File(
      '$appData\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\QuranBreak.bat',
    );
  }

  static bool _isEnabledWindows() => _windowsStartupFile().existsSync();

  static Future<void> _enableWindows() async {
    final file = _windowsStartupFile();
    file.parent.createSync(recursive: true);
    final exec = Platform.resolvedExecutable;
    await file.writeAsString(
      '@echo off\r\nstart "" "$exec" --minimized\r\n',
    );
  }

  static Future<void> _disableWindows() async {
    final file = _windowsStartupFile();
    if (file.existsSync()) file.deleteSync();
  }

  // ─── MACOS ─────────────────────────────────────────────────────────────
  static File _macOSPlistFile() {
    final home = Platform.environment['HOME'] ?? '';
    return File(
      '$home/Library/LaunchAgents/com.quranbreak.quranbreak.plist',
    );
  }

  static bool _isEnabledMacOS() => _macOSPlistFile().existsSync();

  static Future<void> _enableMacOS() async {
    final file = _macOSPlistFile();
    file.parent.createSync(recursive: true);
    final exec = Platform.resolvedExecutable;
    await file.writeAsString('''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.quranbreak.quranbreak</string>
  <key>ProgramArguments</key>
  <array>
    <string>$exec</string>
    <string>--minimized</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <false/>
  <key>LaunchOnlyOnce</key>
  <true/>
</dict>
</plist>
''');
    await Process.run('launchctl', ['load', file.path]);
  }

  static Future<void> _disableMacOS() async {
    final file = _macOSPlistFile();
    if (file.existsSync()) {
      await Process.run('launchctl', ['unload', file.path]);
      file.deleteSync();
    }
  }
}
