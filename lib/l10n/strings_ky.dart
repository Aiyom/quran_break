import 'app_locale.dart';

class StringsKy implements AppStrings {
  @override
  AppLocale get locale => AppLocale.ky;

  @override
  String get appName => 'Quran Break';
  @override
  String get loading => 'Жүктөлүүдө...';
  @override
  String get cancel => 'Жокко чыгаруу';
  @override
  String get ok => 'ОК';
  @override
  String get save => 'Сактоо';
  @override
  String get delete => 'Өчүрүү';
  @override
  String get undo => 'Кайра кайтаруу';
  @override
  String get add => 'Кошуу';
  @override
  String get close => 'Жабуу';
  @override
  String get retry => 'Кайталоо';
  @override
  String get understood => 'Түшүнүктүү';

  @override
  String get startTimer => 'Баштоо';
  @override
  String get pauseTimer => 'Тыныгуу';
  @override
  String get resumeTimer => 'Улантуу';
  @override
  String get nextBreakAt => 'Кийинки танафыс';
  @override
  String get timerStopped => 'Таймер токтотулду';
  @override
  String get timeUntilBreak => 'танафыска чейин';
  @override
  String get welcomeTitle => 'Кош келиңиз!';
  @override
  String get welcomeText =>
      'Quran Break сизге танафыс убагында Куранды окууну эске салат. Аралыкты жана мазмунду ⚙ Жөндөөлөрдөн тууралаңыз.';
  @override
  String get currentSettings => 'Азыркы жөндөөлөр';
  @override
  String get tapToChange => 'Өзгөртүү үчүн басыңыз';

  @override
  String get showHide => 'Көрсөтүү / Жашыруу';
  @override
  String get quit => 'Чыгуу';
  @override
  String get notificationTitle => '🕌 Танафыс убагы';
  @override
  String get notificationBody => 'Аятты окуу үчүн Quran Break-ти ачыңыз';

  @override
  String get settings => 'Жөндөөлөр';
  @override
  String get sectionLanguage => 'Тил';
  @override
  String get sectionSchedule => 'Графиги';
  @override
  String get sectionContent => 'Эмне көрсөтүлсүн';
  @override
  String get sectionTranslation => 'Котормо';
  @override
  String get sectionTafsir => 'Тафсир';
  @override
  String get sectionSystem => 'Система';

  @override
  String get interfaceLanguage => 'Интерфейс тили';
  @override
  String get interfaceLanguageSubtitle => 'Баскычтар, меню жана кеңештердин тили';
  @override
  String get translationLanguage => 'Курандын которулган тили';
  @override
  String get translationLanguageSubtitle => 'Аяттардын котормосу ушул тилде болот';
  @override
  String get noTranslation => 'Котормосуз (араб тилинде гана)';

  @override
  String get breakEvery => 'Танафыс ар';
  @override
  String get breakEverySubtitle => 'Канчалык көп аят көрсөтүлсүн';
  @override
  String get breakDuration => 'Танафыс узактыгы';
  @override
  String get breakDurationSubtitle => 'Аят экранда канча убакытка көрсөтүлөт';
  @override
  String get minutesShort => 'мүн';
  @override
  String get minutesWord => 'мүнөт';
  @override
  String get showNotification => 'Билдирүү көрсөтүү';
  @override
  String get showNotificationSubtitle => 'Танафыстан мурдагы системдик билдирүү';

  @override
  String get modeRandomAyah => 'Кокустан аят';
  @override
  String get modeRandomAyahSubtitle => 'Ар бир танафыс — бүт Курандан жаңы аят';
  @override
  String get modeRandomSurah => 'Кокустан сүрө';
  @override
  String get modeRandomSurahSubtitle => 'Ар бир танафыс — кокустан сүрөдөн аят';
  @override
  String get modeSpecificSurah => 'Белгилүү сүрө';
  @override
  String get modeSpecificSurahSubtitle => 'Бир сүрөнү тартип менен окуңуз';
  @override
  String get modeSpecificAyahs => 'Белгилүү аяттар';
  @override
  String get modeSpecificAyahsSubtitle => 'Белгилүү бир үзүндүнү үйрөнүңүз — диапазонду белгилеңиз';
  @override
  String get modeCustomList => 'Менин тизмем';
  @override
  String get modeCustomListSubtitleEmpty => 'Тизме бош — аяттарды кошуңуз';
  @override
  String modeCustomListSubtitleCount(int n) => 'Ар түрдүү сүрөлөрдөн $n аят';
  @override
  String get chooseSurah => 'Сүрөнү тандоо';
  @override
  String get ayahFrom => 'Аяттан';
  @override
  String get ayahTo => 'Аятка чейин';

  @override
  String get showTranslation => 'Котормону көрсөтүү';
  @override
  String showTranslationSubtitle(String lang) => '$lang тилиндеги котормо араб текстинин астында';
  @override
  String get arabicOnlyNoTranslation => 'Араб тили тандалды — котормо керек эмес';

  @override
  String get showTafsir => 'Тафсирди көрсөтүү';
  @override
  String get showTafsirSubtitle => 'Улуу окумуштуулардын аят тафсири';
  @override
  String get tafsirPrimary => 'Негизги тафсир';
  @override
  String get tafsirPrimarySubtitle => 'Классикалык тафсир — түшүнүктүү жана толук';
  @override
  String get tafsirSecondary => 'Кошумча тафсир';
  @override
  String get tafsirSecondarySubtitle => 'Тереңдетилген тафсир';
  @override
  String tafsirLanguageInfo(String lang) =>
      'Тафсирлер котормо тилине ылайык: $lang. Эгер бул тилде тафсир жок болсо, араб оригиналы көрсөтүлөт.';

  @override
  String get autostart => 'Система иштеп баштаганда жүктөө';
  @override
  String get autostartSubtitle => 'Колдонмо компьютер күйгөндө автоматтык түрдө ишке кирет';
  @override
  String get currentPlatform => 'Система';

  @override
  String get chooseSurahTitle => 'Сүрөнү тандаңыз';
  @override
  String get searchSurahHint => 'Аты боюнча издөө...';
  @override
  String get ayahCount => 'аят';
  @override
  String get meccan => 'Меккелик';
  @override
  String get medinan => 'Мединалык';

  @override
  String get myList => 'Менин тизмем';
  @override
  String get myListSubtitle =>
      'Сиз үйрөнүп жаткан аяттар. Алар танафыстар учурунда кезеги менен көрсөтүлөт.';
  @override
  String get addAyah => 'Аят кошуу';
  @override
  String get addFirstAyah => 'Биринчи аятты кошуңуз';
  @override
  String get listEmpty => 'Тизме бош';
  @override
  String get listEmptyHint => 'Үйрөнгүңүз келген аяттарды ар кандай сүрөлөрдөн кошуңуз.';
  @override
  String get deleteFromList => 'Тизмеден өчүрүү';
  @override
  String get deleted => 'Өчүрүлдү';
  @override
  String ayahRemoved(String verseKey) => '$verseKey аяты өчүрүлдү';
  @override
  String totalAyahs(int n) => 'Бардыгы: $n аят';
  @override
  String get manageList => 'Тизмени башкаруу';
  @override
  String get selectSurahStep => 'Сүрөнү тандаңыз';
  @override
  String get enterAyahNumber => 'Аяттын номери';
  @override
  String enterAyahNumberHint(int max) => '1-ден $max-ге чейинки номерди киргизиңиз';
  @override
  String get ayahAlreadyInList => 'Бул аят тизмеде бар';
  @override
  String get ayahOutOfRange => 'Номер сүрөнүн диапазонунан сырткары';

  @override
  String get breakTitle => 'Танафыс';
  @override
  String get skipBreak => 'Танафысты өткөрүп жиберүү';
  @override
  String get previous => 'Мурунку';
  @override
  String get next => 'Кийинки';
  @override
  String get another => 'Башка';
  @override
  String get tafsirOf => 'Тафсир';
  @override
  String get offline => 'офлайн';
  @override
  String get errorLoading => 'Жүктөө катасы';
  @override
  String get checkConnection => 'Интернет байланышыңызды текшериңиз';

  @override
  String get chooseLanguageTitle => 'Тилди тандаңыз';
  @override
  String get chooseLanguageSubtitle => 'Тилди каалаган убакта жөндөөлөрдөн өзгөртө аласыз';
  @override
  String get continueText => 'Уландыруу';
}
