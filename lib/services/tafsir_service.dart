import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../l10n/app_locale.dart';
import '../models/app_settings.dart';

class TafsirService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.quranComBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
  ));

  /// Fetch tafsir text for a given verse key ("2:255") and tafsir ID.
  Future<String> fetch(String verseKey, int tafsirId) async {
    final resp = await _dio.get('/tafsirs/$tafsirId/by_ayah/$verseKey');
    final text = resp.data['tafsir']['text'] as String;
    return _cleanTafsir(text);
  }

  /// Fetch list of available tafsirs.
  Future<List<dynamic>> fetchTafsirList() async {
    final resp = await _dio.get('/resources/tafsirs');
    return resp.data['tafsirs'] as List;
  }

  /// Resolves tafsir IDs and names for the given translation locale.
  /// If a tafsir is not available in the target language, falls back to Arabic.
  Future<TafsirResolution> resolveTafsirs(AppLocale locale) async {
    final list = await fetchTafsirList();
    final apiLang = locale.apiLanguageName;

    final primary = _findTafsir(
      list,
      slugPattern: 'ibn-kathir',
      language: apiLang,
      fallbackId: ApiConstants.defaultIbnKathirTafsirId,
      fallbackName: 'Ibn Kathir',
    );

    String secondarySlug;
    if (apiLang == 'russian') {
      secondarySlug = 'al-muntakhab';
    } else if (apiLang == 'english') {
      secondarySlug = 'al-jalalayn';
    } else {
      secondarySlug = 'qurtubi';
    }

    final secondary = _findTafsir(
      list,
      slugPattern: secondarySlug,
      language: apiLang,
      fallbackId: ApiConstants.defaultQurtubiTafsirId,
      fallbackName: 'Qurtubi',
    );

    return TafsirResolution(
      primaryId: primary.id,
      primaryName: primary.name,
      secondaryId: secondary.id,
      secondaryName: secondary.name,
    );
  }

  _TafsirMatch _findTafsir(
    List list, {
    required String slugPattern,
    required String language,
    required int fallbackId,
    required String fallbackName,
  }) {
    // Try to find exact match: slug contains pattern AND language matches.
    for (final t in list) {
      final slug = '${t['slug']}';
      final lang = '${t['language_name']}';
      if (slug.contains(slugPattern) && lang == language) {
        return _TafsirMatch(
          id: t['id'] as int,
          name: (t['name'] ?? t['author_name'] ?? fallbackName) as String,
        );
      }
    }
    // Fallback: same pattern but Arabic language.
    for (final t in list) {
      final slug = '${t['slug']}';
      final lang = '${t['language_name']}';
      if (slug.contains(slugPattern) && lang == 'arabic') {
        return _TafsirMatch(
          id: t['id'] as int,
          name: (t['name'] ?? t['author_name'] ?? fallbackName) as String,
        );
      }
    }
    return _TafsirMatch(id: fallbackId, name: fallbackName);
  }

  String _cleanTafsir(String html) => html
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&quot;', '"')
      .trim();
}

class TafsirResolution {
  final int primaryId;
  final String primaryName;
  final int secondaryId;
  final String secondaryName;

  TafsirResolution({
    required this.primaryId,
    required this.primaryName,
    required this.secondaryId,
    required this.secondaryName,
  });
}

class _TafsirMatch {
  final int id;
  final String name;
  _TafsirMatch({required this.id, required this.name});
}

Future<void> initTafsirIdsIfNeeded(AppSettings settings) async {
  final needRefresh = !settings.tafsirIdsInitialized ||
      settings.tafsirIdsLocale != settings.translationLocale;
  if (!needRefresh) return;

  try {
    final svc = TafsirService();
    final res = await svc.resolveTafsirs(settings.translationLocale);
    settings
      ..primaryTafsirId = res.primaryId
      ..primaryTafsirName = res.primaryName
      ..secondaryTafsirId = res.secondaryId
      ..secondaryTafsirName = res.secondaryName
      ..tafsirIdsInitialized = true
      ..tafsirIdsLocale = settings.translationLocale;
    await settings.save();
  } catch (_) {
    // Use defaults if API call failed.
  }
}
