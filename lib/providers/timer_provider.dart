import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';
import 'quran_provider.dart';

enum TimerState { idle, running, onBreak }

class TimerProvider extends ChangeNotifier {
  TimerState state = TimerState.idle;
  int secondsRemaining = 0;
  int breakSecondsRemaining = 0;
  int totalBreakSeconds = 0;
  int totalIntervalSeconds = 0;
  Timer? _mainTimer;
  Timer? _breakTimer;

  final QuranProvider quranProvider;

  /// Called when break starts — UI should handle showing the break screen,
  /// setting always-on-top, etc.
  Future<void> Function()? onBreakStart;

  /// Called when break ends — UI should hide break screen, clear always-on-top.
  Future<void> Function()? onBreakEnd;

  /// Called on tick — useful for tray menu updates.
  void Function(int secondsRemaining)? onTick;

  /// Called every second during a break — used to push remaining time to
  /// the overlay window.
  void Function(int breakSecondsRemaining)? onBreakTick;

  TimerProvider(this.quranProvider);

  void start(AppSettings s) {
    _mainTimer?.cancel();
    totalIntervalSeconds = s.breakIntervalMinutes * 60;
    secondsRemaining = totalIntervalSeconds;
    state = TimerState.running;
    _mainTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      secondsRemaining--;
      onTick?.call(secondsRemaining);
      if (secondsRemaining <= 0) {
        _triggerBreak(s);
      } else {
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void stop() {
    _mainTimer?.cancel();
    _breakTimer?.cancel();
    state = TimerState.idle;
    secondsRemaining = 0;
    breakSecondsRemaining = 0;
    notifyListeners();
  }

  void toggle(AppSettings s) {
    if (state == TimerState.running || state == TimerState.onBreak) {
      stop();
    } else {
      start(s);
    }
  }

  Future<void> _triggerBreak(AppSettings s) async {
    _mainTimer?.cancel();
    state = TimerState.onBreak;
    totalBreakSeconds = s.breakDurationSeconds;
    breakSecondsRemaining = totalBreakSeconds;
    notifyListeners();

    await quranProvider.loadContent(s);
    await onBreakStart?.call();

    _breakTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      breakSecondsRemaining--;
      onBreakTick?.call(breakSecondsRemaining);
      if (breakSecondsRemaining <= 0) {
        _endBreak(s);
      } else {
        notifyListeners();
      }
    });
  }

  Future<void> _endBreak(AppSettings s) async {
    _breakTimer?.cancel();
    await onBreakEnd?.call();
    start(s);
  }

  void skipBreak(AppSettings s) {
    _endBreak(s);
  }

  String get remainingFormatted {
    final m = secondsRemaining ~/ 60;
    final sec = secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  String get breakRemainingFormatted {
    final m = breakSecondsRemaining ~/ 60;
    final sec = breakSecondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  String get nextBreakAt {
    final t = DateTime.now().add(Duration(seconds: secondsRemaining));
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  double get progress {
    if (totalIntervalSeconds == 0) return 0;
    return 1.0 - (secondsRemaining / totalIntervalSeconds);
  }

  double get breakProgress {
    if (totalBreakSeconds == 0) return 0;
    return 1.0 - (breakSecondsRemaining / totalBreakSeconds);
  }

  @override
  void dispose() {
    _mainTimer?.cancel();
    _breakTimer?.cancel();
    super.dispose();
  }
}
