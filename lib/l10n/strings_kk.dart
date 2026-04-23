import 'app_locale.dart';

class StringsKk implements AppStrings {
  @override
  AppLocale get locale => AppLocale.kk;

  @override
  String get appName => 'Quran Break';
  @override
  String get loading => 'Жүктелуде...';
  @override
  String get cancel => 'Болдырмау';
  @override
  String get ok => 'ОК';
  @override
  String get save => 'Сақтау';
  @override
  String get delete => 'Жою';
  @override
  String get undo => 'Кері қайтару';
  @override
  String get add => 'Қосу';
  @override
  String get close => 'Жабу';
  @override
  String get retry => 'Қайталау';
  @override
  String get understood => 'Түсінікті';

  @override
  String get startTimer => 'Бастау';
  @override
  String get pauseTimer => 'Кідірту';
  @override
  String get resumeTimer => 'Жалғастыру';
  @override
  String get nextBreakAt => 'Келесі үзіліс';
  @override
  String get timerStopped => 'Таймер тоқтатылды';
  @override
  String get timeUntilBreak => 'үзіліске дейін';
  @override
  String get welcomeTitle => 'Қош келдіңіз!';
  @override
  String get welcomeText =>
      'Quran Break сізге үзіліс кезінде Құранды оқуды еске салады. Аралық пен мазмұнды ⚙ Параметрлер бөлімінде баптаңыз.';
  @override
  String get currentSettings => 'Ағымдағы параметрлер';
  @override
  String get tapToChange => 'Өзгерту үшін басыңыз';

  @override
  String get showHide => 'Көрсету / Жасыру';
  @override
  String get quit => 'Шығу';
  @override
  String get notificationTitle => '🕌 Үзіліс уақыты';
  @override
  String get notificationBody => 'Аятты оқу үшін Quran Break-ті ашыңыз';

  @override
  String get settings => 'Параметрлер';
  @override
  String get sectionLanguage => 'Тіл';
  @override
  String get sectionSchedule => 'Кесте';
  @override
  String get sectionContent => 'Не көрсету';
  @override
  String get sectionTranslation => 'Аударма';
  @override
  String get sectionTafsir => 'Тәпсір';
  @override
  String get sectionSystem => 'Жүйе';

  @override
  String get interfaceLanguage => 'Интерфейс тілі';
  @override
  String get interfaceLanguageSubtitle => 'Түймелер, мәзірлер және кеңестер тілі';
  @override
  String get translationLanguage => 'Құран аудармасының тілі';
  @override
  String get translationLanguageSubtitle => 'Аяттар осы тілде көрсетіледі';
  @override
  String get noTranslation => 'Аудармасыз (тек араб тілі)';

  @override
  String get breakEvery => 'Үзіліс әр';
  @override
  String get breakEverySubtitle => 'Аятты қаншалықты жиі көрсету';
  @override
  String get breakDuration => 'Үзіліс ұзақтығы';
  @override
  String get breakDurationSubtitle => 'Аят экранда қанша уақыт көрсетіледі';
  @override
  String get minutesShort => 'мин';
  @override
  String get minutesWord => 'минут';
  @override
  String get showNotification => 'Хабарландыруды көрсету';
  @override
  String get showNotificationSubtitle => 'Үзіліс алдындағы жүйелік хабарландыру';

  @override
  String get modeRandomAyah => 'Кездейсоқ аят';
  @override
  String get modeRandomAyahSubtitle => 'Әр үзіліс — бүкіл Құраннан жаңа аят';
  @override
  String get modeRandomSurah => 'Кездейсоқ сүре';
  @override
  String get modeRandomSurahSubtitle => 'Әр үзіліс — кездейсоқ сүреден аят';
  @override
  String get modeSpecificSurah => 'Нақты сүре';
  @override
  String get modeSpecificSurahSubtitle => 'Бір сүрені ретімен оқыңыз';
  @override
  String get modeSpecificAyahs => 'Нақты аяттар';
  @override
  String get modeSpecificAyahsSubtitle => 'Белгілі бір үзіндіні үйреніңіз — аралықты белгілеңіз';
  @override
  String get modeCustomList => 'Менің тізімім';
  @override
  String get modeCustomListSubtitleEmpty => 'Тізім бос — аяттар қосыңыз';
  @override
  String modeCustomListSubtitleCount(int n) => '$n аят әртүрлі сүрелерден';
  @override
  String get chooseSurah => 'Сүрені таңдау';
  @override
  String get ayahFrom => 'Бастап';
  @override
  String get ayahTo => 'Дейін';

  @override
  String get showTranslation => 'Аударманы көрсету';
  @override
  String showTranslationSubtitle(String lang) => '$lang тіліндегі аударма араб мәтіні астында';
  @override
  String get arabicOnlyNoTranslation => 'Араб тілі таңдалды — аударма қажет емес';

  @override
  String get showTafsir => 'Тәпсірді көрсету';
  @override
  String get showTafsirSubtitle => 'Ұлы ғалымдардың аят тәпсірі';
  @override
  String get tafsirPrimary => 'Негізгі тәпсір';
  @override
  String get tafsirPrimarySubtitle => 'Классикалық тәпсір — түсінікті әрі толық';
  @override
  String get tafsirSecondary => 'Қосымша тәпсір';
  @override
  String get tafsirSecondarySubtitle => 'Терең тәпсір';
  @override
  String tafsirLanguageInfo(String lang) =>
      'Тәпсірлер аударма тіліне сәйкес: $lang. Осы тілде тәпсір жоқ болса, араб түпнұсқасы көрсетіледі.';

  @override
  String get autostart => 'Жүйе қосылғанда автоматты түрде іске қосу';
  @override
  String get autostartSubtitle => 'Қолданба компьютер қосылғанда автоматты түрде іске қосылады';
  @override
  String get currentPlatform => 'Жүйе';

  @override
  String get chooseSurahTitle => 'Сүрені таңдаңыз';
  @override
  String get searchSurahHint => 'Атауы бойынша іздеу...';
  @override
  String get ayahCount => 'аят';
  @override
  String get meccan => 'Мекке';
  @override
  String get medinan => 'Мәдина';

  @override
  String get myList => 'Менің тізімім';
  @override
  String get myListSubtitle =>
      'Сіз оқып жүрген аяттар. Олар үзіліс кезінде кезекпен көрсетіледі.';
  @override
  String get addAyah => 'Аят қосу';
  @override
  String get addFirstAyah => 'Алғашқы аятты қосыңыз';
  @override
  String get listEmpty => 'Тізім бос';
  @override
  String get listEmptyHint => 'Оқығыңыз келетін аяттарды әртүрлі сүрелерден қосыңыз.';
  @override
  String get deleteFromList => 'Тізімнен жою';
  @override
  String get deleted => 'Жойылды';
  @override
  String ayahRemoved(String verseKey) => '$verseKey аяты жойылды';
  @override
  String totalAyahs(int n) => 'Барлығы: $n аят';
  @override
  String get manageList => 'Тізімді басқару';
  @override
  String get selectSurahStep => 'Сүрені таңдаңыз';
  @override
  String get enterAyahNumber => 'Аят нөмірі';
  @override
  String enterAyahNumberHint(int max) => '1-ден $max-ке дейінгі нөмірді енгізіңіз';
  @override
  String get ayahAlreadyInList => 'Бұл аят тізімде бар';
  @override
  String get ayahOutOfRange => 'Нөмір сүре ауқымынан тыс';

  @override
  String get breakTitle => 'Үзіліс';
  @override
  String get skipBreak => 'Үзілісті өткізіп жіберу';
  @override
  String get previous => 'Алдыңғы';
  @override
  String get next => 'Келесі';
  @override
  String get another => 'Басқа';
  @override
  String get tafsirOf => 'Тәпсір';
  @override
  String get offline => 'офлайн';
  @override
  String get errorLoading => 'Жүктеу қатесі';
  @override
  String get checkConnection => 'Интернет байланысын тексеріңіз';

  @override
  String get chooseLanguageTitle => 'Тілді таңдаңыз';
  @override
  String get chooseLanguageSubtitle => 'Тілді кез келген уақытта параметрлерден өзгертуге болады';
  @override
  String get continueText => 'Жалғастыру';
}
