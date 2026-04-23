import 'package:flutter/material.dart';

enum AppLocale { ru, tg, en, kk, ky, uz, ar }

extension AppLocaleX on AppLocale {
  String get code => switch (this) {
        AppLocale.ru => 'ru',
        AppLocale.tg => 'tg',
        AppLocale.en => 'en',
        AppLocale.kk => 'kk',
        AppLocale.ky => 'ky',
        AppLocale.uz => 'uz',
        AppLocale.ar => 'ar',
      };

  String get nativeName => switch (this) {
        AppLocale.ru => 'Русский',
        AppLocale.tg => 'Тоҷикӣ',
        AppLocale.en => 'English',
        AppLocale.kk => 'Қазақша',
        AppLocale.ky => 'Кыргызча',
        AppLocale.uz => 'Oʻzbekcha',
        AppLocale.ar => 'العربية',
      };

  TextDirection get textDirection =>
      this == AppLocale.ar ? TextDirection.rtl : TextDirection.ltr;

  /// alquran.cloud edition identifier for Quran translation
  String get quranEdition => switch (this) {
        AppLocale.ru => 'ru.kuliev',
        AppLocale.tg => 'tg.ayati',
        AppLocale.en => 'en.sahih',
        AppLocale.kk => 'kk.khalifaaltan',
        AppLocale.ky => 'ky.mamadaliev',
        AppLocale.uz => 'uz.sodik',
        AppLocale.ar => '',
      };

  /// api.quran.com language_name
  String get apiLanguageName => switch (this) {
        AppLocale.ar => 'arabic',
        AppLocale.ru => 'russian',
        AppLocale.en => 'english',
        AppLocale.tg => 'tajik',
        AppLocale.kk => 'kazakh',
        AppLocale.ky => 'kyrgyz',
        AppLocale.uz => 'uzbek',
      };
}

abstract class AppStrings {
  AppLocale get locale;

  String get appName;
  String get loading;
  String get cancel;
  String get ok;
  String get save;
  String get delete;
  String get undo;
  String get add;
  String get close;
  String get retry;
  String get understood;

  // Home
  String get startTimer;
  String get pauseTimer;
  String get resumeTimer;
  String get nextBreakAt;
  String get timerStopped;
  String get timeUntilBreak;
  String get welcomeTitle;
  String get welcomeText;
  String get currentSettings;
  String get tapToChange;

  // Tray
  String get showHide;
  String get quit;
  String get notificationTitle;
  String get notificationBody;

  // Settings sections
  String get settings;
  String get sectionLanguage;
  String get sectionSchedule;
  String get sectionContent;
  String get sectionTranslation;
  String get sectionTafsir;
  String get sectionSystem;

  // Language
  String get interfaceLanguage;
  String get interfaceLanguageSubtitle;
  String get translationLanguage;
  String get translationLanguageSubtitle;
  String get noTranslation;

  // Schedule
  String get breakEvery;
  String get breakEverySubtitle;
  String get breakDuration;
  String get breakDurationSubtitle;
  String get minutesShort;
  String get minutesWord;
  String get showNotification;
  String get showNotificationSubtitle;

  // Content modes
  String get modeRandomAyah;
  String get modeRandomAyahSubtitle;
  String get modeRandomSurah;
  String get modeRandomSurahSubtitle;
  String get modeSpecificSurah;
  String get modeSpecificSurahSubtitle;
  String get modeSpecificAyahs;
  String get modeSpecificAyahsSubtitle;
  String get modeCustomList;
  String get modeCustomListSubtitleEmpty;
  String modeCustomListSubtitleCount(int n);
  String get chooseSurah;
  String get ayahFrom;
  String get ayahTo;

  // Translation
  String get showTranslation;
  String showTranslationSubtitle(String lang);
  String get arabicOnlyNoTranslation;

  // Tafsir
  String get showTafsir;
  String get showTafsirSubtitle;
  String get tafsirPrimary;
  String get tafsirPrimarySubtitle;
  String get tafsirSecondary;
  String get tafsirSecondarySubtitle;
  String tafsirLanguageInfo(String lang);

  // System
  String get autostart;
  String get autostartSubtitle;
  String get currentPlatform;

  // Surah picker
  String get chooseSurahTitle;
  String get searchSurahHint;
  String get ayahCount;
  String get meccan;
  String get medinan;

  // Custom list
  String get myList;
  String get myListSubtitle;
  String get addAyah;
  String get addFirstAyah;
  String get listEmpty;
  String get listEmptyHint;
  String get deleteFromList;
  String get deleted;
  String ayahRemoved(String verseKey);
  String totalAyahs(int n);
  String get manageList;
  String get selectSurahStep;
  String get enterAyahNumber;
  String enterAyahNumberHint(int max);
  String get ayahAlreadyInList;
  String get ayahOutOfRange;

  // Break screen
  String get breakTitle;
  String get skipBreak;
  String get previous;
  String get next;
  String get another;
  String get tafsirOf;
  String get offline;
  String get errorLoading;
  String get checkConnection;

  // First run
  String get chooseLanguageTitle;
  String get chooseLanguageSubtitle;
  String get continueText;
}
