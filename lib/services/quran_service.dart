import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../models/ayah_model.dart';

class QuranService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.alquranBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
  ));

  /// Fetch a single ayah by reference ("1:1" or absolute number like "262").
  /// If [translationEdition] is empty — fetches only Arabic.
  Future<AyahModel> fetchAyah(String reference, String translationEdition) async {
    final editions = translationEdition.isEmpty
        ? ApiConstants.arabicEdition
        : '${ApiConstants.arabicEdition},$translationEdition';
    final resp = await _dio.get('/ayah/$reference/editions/$editions');
    return _parseAyahResponse(resp.data);
  }

  /// Fetch entire surah with ayahs, Arabic + translation (or only Arabic).
  Future<List<AyahModel>> fetchSurah(
      int surahNumber, String translationEdition) async {
    final editions = translationEdition.isEmpty
        ? ApiConstants.arabicEdition
        : '${ApiConstants.arabicEdition},$translationEdition';
    final resp = await _dio.get('/surah/$surahNumber/editions/$editions');
    return _parseSurahResponse(resp.data);
  }

  /// Fetch a range of ayahs within a surah.
  Future<List<AyahModel>> fetchRange(
    int surahNumber,
    int start,
    int end,
    String translationEdition,
  ) async {
    final ayahs = <AyahModel>[];
    for (int i = start; i <= end; i++) {
      final ayah = await fetchAyah('$surahNumber:$i', translationEdition);
      ayahs.add(ayah);
    }
    return ayahs;
  }

  AyahModel _parseAyahResponse(Map<String, dynamic> data) {
    final result = data['data'];
    if (result is List) {
      final arabic = result.firstWhere(
        (e) => e['edition']['identifier'] == ApiConstants.arabicEdition,
        orElse: () => result.first,
      ) as Map<String, dynamic>;
      Map<String, dynamic>? translation;
      if (result.length > 1) {
        translation = result.firstWhere(
          (e) => e['edition']['identifier'] != ApiConstants.arabicEdition,
          orElse: () => null,
        ) as Map<String, dynamic>?;
      }
      return AyahModel.fromApi(
        arabicEntry: arabic,
        translationEntry: translation,
      );
    } else {
      return AyahModel.fromApi(arabicEntry: result as Map<String, dynamic>);
    }
  }

  List<AyahModel> _parseSurahResponse(Map<String, dynamic> data) {
    final result = data['data'];
    if (result is List) {
      // Two editions: array of 2 surah objects
      final arabicSurah = result.firstWhere(
        (e) => e['edition']['identifier'] == ApiConstants.arabicEdition,
      ) as Map<String, dynamic>;
      Map<String, dynamic>? translationSurah;
      if (result.length > 1) {
        translationSurah = result.firstWhere(
          (e) => e['edition']['identifier'] != ApiConstants.arabicEdition,
          orElse: () => null,
        ) as Map<String, dynamic>?;
      }
      final arabicAyahs = arabicSurah['ayahs'] as List;
      final translationAyahs = translationSurah?['ayahs'] as List?;

      return List.generate(arabicAyahs.length, (i) {
        final ar = arabicAyahs[i] as Map<String, dynamic>;
        final tr = translationAyahs?[i] as Map<String, dynamic>?;
        final arWithSurah = Map<String, dynamic>.from(ar)
          ..['surah'] = {
            'number': arabicSurah['number'],
            'name': arabicSurah['name'],
            'englishName': arabicSurah['englishName'],
            'numberOfAyahs': arabicSurah['numberOfAyahs'],
          };
        return AyahModel.fromApi(
          arabicEntry: arWithSurah,
          translationEntry: tr,
        );
      });
    } else {
      // Single edition
      final surah = result as Map<String, dynamic>;
      final ayahs = surah['ayahs'] as List;
      return ayahs.map((a) {
        final arWithSurah = Map<String, dynamic>.from(a as Map<String, dynamic>)
          ..['surah'] = {
            'number': surah['number'],
            'name': surah['name'],
            'englishName': surah['englishName'],
            'numberOfAyahs': surah['numberOfAyahs'],
          };
        return AyahModel.fromApi(arabicEntry: arWithSurah);
      }).toList();
    }
  }
}
