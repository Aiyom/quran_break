import 'app_locale.dart';
import 'strings_ru.dart';
import 'strings_tg.dart';
import 'strings_en.dart';
import 'strings_kk.dart';
import 'strings_ky.dart';
import 'strings_uz.dart';
import 'strings_ar.dart';

AppStrings getStrings(AppLocale locale) => switch (locale) {
      AppLocale.ru => StringsRu(),
      AppLocale.tg => StringsTg(),
      AppLocale.en => StringsEn(),
      AppLocale.kk => StringsKk(),
      AppLocale.ky => StringsKy(),
      AppLocale.uz => StringsUz(),
      AppLocale.ar => StringsAr(),
    };
