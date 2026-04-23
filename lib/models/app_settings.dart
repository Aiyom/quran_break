import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_locale.dart';
import 'custom_ayah_ref.dart';

enum ContentMode {
  randomAyah,
  randomSurah,
  specificSurah,
  specificAyahs,
  customList,
}

enum TafsirChoice { primary, secondary }

class AppSettings {
  // --- Language ---
  AppLocale appLocale;
  AppLocale translationLocale;

  // --- Timer ---
  int breakIntervalMinutes;
  int breakDurationSeconds;

  // --- Content ---
  ContentMode contentMode;
  int specificSurahNumber;
  int specificAyahStart;
  int specificAyahEnd;
  bool showTranslation;
  bool showTafsir;
  TafsirChoice tafsirChoice;

  bool notificationsEnabled;
  bool autostartEnabled;
  bool launchMinimized;

  // --- Tafsir IDs (dynamic by language) ---
  int primaryTafsirId;
  int secondaryTafsirId;
  String primaryTafsirName;
  String secondaryTafsirName;
  bool tafsirIdsInitialized;
  AppLocale tafsirIdsLocale;

  List<CustomAyahRef> customAyahList;

  bool welcomeDismissed;
  bool languageChosen;

  AppSettings({
    this.appLocale = AppLocale.ru,
    this.translationLocale = AppLocale.ru,
    this.breakIntervalMinutes = 30,
    this.breakDurationSeconds = 120,
    this.contentMode = ContentMode.randomAyah,
    this.specificSurahNumber = 1,
    this.specificAyahStart = 1,
    this.specificAyahEnd = 7,
    this.showTranslation = true,
    this.showTafsir = false,
    this.tafsirChoice = TafsirChoice.primary,
    this.notificationsEnabled = true,
    this.autostartEnabled = false,
    this.launchMinimized = false,
    this.primaryTafsirId = 169,
    this.secondaryTafsirId = 90,
    this.primaryTafsirName = 'Ibn Kathir',
    this.secondaryTafsirName = 'Qurtubi',
    this.tafsirIdsInitialized = false,
    this.tafsirIdsLocale = AppLocale.ru,
    List<CustomAyahRef>? customAyahList,
    this.welcomeDismissed = false,
    this.languageChosen = false,
  }) : customAyahList = customAyahList ?? [];

  /// alquran.cloud edition identifier for current translation language.
  /// Returns empty string when translation locale is Arabic (no translation needed).
  String get translationEdition => translationLocale.quranEdition;

  bool get hasTranslation => translationEdition.isNotEmpty;

  static const _keyAppLocale = 'app_locale';
  static const _keyTranslationLocale = 'translation_locale';
  static const _keyBreakInterval = 'break_interval_minutes';
  static const _keyBreakDuration = 'break_duration_seconds';
  static const _keyContentMode = 'content_mode';
  static const _keySpecificSurah = 'specific_surah';
  static const _keyAyahStart = 'specific_ayah_start';
  static const _keyAyahEnd = 'specific_ayah_end';
  static const _keyShowTranslation = 'show_translation';
  static const _keyShowTafsir = 'show_tafsir';
  static const _keyTafsirChoice = 'tafsir_choice';
  static const _keyNotificationsEnabled = 'notifications_enabled';
  static const _keyLaunchMinimized = 'launch_minimized';
  static const _keyPrimaryTafsirId = 'primary_tafsir_id';
  static const _keySecondaryTafsirId = 'secondary_tafsir_id';
  static const _keyPrimaryTafsirName = 'primary_tafsir_name';
  static const _keySecondaryTafsirName = 'secondary_tafsir_name';
  static const _keyTafsirIdsInitialized = 'tafsir_ids_initialized';
  static const _keyTafsirIdsLocale = 'tafsir_ids_locale';
  static const _keyCustomAyahList = 'custom_ayah_list';
  static const _keyWelcomeDismissed = 'welcome_dismissed';
  static const _keyLanguageChosen = 'language_chosen';

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAppLocale, appLocale.name);
    await prefs.setString(_keyTranslationLocale, translationLocale.name);
    await prefs.setInt(_keyBreakInterval, breakIntervalMinutes);
    await prefs.setInt(_keyBreakDuration, breakDurationSeconds);
    await prefs.setString(_keyContentMode, contentMode.name);
    await prefs.setInt(_keySpecificSurah, specificSurahNumber);
    await prefs.setInt(_keyAyahStart, specificAyahStart);
    await prefs.setInt(_keyAyahEnd, specificAyahEnd);
    await prefs.setBool(_keyShowTranslation, showTranslation);
    await prefs.setBool(_keyShowTafsir, showTafsir);
    await prefs.setString(_keyTafsirChoice, tafsirChoice.name);
    await prefs.setBool(_keyNotificationsEnabled, notificationsEnabled);
    await prefs.setBool(_keyLaunchMinimized, launchMinimized);
    await prefs.setInt(_keyPrimaryTafsirId, primaryTafsirId);
    await prefs.setInt(_keySecondaryTafsirId, secondaryTafsirId);
    await prefs.setString(_keyPrimaryTafsirName, primaryTafsirName);
    await prefs.setString(_keySecondaryTafsirName, secondaryTafsirName);
    await prefs.setBool(_keyTafsirIdsInitialized, tafsirIdsInitialized);
    await prefs.setString(_keyTafsirIdsLocale, tafsirIdsLocale.name);
    await prefs.setString(
      _keyCustomAyahList,
      jsonEncode(customAyahList.map((e) => e.toJson()).toList()),
    );
    await prefs.setBool(_keyWelcomeDismissed, welcomeDismissed);
    await prefs.setBool(_keyLanguageChosen, languageChosen);
  }

  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final s = AppSettings();

    s.appLocale = _parseLocale(prefs.getString(_keyAppLocale), AppLocale.ru);
    s.translationLocale =
        _parseLocale(prefs.getString(_keyTranslationLocale), AppLocale.ru);
    s.breakIntervalMinutes = prefs.getInt(_keyBreakInterval) ?? 30;
    s.breakDurationSeconds = prefs.getInt(_keyBreakDuration) ?? 120;
    s.contentMode = _parseContentMode(prefs.getString(_keyContentMode));
    s.specificSurahNumber = prefs.getInt(_keySpecificSurah) ?? 1;
    s.specificAyahStart = prefs.getInt(_keyAyahStart) ?? 1;
    s.specificAyahEnd = prefs.getInt(_keyAyahEnd) ?? 7;
    s.showTranslation = prefs.getBool(_keyShowTranslation) ?? true;
    s.showTafsir = prefs.getBool(_keyShowTafsir) ?? false;
    s.tafsirChoice = _parseTafsirChoice(prefs.getString(_keyTafsirChoice));
    s.notificationsEnabled = prefs.getBool(_keyNotificationsEnabled) ?? true;
    s.launchMinimized = prefs.getBool(_keyLaunchMinimized) ?? false;
    s.primaryTafsirId = prefs.getInt(_keyPrimaryTafsirId) ?? 169;
    s.secondaryTafsirId = prefs.getInt(_keySecondaryTafsirId) ?? 90;
    s.primaryTafsirName = prefs.getString(_keyPrimaryTafsirName) ?? 'Ibn Kathir';
    s.secondaryTafsirName = prefs.getString(_keySecondaryTafsirName) ?? 'Qurtubi';
    s.tafsirIdsInitialized = prefs.getBool(_keyTafsirIdsInitialized) ?? false;
    s.tafsirIdsLocale =
        _parseLocale(prefs.getString(_keyTafsirIdsLocale), AppLocale.ru);
    s.welcomeDismissed = prefs.getBool(_keyWelcomeDismissed) ?? false;
    s.languageChosen = prefs.getBool(_keyLanguageChosen) ?? false;

    final listJson = prefs.getString(_keyCustomAyahList);
    if (listJson != null && listJson.isNotEmpty) {
      try {
        final raw = jsonDecode(listJson) as List;
        s.customAyahList = raw
            .map((e) => CustomAyahRef.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        s.customAyahList = [];
      }
    }

    return s;
  }

  static AppLocale _parseLocale(String? name, AppLocale fallback) {
    if (name == null) return fallback;
    return AppLocale.values.firstWhere(
      (l) => l.name == name,
      orElse: () => fallback,
    );
  }

  static ContentMode _parseContentMode(String? name) {
    if (name == null) return ContentMode.randomAyah;
    return ContentMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => ContentMode.randomAyah,
    );
  }

  static TafsirChoice _parseTafsirChoice(String? name) {
    if (name == null) return TafsirChoice.primary;
    return TafsirChoice.values.firstWhere(
      (t) => t.name == name,
      orElse: () => TafsirChoice.primary,
    );
  }
}
