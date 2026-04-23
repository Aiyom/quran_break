import 'app_locale.dart';

class StringsUz implements AppStrings {
  @override
  AppLocale get locale => AppLocale.uz;

  @override
  String get appName => 'Quran Break';
  @override
  String get loading => 'Yuklanmoqda...';
  @override
  String get cancel => 'Bekor qilish';
  @override
  String get ok => 'OK';
  @override
  String get save => 'Saqlash';
  @override
  String get delete => 'Oʻchirish';
  @override
  String get undo => 'Qaytarish';
  @override
  String get add => 'Qoʻshish';
  @override
  String get close => 'Yopish';
  @override
  String get retry => 'Qayta urinish';
  @override
  String get understood => 'Tushundim';

  @override
  String get startTimer => 'Boshlash';
  @override
  String get pauseTimer => 'Pauza';
  @override
  String get resumeTimer => 'Davom ettirish';
  @override
  String get nextBreakAt => 'Keyingi tanaffus';
  @override
  String get timerStopped => 'Taymer toʻxtatildi';
  @override
  String get timeUntilBreak => 'tanaffusgacha';
  @override
  String get welcomeTitle => 'Xush kelibsiz!';
  @override
  String get welcomeText =>
      'Quran Break sizga tanaffus paytida Qurʼonni oʻqishni eslatadi. Interval va tarkibni ⚙ Sozlamalarda sozlang.';
  @override
  String get currentSettings => 'Joriy sozlamalar';
  @override
  String get tapToChange => 'Oʻzgartirish uchun bosing';

  @override
  String get showHide => 'Koʻrsatish / Yashirish';
  @override
  String get quit => 'Chiqish';
  @override
  String get notificationTitle => '🕌 Tanaffus vaqti';
  @override
  String get notificationBody => 'Oyatni oʻqish uchun Quran Break-ni oching';

  @override
  String get settings => 'Sozlamalar';
  @override
  String get sectionLanguage => 'Til';
  @override
  String get sectionSchedule => 'Jadval';
  @override
  String get sectionContent => 'Nima koʻrsatiladi';
  @override
  String get sectionTranslation => 'Tarjima';
  @override
  String get sectionTafsir => 'Tafsir';
  @override
  String get sectionSystem => 'Tizim';

  @override
  String get interfaceLanguage => 'Interfeys tili';
  @override
  String get interfaceLanguageSubtitle => 'Tugmalar, menyular va maslahatlar tili';
  @override
  String get translationLanguage => 'Qurʼon tarjima tili';
  @override
  String get translationLanguageSubtitle => 'Oyat tarjimasi shu tilda boʻladi';
  @override
  String get noTranslation => 'Tarjimasiz (faqat arab tilida)';

  @override
  String get breakEvery => 'Tanaffus har';
  @override
  String get breakEverySubtitle => 'Oyat qanchalik tez-tez koʻrsatilsin';
  @override
  String get breakDuration => 'Tanaffus davomiyligi';
  @override
  String get breakDurationSubtitle => 'Oyat ekranda qancha vaqt koʻrsatiladi';
  @override
  String get minutesShort => 'min';
  @override
  String get minutesWord => 'daqiqa';
  @override
  String get showNotification => 'Bildirishnoma koʻrsatish';
  @override
  String get showNotificationSubtitle => 'Tanaffusdan oldingi tizim bildirishnomasi';

  @override
  String get modeRandomAyah => 'Tasodifiy oyat';
  @override
  String get modeRandomAyahSubtitle => 'Har bir tanaffus — butun Qurʼondan yangi oyat';
  @override
  String get modeRandomSurah => 'Tasodifiy sura';
  @override
  String get modeRandomSurahSubtitle => 'Har bir tanaffus — tasodifiy suradan oyat';
  @override
  String get modeSpecificSurah => 'Maʼlum sura';
  @override
  String get modeSpecificSurahSubtitle => 'Bitta surani tartib bilan oʻqing';
  @override
  String get modeSpecificAyahs => 'Maʼlum oyatlar';
  @override
  String get modeSpecificAyahsSubtitle => 'Maʼlum parchani oʻrganing — oraliqni belgilang';
  @override
  String get modeCustomList => 'Mening roʻyxatim';
  @override
  String get modeCustomListSubtitleEmpty => 'Roʻyxat boʻsh — oyatlar qoʻshing';
  @override
  String modeCustomListSubtitleCount(int n) => 'Turli suralardan $n oyat';
  @override
  String get chooseSurah => 'Surani tanlash';
  @override
  String get ayahFrom => 'Oyatdan';
  @override
  String get ayahTo => 'Oyatgacha';

  @override
  String get showTranslation => 'Tarjimani koʻrsatish';
  @override
  String showTranslationSubtitle(String lang) => 'Arab matni ostida $lang tarjimasi';
  @override
  String get arabicOnlyNoTranslation => 'Arab tili tanlandi — tarjima kerak emas';

  @override
  String get showTafsir => 'Tafsirni koʻrsatish';
  @override
  String get showTafsirSubtitle => 'Buyuk olimlarning oyat tafsiri';
  @override
  String get tafsirPrimary => 'Asosiy tafsir';
  @override
  String get tafsirPrimarySubtitle => 'Klassik tafsir — tushunarli va batafsil';
  @override
  String get tafsirSecondary => 'Qoʻshimcha tafsir';
  @override
  String get tafsirSecondarySubtitle => 'Chuqur tafsir';
  @override
  String tafsirLanguageInfo(String lang) =>
      'Tafsirlar tarjima tiliga mos: $lang. Agar bu tilda tafsir boʻlmasa, arab asli koʻrsatiladi.';

  @override
  String get autostart => 'Tizim ishga tushganda avtomatik ishga tushirish';
  @override
  String get autostartSubtitle =>
      'Dastur kompyuter yoqilganda avtomatik ravishda ishga tushadi';
  @override
  String get currentPlatform => 'Tizim';

  @override
  String get chooseSurahTitle => 'Surani tanlang';
  @override
  String get searchSurahHint => 'Nomi boʻyicha qidirish...';
  @override
  String get ayahCount => 'oyat';
  @override
  String get meccan => 'Makkiy';
  @override
  String get medinan => 'Madaniy';

  @override
  String get myList => 'Mening roʻyxatim';
  @override
  String get myListSubtitle =>
      'Siz oʻrganayotgan oyatlar. Ular tanaffuslar davomida navbatma-navbat koʻrsatiladi.';
  @override
  String get addAyah => 'Oyat qoʻshish';
  @override
  String get addFirstAyah => 'Birinchi oyatni qoʻshing';
  @override
  String get listEmpty => 'Roʻyxat boʻsh';
  @override
  String get listEmptyHint => 'Oʻrganmoqchi boʻlgan oyatlaringizni turli suralardan qoʻshing.';
  @override
  String get deleteFromList => 'Roʻyxatdan oʻchirish';
  @override
  String get deleted => 'Oʻchirildi';
  @override
  String ayahRemoved(String verseKey) => '$verseKey oyati oʻchirildi';
  @override
  String totalAyahs(int n) => 'Jami: $n oyat';
  @override
  String get manageList => 'Roʻyxatni boshqarish';
  @override
  String get selectSurahStep => 'Surani tanlang';
  @override
  String get enterAyahNumber => 'Oyat raqami';
  @override
  String enterAyahNumberHint(int max) => '1 dan $max gacha raqam kiriting';
  @override
  String get ayahAlreadyInList => 'Bu oyat allaqachon roʻyxatda';
  @override
  String get ayahOutOfRange => 'Raqam sura diapazonidan tashqarida';

  @override
  String get breakTitle => 'Tanaffus';
  @override
  String get skipBreak => 'Tanaffusni oʻtkazib yuborish';
  @override
  String get previous => 'Oldingi';
  @override
  String get next => 'Keyingi';
  @override
  String get another => 'Boshqa';
  @override
  String get tafsirOf => 'Tafsir';
  @override
  String get offline => 'oflayn';
  @override
  String get errorLoading => 'Yuklash xatosi';
  @override
  String get checkConnection => 'Internet aloqangizni tekshiring';

  @override
  String get chooseLanguageTitle => 'Tilni tanlang';
  @override
  String get chooseLanguageSubtitle => 'Tilni istalgan vaqtda sozlamalarda oʻzgartira olasiz';
  @override
  String get continueText => 'Davom etish';
}
