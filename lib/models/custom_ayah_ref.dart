import '../constants/surah_data.dart';

class CustomAyahRef {
  final int surahNumber;
  final int ayahNumber;

  const CustomAyahRef({
    required this.surahNumber,
    required this.ayahNumber,
  });

  String get verseKey => '$surahNumber:$ayahNumber';

  String get surahNameArabic => getSurah(surahNumber).nameArabic;
  String get surahNameTranslit => getSurah(surahNumber).nameTranslit;
  String get surahNameRussian => getSurah(surahNumber).nameRussian;

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
      };

  factory CustomAyahRef.fromJson(Map<String, dynamic> json) => CustomAyahRef(
        surahNumber: json['surahNumber'] as int,
        ayahNumber: json['ayahNumber'] as int,
      );

  @override
  bool operator ==(Object other) =>
      other is CustomAyahRef &&
      surahNumber == other.surahNumber &&
      ayahNumber == other.ayahNumber;

  @override
  int get hashCode => Object.hash(surahNumber, ayahNumber);
}
