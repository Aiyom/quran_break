import 'app_locale.dart';

class StringsTg implements AppStrings {
  @override
  AppLocale get locale => AppLocale.tg;

  @override
  String get appName => 'Quran Break';
  @override
  String get loading => 'Боркунӣ...';
  @override
  String get cancel => 'Бекор кардан';
  @override
  String get ok => 'ОК';
  @override
  String get save => 'Захира кардан';
  @override
  String get delete => 'Несткунӣ';
  @override
  String get undo => 'Баргардонидан';
  @override
  String get add => 'Илова кардан';
  @override
  String get close => 'Пӯшидан';
  @override
  String get retry => 'Бори дигар кӯшиш кунед';
  @override
  String get understood => 'Фаҳмидам';

  @override
  String get startTimer => 'Оғоз кардан';
  @override
  String get pauseTimer => 'Таваққуф';
  @override
  String get resumeTimer => 'Идома додан';
  @override
  String get nextBreakAt => 'Танаффуси навбатӣ дар';
  @override
  String get timerStopped => 'Таймер хомӯш аст';
  @override
  String get timeUntilBreak => 'то танаффус';
  @override
  String get welcomeTitle => 'Хуш омадед!';
  @override
  String get welcomeText =>
      'Quran Break ба шумо хотиррасон мекунад, ки дар вақти танаффус Қуръон хонед. Фосила ва мундариҷаро дар ⚙ Танзимот танзим кунед.';
  @override
  String get currentSettings => 'Танзимоти ҷорӣ';
  @override
  String get tapToChange => 'Барои тағйир додан пахш кунед';

  @override
  String get showHide => 'Нишон додан / Пинҳон кардан';
  @override
  String get quit => 'Баромадан';
  @override
  String get notificationTitle => '🕌 Вақти танаффус';
  @override
  String get notificationBody => 'Барои хондани оят Quran Break-ро кушоед';

  @override
  String get settings => 'Танзимот';
  @override
  String get sectionLanguage => 'Забон';
  @override
  String get sectionSchedule => 'Ҷадвал';
  @override
  String get sectionContent => 'Чӣ нишон дода шавад';
  @override
  String get sectionTranslation => 'Тарҷума';
  @override
  String get sectionTafsir => 'Тафсир';
  @override
  String get sectionSystem => 'Система';

  @override
  String get interfaceLanguage => 'Забони интерфейс';
  @override
  String get interfaceLanguageSubtitle => 'Забони тугмаҳо, менюҳо ва маслиҳатҳо';
  @override
  String get translationLanguage => 'Забони тарҷумаи Қуръон';
  @override
  String get translationLanguageSubtitle =>
      'Тарҷумаи оятҳо бо ин забон нишон дода мешавад';
  @override
  String get noTranslation => 'Бе тарҷума (танҳо арабӣ)';

  @override
  String get breakEvery => 'Танаффус ҳар';
  @override
  String get breakEverySubtitle => 'Чанд вақт як бор оятро нишон диҳад';
  @override
  String get breakDuration => 'Давомнокии танаффус';
  @override
  String get breakDurationSubtitle => 'Чанд вақт оят дар экран нишон дода шавад';
  @override
  String get minutesShort => 'д';
  @override
  String get minutesWord => 'дақиқа';
  @override
  String get showNotification => 'Огоҳӣ нишон додан';
  @override
  String get showNotificationSubtitle => 'Огоҳии система пеш аз танаффус';

  @override
  String get modeRandomAyah => 'Ояти тасодуфӣ';
  @override
  String get modeRandomAyahSubtitle => 'Ҳар танаффус — ояти нав аз тамоми Қуръон';
  @override
  String get modeRandomSurah => 'Сураи тасодуфӣ';
  @override
  String get modeRandomSurahSubtitle => 'Ҳар танаффус — оят аз сураи тасодуфӣ';
  @override
  String get modeSpecificSurah => 'Сураи мушаххас';
  @override
  String get modeSpecificSurahSubtitle => 'Як сураро тартиб ба тартиб хонед';
  @override
  String get modeSpecificAyahs => 'Оятҳои мушаххас';
  @override
  String get modeSpecificAyahsSubtitle => 'Қисмати муайянро ёд гиред — доираро нишон диҳед';
  @override
  String get modeCustomList => 'Рӯйхати ман';
  @override
  String get modeCustomListSubtitleEmpty => 'Рӯйхат холӣ — оятҳо илова кунед';
  @override
  String modeCustomListSubtitleCount(int n) => '$n оят аз сураҳои гуногун';
  @override
  String get chooseSurah => 'Интихоби сура';
  @override
  String get ayahFrom => 'Аз ояти';
  @override
  String get ayahTo => 'То ояти';

  @override
  String get showTranslation => 'Тарҷумаро нишон додан';
  @override
  String showTranslationSubtitle(String lang) => 'Тарҷума ба $lang дар зери матни арабӣ';
  @override
  String get arabicOnlyNoTranslation => 'Арабӣ интихоб шуд — тарҷума лозим нест';

  @override
  String get showTafsir => 'Тафсирро нишон додан';
  @override
  String get showTafsirSubtitle => 'Тафсири оят аз олимони бузург';
  @override
  String get tafsirPrimary => 'Тафсири асосӣ';
  @override
  String get tafsirPrimarySubtitle => 'Тафсири классикӣ — фаҳмо ва муфассал';
  @override
  String get tafsirSecondary => 'Тафсири иловагӣ';
  @override
  String get tafsirSecondarySubtitle => 'Тафсири амиқ';
  @override
  String tafsirLanguageInfo(String lang) =>
      'Тафсирҳо мувофиқи забони тарҷума: $lang. Агар тафсир бо ин забон набошад, асли арабӣ нишон дода мешавад.';

  @override
  String get autostart => 'Оғоз ҳангоми фаъолсозии система';
  @override
  String get autostartSubtitle => 'Барнома ҳангоми фаъолсозии компютер худкор оғоз мешавад';
  @override
  String get currentPlatform => 'Система';

  @override
  String get chooseSurahTitle => 'Сураро интихоб кунед';
  @override
  String get searchSurahHint => 'Ҷустуҷӯ аз рӯйи ном...';
  @override
  String get ayahCount => 'оят';
  @override
  String get meccan => 'Маккӣ';
  @override
  String get medinan => 'Маданӣ';

  @override
  String get myList => 'Рӯйхати ман';
  @override
  String get myListSubtitle =>
      'Оятҳое, ки омӯхта истодаед. Онҳо ҳангоми танаффусҳо навбатӣ нишон дода мешаванд.';
  @override
  String get addAyah => 'Илова кардани оят';
  @override
  String get addFirstAyah => 'Аввалин оятро илова кунед';
  @override
  String get listEmpty => 'Рӯйхат холӣ';
  @override
  String get listEmptyHint => 'Оятҳо аз сураҳои гуногун илова кунед.';
  @override
  String get deleteFromList => 'Аз рӯйхат несткунӣ';
  @override
  String get deleted => 'Несткунӣ шуд';
  @override
  String ayahRemoved(String verseKey) => 'Ояти $verseKey несткунӣ шуд';
  @override
  String totalAyahs(int n) => 'Ҳамагӣ: $n оят';
  @override
  String get manageList => 'Идора кардани рӯйхат';
  @override
  String get selectSurahStep => 'Сураро интихоб кунед';
  @override
  String get enterAyahNumber => 'Рақами оят';
  @override
  String enterAyahNumberHint(int max) => 'Аз 1 то $max ворид кунед';
  @override
  String get ayahAlreadyInList => 'Ин оят аллакай дар рӯйхат аст';
  @override
  String get ayahOutOfRange => 'Рақам аз доираи сура берун аст';

  @override
  String get breakTitle => 'Танаффус';
  @override
  String get skipBreak => 'Танаффусро гузаронидан';
  @override
  String get previous => 'Қаблӣ';
  @override
  String get next => 'Навбатӣ';
  @override
  String get another => 'Дигар';
  @override
  String get tafsirOf => 'Тафсир';
  @override
  String get offline => 'офлайн';
  @override
  String get errorLoading => 'Хатои боркунӣ';
  @override
  String get checkConnection => 'Пайвастагиро бо интернет санҷед';

  @override
  String get chooseLanguageTitle => 'Забонро интихоб кунед';
  @override
  String get chooseLanguageSubtitle =>
      'Забонро дар ҳар вақт дар танзимот тағйир дода метавонед';
  @override
  String get continueText => 'Идома';
}
