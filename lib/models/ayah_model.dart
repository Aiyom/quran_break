class AyahModel {
  final int absoluteNumber;
  final int surahNumber;
  final int ayahNumberInSurah;
  final String surahNameArabic;
  final String surahNameEnglish;
  final int totalAyahsInSurah;
  final String arabicText;
  final String? translationText;
  final String? tafsirText;
  final int juz;
  final int page;

  const AyahModel({
    required this.absoluteNumber,
    required this.surahNumber,
    required this.ayahNumberInSurah,
    required this.surahNameArabic,
    required this.surahNameEnglish,
    required this.totalAyahsInSurah,
    required this.arabicText,
    this.translationText,
    this.tafsirText,
    required this.juz,
    required this.page,
  });

  String get verseKey => '$surahNumber:$ayahNumberInSurah';

  AyahModel copyWith({
    String? tafsirText,
    String? translationText,
  }) =>
      AyahModel(
        absoluteNumber: absoluteNumber,
        surahNumber: surahNumber,
        ayahNumberInSurah: ayahNumberInSurah,
        surahNameArabic: surahNameArabic,
        surahNameEnglish: surahNameEnglish,
        totalAyahsInSurah: totalAyahsInSurah,
        arabicText: arabicText,
        translationText: translationText ?? this.translationText,
        tafsirText: tafsirText ?? this.tafsirText,
        juz: juz,
        page: page,
      );

  Map<String, dynamic> toJson() => {
        'absoluteNumber': absoluteNumber,
        'surahNumber': surahNumber,
        'ayahNumberInSurah': ayahNumberInSurah,
        'surahNameArabic': surahNameArabic,
        'surahNameEnglish': surahNameEnglish,
        'totalAyahsInSurah': totalAyahsInSurah,
        'arabicText': arabicText,
        'translationText': translationText,
        'tafsirText': tafsirText,
        'juz': juz,
        'page': page,
      };

  factory AyahModel.fromJson(Map<String, dynamic> json) => AyahModel(
        absoluteNumber: json['absoluteNumber'] as int,
        surahNumber: json['surahNumber'] as int,
        ayahNumberInSurah: json['ayahNumberInSurah'] as int,
        surahNameArabic: json['surahNameArabic'] as String,
        surahNameEnglish: json['surahNameEnglish'] as String,
        totalAyahsInSurah: json['totalAyahsInSurah'] as int,
        arabicText: json['arabicText'] as String,
        translationText: json['translationText'] as String?,
        tafsirText: json['tafsirText'] as String?,
        juz: json['juz'] as int,
        page: json['page'] as int,
      );

  /// Parses alquran.cloud API response data array into AyahModel.
  /// arabicEntry — edition quran-uthmani; translationEntry — any translation or null.
  factory AyahModel.fromApi({
    required Map<String, dynamic> arabicEntry,
    Map<String, dynamic>? translationEntry,
  }) {
    final surah = arabicEntry['surah'] as Map<String, dynamic>;
    return AyahModel(
      absoluteNumber: arabicEntry['number'] as int,
      surahNumber: surah['number'] as int,
      ayahNumberInSurah: arabicEntry['numberInSurah'] as int,
      surahNameArabic: surah['name'] as String,
      surahNameEnglish: surah['englishName'] as String,
      totalAyahsInSurah: surah['numberOfAyahs'] as int,
      arabicText: arabicEntry['text'] as String,
      translationText: translationEntry?['text'] as String?,
      juz: arabicEntry['juz'] as int,
      page: arabicEntry['page'] as int,
    );
  }
}
