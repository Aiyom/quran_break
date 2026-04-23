import 'app_locale.dart';

class StringsEn implements AppStrings {
  @override
  AppLocale get locale => AppLocale.en;

  @override
  String get appName => 'Quran Break';
  @override
  String get loading => 'Loading...';
  @override
  String get cancel => 'Cancel';
  @override
  String get ok => 'OK';
  @override
  String get save => 'Save';
  @override
  String get delete => 'Delete';
  @override
  String get undo => 'Undo';
  @override
  String get add => 'Add';
  @override
  String get close => 'Close';
  @override
  String get retry => 'Retry';
  @override
  String get understood => 'Got it';

  @override
  String get startTimer => 'Start';
  @override
  String get pauseTimer => 'Pause';
  @override
  String get resumeTimer => 'Resume';
  @override
  String get nextBreakAt => 'Next break at';
  @override
  String get timerStopped => 'Timer stopped';
  @override
  String get timeUntilBreak => 'until break';
  @override
  String get welcomeTitle => 'Welcome!';
  @override
  String get welcomeText =>
      'Quran Break reminds you to read the Quran during breaks. Configure the interval and content in ⚙ Settings.';
  @override
  String get currentSettings => 'Current settings';
  @override
  String get tapToChange => 'Tap to change';

  @override
  String get showHide => 'Show / Hide';
  @override
  String get quit => 'Quit';
  @override
  String get notificationTitle => '🕌 Time for a break';
  @override
  String get notificationBody => 'Open Quran Break to read an ayah';

  @override
  String get settings => 'Settings';
  @override
  String get sectionLanguage => 'Language';
  @override
  String get sectionSchedule => 'Schedule';
  @override
  String get sectionContent => 'What to show';
  @override
  String get sectionTranslation => 'Translation';
  @override
  String get sectionTafsir => 'Tafsir (interpretation)';
  @override
  String get sectionSystem => 'System';

  @override
  String get interfaceLanguage => 'Interface language';
  @override
  String get interfaceLanguageSubtitle => 'Language of buttons, menus and tips';
  @override
  String get translationLanguage => 'Quran translation language';
  @override
  String get translationLanguageSubtitle => 'Ayah translations will be in this language';
  @override
  String get noTranslation => 'No translation (Arabic only)';

  @override
  String get breakEvery => 'Break every';
  @override
  String get breakEverySubtitle => 'How often to show an ayah';
  @override
  String get breakDuration => 'Break duration';
  @override
  String get breakDurationSubtitle => 'How long to display the ayah';
  @override
  String get minutesShort => 'min';
  @override
  String get minutesWord => 'minutes';
  @override
  String get showNotification => 'Show notification';
  @override
  String get showNotificationSubtitle => 'System notification before break';

  @override
  String get modeRandomAyah => 'Random ayah';
  @override
  String get modeRandomAyahSubtitle => 'Each break — a new random ayah from the whole Quran';
  @override
  String get modeRandomSurah => 'Random surah';
  @override
  String get modeRandomSurahSubtitle => 'Each break — an ayah from a random surah';
  @override
  String get modeSpecificSurah => 'Specific surah';
  @override
  String get modeSpecificSurahSubtitle => 'Read one surah in order, ayah by ayah';
  @override
  String get modeSpecificAyahs => 'Specific ayahs';
  @override
  String get modeSpecificAyahsSubtitle => 'Learn a specific passage — set the range';
  @override
  String get modeCustomList => 'My list';
  @override
  String get modeCustomListSubtitleEmpty => 'List is empty — add ayahs';
  @override
  String modeCustomListSubtitleCount(int n) => '$n ayahs from different surahs';
  @override
  String get chooseSurah => 'Choose surah';
  @override
  String get ayahFrom => 'From ayah';
  @override
  String get ayahTo => 'To ayah';

  @override
  String get showTranslation => 'Show translation';
  @override
  String showTranslationSubtitle(String lang) => 'Translation in $lang under Arabic text';
  @override
  String get arabicOnlyNoTranslation => 'Arabic selected — translation not needed';

  @override
  String get showTafsir => 'Show tafsir';
  @override
  String get showTafsirSubtitle => 'Ayah interpretation by great scholars';
  @override
  String get tafsirPrimary => 'Primary tafsir';
  @override
  String get tafsirPrimarySubtitle => 'Classical tafsir — clear and detailed';
  @override
  String get tafsirSecondary => 'Secondary tafsir';
  @override
  String get tafsirSecondarySubtitle => 'In-depth tafsir';
  @override
  String tafsirLanguageInfo(String lang) =>
      'Tafsirs match the translation language: $lang. If no tafsir is available in this language, the Arabic original is shown.';

  @override
  String get autostart => 'Launch on OS startup';
  @override
  String get autostartSubtitle => 'App will start automatically when computer turns on';
  @override
  String get currentPlatform => 'Platform';

  @override
  String get chooseSurahTitle => 'Choose a surah';
  @override
  String get searchSurahHint => 'Search by name...';
  @override
  String get ayahCount => 'ayahs';
  @override
  String get meccan => 'Meccan';
  @override
  String get medinan => 'Medinan';

  @override
  String get myList => 'My list';
  @override
  String get myListSubtitle =>
      'Ayahs you are studying. They will be shown in rotation during breaks.';
  @override
  String get addAyah => 'Add ayah';
  @override
  String get addFirstAyah => 'Add your first ayah';
  @override
  String get listEmpty => 'List is empty';
  @override
  String get listEmptyHint => 'Add ayahs from different surahs that you want to study.';
  @override
  String get deleteFromList => 'Delete from list';
  @override
  String get deleted => 'Deleted';
  @override
  String ayahRemoved(String verseKey) => 'Ayah $verseKey removed';
  @override
  String totalAyahs(int n) => 'Total: $n ayah(s)';
  @override
  String get manageList => 'Manage list';
  @override
  String get selectSurahStep => 'Select a surah';
  @override
  String get enterAyahNumber => 'Ayah number';
  @override
  String enterAyahNumberHint(int max) => 'Enter number from 1 to $max';
  @override
  String get ayahAlreadyInList => 'This ayah is already in the list';
  @override
  String get ayahOutOfRange => 'Number is out of surah range';

  @override
  String get breakTitle => 'Break';
  @override
  String get skipBreak => 'Skip break';
  @override
  String get previous => 'Previous';
  @override
  String get next => 'Next';
  @override
  String get another => 'Another';
  @override
  String get tafsirOf => 'Tafsir';
  @override
  String get offline => 'offline';
  @override
  String get errorLoading => 'Loading error';
  @override
  String get checkConnection => 'Check your internet connection';

  @override
  String get chooseLanguageTitle => 'Choose a language';
  @override
  String get chooseLanguageSubtitle => 'You can change the language anytime in settings';
  @override
  String get continueText => 'Continue';
}
