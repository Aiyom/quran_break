import 'app_locale.dart';

class StringsAr implements AppStrings {
  @override
  AppLocale get locale => AppLocale.ar;

  @override
  String get appName => 'Quran Break';
  @override
  String get loading => 'جارٍ التحميل...';
  @override
  String get cancel => 'إلغاء';
  @override
  String get ok => 'موافق';
  @override
  String get save => 'حفظ';
  @override
  String get delete => 'حذف';
  @override
  String get undo => 'تراجع';
  @override
  String get add => 'إضافة';
  @override
  String get close => 'إغلاق';
  @override
  String get retry => 'إعادة المحاولة';
  @override
  String get understood => 'فهمت';

  @override
  String get startTimer => 'ابدأ';
  @override
  String get pauseTimer => 'إيقاف مؤقت';
  @override
  String get resumeTimer => 'استئناف';
  @override
  String get nextBreakAt => 'الاستراحة التالية في';
  @override
  String get timerStopped => 'المؤقت متوقف';
  @override
  String get timeUntilBreak => 'حتى الاستراحة';
  @override
  String get welcomeTitle => 'مرحبًا!';
  @override
  String get welcomeText =>
      'يذكّرك Quran Break بقراءة القرآن أثناء الاستراحات. اضبط الفاصل الزمني والمحتوى في ⚙ الإعدادات.';
  @override
  String get currentSettings => 'الإعدادات الحالية';
  @override
  String get tapToChange => 'انقر للتغيير';

  @override
  String get showHide => 'إظهار / إخفاء';
  @override
  String get quit => 'خروج';
  @override
  String get notificationTitle => '🕌 وقت الاستراحة';
  @override
  String get notificationBody => 'افتح Quran Break لقراءة آية';

  @override
  String get settings => 'الإعدادات';
  @override
  String get sectionLanguage => 'اللغة';
  @override
  String get sectionSchedule => 'الجدول';
  @override
  String get sectionContent => 'ماذا تُعرض';
  @override
  String get sectionTranslation => 'الترجمة';
  @override
  String get sectionTafsir => 'التفسير';
  @override
  String get sectionSystem => 'النظام';

  @override
  String get interfaceLanguage => 'لغة الواجهة';
  @override
  String get interfaceLanguageSubtitle => 'لغة الأزرار والقوائم والتلميحات';
  @override
  String get translationLanguage => 'لغة ترجمة القرآن';
  @override
  String get translationLanguageSubtitle => 'ستُعرض ترجمة الآيات بهذه اللغة';
  @override
  String get noTranslation => 'بدون ترجمة (العربية فقط)';

  @override
  String get breakEvery => 'استراحة كل';
  @override
  String get breakEverySubtitle => 'كم مرة تُعرض الآية';
  @override
  String get breakDuration => 'مدة الاستراحة';
  @override
  String get breakDurationSubtitle => 'كم من الوقت تُعرض الآية على الشاشة';
  @override
  String get minutesShort => 'د';
  @override
  String get minutesWord => 'دقائق';
  @override
  String get showNotification => 'إظهار التنبيه';
  @override
  String get showNotificationSubtitle => 'تنبيه النظام قبل الاستراحة';

  @override
  String get modeRandomAyah => 'آية عشوائية';
  @override
  String get modeRandomAyahSubtitle => 'كل استراحة — آية جديدة من القرآن كله';
  @override
  String get modeRandomSurah => 'سورة عشوائية';
  @override
  String get modeRandomSurahSubtitle => 'كل استراحة — آية من سورة عشوائية';
  @override
  String get modeSpecificSurah => 'سورة محددة';
  @override
  String get modeSpecificSurahSubtitle => 'اقرأ سورة واحدة بالترتيب، آية آية';
  @override
  String get modeSpecificAyahs => 'آيات محددة';
  @override
  String get modeSpecificAyahsSubtitle => 'احفظ مقطعًا معينًا — حدد النطاق';
  @override
  String get modeCustomList => 'قائمتي';
  @override
  String get modeCustomListSubtitleEmpty => 'القائمة فارغة — أضف آيات';
  @override
  String modeCustomListSubtitleCount(int n) => '$n آيات من سور مختلفة';
  @override
  String get chooseSurah => 'اختر سورة';
  @override
  String get ayahFrom => 'من الآية';
  @override
  String get ayahTo => 'إلى الآية';

  @override
  String get showTranslation => 'إظهار الترجمة';
  @override
  String showTranslationSubtitle(String lang) => 'ترجمة بـ$lang تحت النص العربي';
  @override
  String get arabicOnlyNoTranslation => 'تم اختيار العربية — لا حاجة للترجمة';

  @override
  String get showTafsir => 'إظهار التفسير';
  @override
  String get showTafsirSubtitle => 'تفسير الآية من كبار العلماء';
  @override
  String get tafsirPrimary => 'التفسير الرئيسي';
  @override
  String get tafsirPrimarySubtitle => 'تفسير كلاسيكي — واضح ومفصل';
  @override
  String get tafsirSecondary => 'التفسير الإضافي';
  @override
  String get tafsirSecondarySubtitle => 'تفسير معمق';
  @override
  String tafsirLanguageInfo(String lang) =>
      'التفاسير مختارة حسب لغة الترجمة: $lang. إذا لم يتوفر تفسير بهذه اللغة — يُعرض الأصل العربي.';

  @override
  String get autostart => 'التشغيل عند بدء النظام';
  @override
  String get autostartSubtitle => 'يبدأ التطبيق تلقائيًا عند تشغيل الحاسوب';
  @override
  String get currentPlatform => 'النظام';

  @override
  String get chooseSurahTitle => 'اختر سورة';
  @override
  String get searchSurahHint => 'ابحث بالاسم...';
  @override
  String get ayahCount => 'آيات';
  @override
  String get meccan => 'مكية';
  @override
  String get medinan => 'مدنية';

  @override
  String get myList => 'قائمتي';
  @override
  String get myListSubtitle =>
      'الآيات التي تدرسها. ستُعرض بالتناوب أثناء الاستراحات.';
  @override
  String get addAyah => 'إضافة آية';
  @override
  String get addFirstAyah => 'أضف أول آية';
  @override
  String get listEmpty => 'القائمة فارغة';
  @override
  String get listEmptyHint => 'أضف آيات من سور مختلفة تريد دراستها.';
  @override
  String get deleteFromList => 'حذف من القائمة';
  @override
  String get deleted => 'تم الحذف';
  @override
  String ayahRemoved(String verseKey) => 'تم حذف الآية $verseKey';
  @override
  String totalAyahs(int n) => 'الإجمالي: $n آية';
  @override
  String get manageList => 'إدارة القائمة';
  @override
  String get selectSurahStep => 'اختر سورة';
  @override
  String get enterAyahNumber => 'رقم الآية';
  @override
  String enterAyahNumberHint(int max) => 'أدخل رقمًا من 1 إلى $max';
  @override
  String get ayahAlreadyInList => 'هذه الآية موجودة بالفعل في القائمة';
  @override
  String get ayahOutOfRange => 'الرقم خارج نطاق السورة';

  @override
  String get breakTitle => 'استراحة';
  @override
  String get skipBreak => 'تخطي الاستراحة';
  @override
  String get previous => 'السابق';
  @override
  String get next => 'التالي';
  @override
  String get another => 'آخر';
  @override
  String get tafsirOf => 'التفسير';
  @override
  String get offline => 'غير متصل';
  @override
  String get errorLoading => 'خطأ في التحميل';
  @override
  String get checkConnection => 'تحقق من اتصالك بالإنترنت';

  @override
  String get chooseLanguageTitle => 'اختر اللغة';
  @override
  String get chooseLanguageSubtitle => 'يمكنك تغيير اللغة في الإعدادات في أي وقت';
  @override
  String get continueText => 'متابعة';
}
