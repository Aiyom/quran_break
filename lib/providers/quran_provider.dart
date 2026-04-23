import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import '../models/ayah_model.dart';
import '../services/quran_service.dart';
import '../services/tafsir_service.dart';

class QuranProvider extends ChangeNotifier {
  final QuranService _quran = QuranService();
  final TafsirService _tafsir = TafsirService();
  final Random _rand = Random();

  AyahModel? currentAyah;
  bool isLoading = false;
  String? error;
  bool isOffline = false;

  // Cached lists per mode
  List<AyahModel> surahAyahs = [];
  int? loadedSurah;
  int currentIndex = 0;

  List<AyahModel> rangeAyahs = [];
  int? rangeSurah;
  int? rangeStart;
  int? rangeEnd;

  List<AyahModel> customListAyahs = [];
  int customListSignature = 0;

  Future<void> loadContent(AppSettings s) async {
    isLoading = true;
    error = null;
    isOffline = false;
    notifyListeners();

    try {
      final edition = s.translationEdition;
      final showTranslation = s.showTranslation;
      final effectiveEdition = showTranslation ? edition : '';

      switch (s.contentMode) {
        case ContentMode.randomAyah:
          final n = _rand.nextInt(6236) + 1;
          currentAyah = await _quran.fetchAyah('$n', effectiveEdition);
          break;

        case ContentMode.randomSurah:
          if (surahAyahs.isEmpty) {
            final n = _rand.nextInt(114) + 1;
            surahAyahs = await _quran.fetchSurah(n, effectiveEdition);
            loadedSurah = n;
            currentIndex = _rand.nextInt(surahAyahs.length);
          } else {
            currentIndex = _rand.nextInt(surahAyahs.length);
          }
          currentAyah = surahAyahs[currentIndex];
          break;

        case ContentMode.specificSurah:
          if (surahAyahs.isEmpty || loadedSurah != s.specificSurahNumber) {
            surahAyahs = await _quran.fetchSurah(
              s.specificSurahNumber,
              effectiveEdition,
            );
            loadedSurah = s.specificSurahNumber;
            final prefs = await SharedPreferences.getInstance();
            currentIndex =
                prefs.getInt('pos_${s.specificSurahNumber}') ?? 0;
            if (currentIndex >= surahAyahs.length) currentIndex = 0;
          } else {
            currentIndex = (currentIndex + 1) % surahAyahs.length;
          }
          currentAyah = surahAyahs[currentIndex];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('pos_${s.specificSurahNumber}', currentIndex);
          break;

        case ContentMode.specificAyahs:
          if (rangeAyahs.isEmpty ||
              rangeSurah != s.specificSurahNumber ||
              rangeStart != s.specificAyahStart ||
              rangeEnd != s.specificAyahEnd) {
            rangeAyahs = await _quran.fetchRange(
              s.specificSurahNumber,
              s.specificAyahStart,
              s.specificAyahEnd,
              effectiveEdition,
            );
            rangeSurah = s.specificSurahNumber;
            rangeStart = s.specificAyahStart;
            rangeEnd = s.specificAyahEnd;
            currentIndex = 0;
          } else {
            currentIndex = _rand.nextInt(rangeAyahs.length);
          }
          currentAyah = rangeAyahs[currentIndex];
          break;

        case ContentMode.customList:
          if (s.customAyahList.isEmpty) {
            currentAyah = null;
            break;
          }
          final sig = Object.hashAll(s.customAyahList.map((e) => e.verseKey));
          if (customListAyahs.isEmpty || customListSignature != sig) {
            customListAyahs = [];
            for (final ref in s.customAyahList) {
              final a = await _quran.fetchAyah(
                ref.verseKey,
                effectiveEdition,
              );
              customListAyahs.add(a);
            }
            customListSignature = sig;
            currentIndex = 0;
          } else {
            currentIndex = (currentIndex + 1) % customListAyahs.length;
          }
          currentAyah = customListAyahs[currentIndex];
          break;
      }

      if (s.showTafsir && currentAyah != null) {
        unawaited(_loadTafsir(s));
      }

      if (currentAyah != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'cached_ayah',
          jsonEncode(currentAyah!.toJson()),
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('loadContent error: $e');
      error = e.toString();
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('cached_ayah');
      if (cached != null) {
        try {
          currentAyah = AyahModel.fromJson(
            jsonDecode(cached) as Map<String, dynamic>,
          );
          isOffline = true;
          error = null;
        } catch (_) {}
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNext(AppSettings s) async {
    switch (s.contentMode) {
      case ContentMode.randomAyah:
        await loadContent(s);
        break;
      case ContentMode.randomSurah:
      case ContentMode.specificSurah:
        if (surahAyahs.isEmpty) {
          await loadContent(s);
          return;
        }
        currentIndex = (currentIndex + 1) % surahAyahs.length;
        currentAyah = surahAyahs[currentIndex];
        if (s.showTafsir) unawaited(_loadTafsir(s));
        notifyListeners();
        break;
      case ContentMode.specificAyahs:
        if (rangeAyahs.isEmpty) {
          await loadContent(s);
          return;
        }
        currentIndex = (currentIndex + 1) % rangeAyahs.length;
        currentAyah = rangeAyahs[currentIndex];
        if (s.showTafsir) unawaited(_loadTafsir(s));
        notifyListeners();
        break;
      case ContentMode.customList:
        if (customListAyahs.isEmpty) {
          await loadContent(s);
          return;
        }
        currentIndex = (currentIndex + 1) % customListAyahs.length;
        currentAyah = customListAyahs[currentIndex];
        if (s.showTafsir) unawaited(_loadTafsir(s));
        notifyListeners();
        break;
    }
  }

  Future<void> loadPrevious(AppSettings s) async {
    final list = _currentListForMode(s.contentMode);
    if (list.isEmpty) {
      await loadContent(s);
      return;
    }
    currentIndex = (currentIndex - 1) % list.length;
    if (currentIndex < 0) currentIndex += list.length;
    currentAyah = list[currentIndex];
    if (s.showTafsir) unawaited(_loadTafsir(s));
    notifyListeners();
  }

  Future<void> loadAnother(AppSettings s) async {
    switch (s.contentMode) {
      case ContentMode.randomAyah:
        await loadContent(s);
        break;
      case ContentMode.randomSurah:
        surahAyahs = [];
        loadedSurah = null;
        await loadContent(s);
        break;
      case ContentMode.specificSurah:
        if (surahAyahs.isEmpty) {
          await loadContent(s);
          return;
        }
        currentIndex = _rand.nextInt(surahAyahs.length);
        currentAyah = surahAyahs[currentIndex];
        if (s.showTafsir) unawaited(_loadTafsir(s));
        notifyListeners();
        break;
      case ContentMode.specificAyahs:
        if (rangeAyahs.isEmpty) {
          await loadContent(s);
          return;
        }
        currentIndex = _rand.nextInt(rangeAyahs.length);
        currentAyah = rangeAyahs[currentIndex];
        if (s.showTafsir) unawaited(_loadTafsir(s));
        notifyListeners();
        break;
      case ContentMode.customList:
        if (customListAyahs.isEmpty) {
          await loadContent(s);
          return;
        }
        currentIndex = _rand.nextInt(customListAyahs.length);
        currentAyah = customListAyahs[currentIndex];
        if (s.showTafsir) unawaited(_loadTafsir(s));
        notifyListeners();
        break;
    }
  }

  List<AyahModel> _currentListForMode(ContentMode mode) {
    switch (mode) {
      case ContentMode.randomAyah:
        return currentAyah == null ? [] : [currentAyah!];
      case ContentMode.randomSurah:
      case ContentMode.specificSurah:
        return surahAyahs;
      case ContentMode.specificAyahs:
        return rangeAyahs;
      case ContentMode.customList:
        return customListAyahs;
    }
  }

  bool get canNavigatePreviousNext {
    if (currentAyah == null) return false;
    return true;
  }

  Future<void> _loadTafsir(AppSettings s) async {
    if (currentAyah == null) return;
    final id = s.tafsirChoice == TafsirChoice.primary
        ? s.primaryTafsirId
        : s.secondaryTafsirId;
    final verseKey =
        '${currentAyah!.surahNumber}:${currentAyah!.ayahNumberInSurah}';
    try {
      final text = await _tafsir.fetch(verseKey, id);
      if (currentAyah == null) return;
      if (currentAyah!.verseKey != verseKey) return;
      currentAyah = currentAyah!.copyWith(tafsirText: text);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('tafsir load error: $e');
    }
  }

  /// Force tafsir reload for current ayah (used when user toggles tafsir option).
  Future<void> reloadTafsirFor(AppSettings s) async {
    if (currentAyah == null) return;
    currentAyah = currentAyah!.copyWith(tafsirText: null);
    notifyListeners();
    await _loadTafsir(s);
  }

  /// Clear caches — e.g. when translation language changes.
  void clearCaches() {
    surahAyahs = [];
    loadedSurah = null;
    rangeAyahs = [];
    rangeSurah = null;
    rangeStart = null;
    rangeEnd = null;
    customListAyahs = [];
    customListSignature = 0;
    currentIndex = 0;
  }
}
