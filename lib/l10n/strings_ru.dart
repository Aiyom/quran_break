import 'app_locale.dart';

class StringsRu implements AppStrings {
  @override
  AppLocale get locale => AppLocale.ru;

  @override
  String get appName => 'Quran Break';
  @override
  String get loading => 'Загрузка...';
  @override
  String get cancel => 'Отмена';
  @override
  String get ok => 'ОК';
  @override
  String get save => 'Сохранить';
  @override
  String get delete => 'Удалить';
  @override
  String get undo => 'Отменить';
  @override
  String get add => 'Добавить';
  @override
  String get close => 'Закрыть';
  @override
  String get retry => 'Повторить';
  @override
  String get understood => 'Понятно';

  @override
  String get startTimer => 'Запустить';
  @override
  String get pauseTimer => 'Пауза';
  @override
  String get resumeTimer => 'Продолжить';
  @override
  String get nextBreakAt => 'Следующий перерыв в';
  @override
  String get timerStopped => 'Таймер остановлен';
  @override
  String get timeUntilBreak => 'до перерыва';
  @override
  String get welcomeTitle => 'Добро пожаловать!';
  @override
  String get welcomeText =>
      'Quran Break напоминает вам читать Коран во время перерывов. Настройте интервал и содержимое в ⚙ Настройках.';
  @override
  String get currentSettings => 'Текущие настройки';
  @override
  String get tapToChange => 'Нажмите чтобы изменить';

  @override
  String get showHide => 'Открыть / Скрыть';
  @override
  String get quit => 'Выйти';
  @override
  String get notificationTitle => '🕌 Время для перерыва';
  @override
  String get notificationBody => 'Откройте Quran Break для чтения аята';

  @override
  String get settings => 'Настройки';
  @override
  String get sectionLanguage => 'Язык';
  @override
  String get sectionSchedule => 'Расписание';
  @override
  String get sectionContent => 'Что показывать';
  @override
  String get sectionTranslation => 'Перевод';
  @override
  String get sectionTafsir => 'Тафсир (толкование)';
  @override
  String get sectionSystem => 'Система';

  @override
  String get interfaceLanguage => 'Язык интерфейса';
  @override
  String get interfaceLanguageSubtitle => 'Язык кнопок, меню и подсказок';
  @override
  String get translationLanguage => 'Язык перевода Корана';
  @override
  String get translationLanguageSubtitle =>
      'Перевод аятов будет на этом языке';
  @override
  String get noTranslation => 'Без перевода (только арабский)';

  @override
  String get breakEvery => 'Перерыв каждые';
  @override
  String get breakEverySubtitle => 'Как часто показывать аят';
  @override
  String get breakDuration => 'Длительность перерыва';
  @override
  String get breakDurationSubtitle =>
      'Сколько времени показывать аят на экране';
  @override
  String get minutesShort => 'мин';
  @override
  String get minutesWord => 'минут';
  @override
  String get showNotification => 'Показывать уведомление';
  @override
  String get showNotificationSubtitle =>
      'Системное уведомление перед перерывом';

  @override
  String get modeRandomAyah => 'Случайный аят';
  @override
  String get modeRandomAyahSubtitle =>
      'Каждый перерыв — новый аят из всего Корана';
  @override
  String get modeRandomSurah => 'Случайная сура';
  @override
  String get modeRandomSurahSubtitle =>
      'Каждый перерыв — аят из случайной суры';
  @override
  String get modeSpecificSurah => 'Конкретная сура';
  @override
  String get modeSpecificSurahSubtitle =>
      'Читайте одну суру по порядку, аят за аятом';
  @override
  String get modeSpecificAyahs => 'Конкретные аяты';
  @override
  String get modeSpecificAyahsSubtitle =>
      'Учите определённый отрывок — укажите диапазон';
  @override
  String get modeCustomList => 'Мой список';
  @override
  String get modeCustomListSubtitleEmpty =>
      'Список пуст — добавьте аяты';
  @override
  String modeCustomListSubtitleCount(int n) => '$n аятов из разных сур';
  @override
  String get chooseSurah => 'Выбрать суру';
  @override
  String get ayahFrom => 'С аята';
  @override
  String get ayahTo => 'По аят';

  @override
  String get showTranslation => 'Показывать перевод';
  @override
  String showTranslationSubtitle(String lang) =>
      'Перевод на $lang под арабским текстом';
  @override
  String get arabicOnlyNoTranslation =>
      'Выбран арабский — перевод не нужен';

  @override
  String get showTafsir => 'Показывать тафсир';
  @override
  String get showTafsirSubtitle => 'Толкование аята от великих учёных';
  @override
  String get tafsirPrimary => 'Основной тафсир';
  @override
  String get tafsirPrimarySubtitle =>
      'Классический тафсир — понятный и подробный';
  @override
  String get tafsirSecondary => 'Дополнительный тафсир';
  @override
  String get tafsirSecondarySubtitle => 'Углублённый тафсир';
  @override
  String tafsirLanguageInfo(String lang) =>
      'Тафсиры подобраны под язык перевода: $lang. Если на этом языке нет тафсира — показывается арабский оригинал.';

  @override
  String get autostart => 'Запуск при старте ОС';
  @override
  String get autostartSubtitle =>
      'Приложение запустится автоматически при включении компьютера';
  @override
  String get currentPlatform => 'Платформа';

  @override
  String get chooseSurahTitle => 'Выберите суру';
  @override
  String get searchSurahHint => 'Поиск по названию...';
  @override
  String get ayahCount => 'аятов';
  @override
  String get meccan => 'Мекканская';
  @override
  String get medinan => 'Мединская';

  @override
  String get myList => 'Мой список';
  @override
  String get myListSubtitle =>
      'Аяты, которые вы изучаете. Они будут показываться по очереди во время перерывов.';
  @override
  String get addAyah => 'Добавить аят';
  @override
  String get addFirstAyah => 'Добавить первый аят';
  @override
  String get listEmpty => 'Список пуст';
  @override
  String get listEmptyHint =>
      'Добавьте аяты из разных сур, которые хотите изучать.';
  @override
  String get deleteFromList => 'Удалить из списка';
  @override
  String get deleted => 'Удалено';
  @override
  String ayahRemoved(String verseKey) => 'Аят $verseKey удалён';
  @override
  String totalAyahs(int n) => 'Всего: $n аят(ов)';
  @override
  String get manageList => 'Управлять списком';
  @override
  String get selectSurahStep => 'Выберите суру';
  @override
  String get enterAyahNumber => 'Номер аята';
  @override
  String enterAyahNumberHint(int max) => 'Введите номер от 1 до $max';
  @override
  String get ayahAlreadyInList => 'Этот аят уже в списке';
  @override
  String get ayahOutOfRange => 'Номер вне диапазона суры';

  @override
  String get breakTitle => 'Перерыв';
  @override
  String get skipBreak => 'Пропустить перерыв';
  @override
  String get previous => 'Предыдущий';
  @override
  String get next => 'Следующий';
  @override
  String get another => 'Другой';
  @override
  String get tafsirOf => 'Тафсир';
  @override
  String get offline => 'офлайн';
  @override
  String get errorLoading => 'Ошибка загрузки';
  @override
  String get checkConnection => 'Проверьте соединение с интернетом';

  @override
  String get chooseLanguageTitle => 'Выберите язык';
  @override
  String get chooseLanguageSubtitle =>
      'Язык можно изменить в настройках в любое время';
  @override
  String get continueText => 'Продолжить';
}
