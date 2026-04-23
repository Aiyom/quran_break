import 'package:flutter/foundation.dart';
import '../l10n/app_locale.dart';
import '../models/app_settings.dart';
import '../models/ayah_model.dart';

class BreakOverlayData extends ChangeNotifier {
  AyahModel? ayah;
  int remainingSeconds = 0;
  int totalSeconds = 0;

  AppLocale appLocale = AppLocale.ru;
  AppLocale translationLocale = AppLocale.ru;
  bool showTranslation = true;
  bool showTafsir = false;
  String tafsirName = '';
  ContentMode contentMode = ContentMode.randomAyah;
  bool isOffline = false;

  double get progress =>
      totalSeconds == 0 ? 0 : 1.0 - (remainingSeconds / totalSeconds);

  String get remainingFormatted {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void apply(Map<String, dynamic> json) {
    if (json.containsKey('ayah')) {
      final raw = json['ayah'];
      ayah = raw == null
          ? null
          : AyahModel.fromJson(
              (raw as Map).cast<String, dynamic>(),
            );
    }
    if (json.containsKey('remainingSeconds')) {
      remainingSeconds = (json['remainingSeconds'] as num).toInt();
    }
    if (json.containsKey('totalSeconds')) {
      totalSeconds = (json['totalSeconds'] as num).toInt();
    }
    if (json.containsKey('appLocale')) {
      appLocale = AppLocale.values.firstWhere(
        (l) => l.name == json['appLocale'],
        orElse: () => AppLocale.ru,
      );
    }
    if (json.containsKey('translationLocale')) {
      translationLocale = AppLocale.values.firstWhere(
        (l) => l.name == json['translationLocale'],
        orElse: () => AppLocale.ru,
      );
    }
    if (json.containsKey('showTranslation')) {
      showTranslation = json['showTranslation'] as bool;
    }
    if (json.containsKey('showTafsir')) {
      showTafsir = json['showTafsir'] as bool;
    }
    if (json.containsKey('tafsirName')) {
      tafsirName = json['tafsirName'] as String;
    }
    if (json.containsKey('contentMode')) {
      contentMode = ContentMode.values.firstWhere(
        (m) => m.name == json['contentMode'],
        orElse: () => ContentMode.randomAyah,
      );
    }
    if (json.containsKey('isOffline')) {
      isOffline = json['isOffline'] as bool;
    }
    notifyListeners();
  }
}
