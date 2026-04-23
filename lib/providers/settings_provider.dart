import 'package:flutter/foundation.dart';
import '../l10n/app_locale.dart';
import '../l10n/strings.dart';
import '../models/app_settings.dart';
import '../models/custom_ayah_ref.dart';
import '../services/tafsir_service.dart';

class SettingsProvider extends ChangeNotifier {
  AppSettings settings;

  SettingsProvider(this.settings);

  AppStrings get strings => getStrings(settings.appLocale);

  Future<void> setAppLocale(AppLocale locale) async {
    settings.appLocale = locale;
    settings.languageChosen = true;
    await settings.save();
    notifyListeners();
  }

  Future<void> setTranslationLocale(AppLocale locale) async {
    settings.translationLocale = locale;
    await settings.save();
    notifyListeners();
    // Trigger tafsir IDs refresh for new language.
    await initTafsirIdsIfNeeded(settings);
    notifyListeners();
  }

  Future<void> setBreakInterval(int minutes) async {
    settings.breakIntervalMinutes = minutes;
    await settings.save();
    notifyListeners();
  }

  Future<void> setBreakDuration(int seconds) async {
    settings.breakDurationSeconds = seconds;
    await settings.save();
    notifyListeners();
  }

  Future<void> setContentMode(ContentMode mode) async {
    settings.contentMode = mode;
    await settings.save();
    notifyListeners();
  }

  Future<void> setSpecificSurah(int number) async {
    settings.specificSurahNumber = number;
    await settings.save();
    notifyListeners();
  }

  Future<void> setAyahRange(int start, int end) async {
    settings.specificAyahStart = start;
    settings.specificAyahEnd = end;
    await settings.save();
    notifyListeners();
  }

  Future<void> setShowTranslation(bool value) async {
    settings.showTranslation = value;
    await settings.save();
    notifyListeners();
  }

  Future<void> setShowTafsir(bool value) async {
    settings.showTafsir = value;
    await settings.save();
    notifyListeners();
  }

  Future<void> setTafsirChoice(TafsirChoice choice) async {
    settings.tafsirChoice = choice;
    await settings.save();
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    settings.notificationsEnabled = value;
    await settings.save();
    notifyListeners();
  }

  Future<void> setAutostartEnabled(bool value) async {
    settings.autostartEnabled = value;
    await settings.save();
    notifyListeners();
  }

  Future<void> addCustomAyah(CustomAyahRef ref) async {
    if (settings.customAyahList.contains(ref)) return;
    settings.customAyahList = [...settings.customAyahList, ref];
    await settings.save();
    notifyListeners();
  }

  Future<void> removeCustomAyah(CustomAyahRef ref) async {
    settings.customAyahList = settings.customAyahList
        .where((e) => e != ref)
        .toList();
    await settings.save();
    notifyListeners();
  }

  Future<void> insertCustomAyahAt(int index, CustomAyahRef ref) async {
    final list = [...settings.customAyahList];
    final safeIndex = index.clamp(0, list.length);
    list.insert(safeIndex, ref);
    settings.customAyahList = list;
    await settings.save();
    notifyListeners();
  }

  Future<void> dismissWelcome() async {
    settings.welcomeDismissed = true;
    await settings.save();
    notifyListeners();
  }

  /// External trigger for UI refresh after side-effect updates on `settings`.
  void refresh() => notifyListeners();
}
