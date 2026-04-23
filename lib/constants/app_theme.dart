import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kBg = Color(0xFF0D1F16);
const kSurface = Color(0xFF1B3A2A);
const kSurfaceHover = Color(0xFF224432);
const kGold = Color(0xFFD4AF37);
const kGoldLight = Color(0xFFF5DEB3);
const kGreen = Color(0xFF4CAF82);
const kGreenDark = Color(0xFF2E7D52);
const kRed = Color(0xFFE57373);
const kTextPrimary = Color(0xFFF0EAD6);
const kTextSecond = Color(0xFF9DB5A0);
const kTafsirText = Color(0xFFC8B89A);

ThemeData buildTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: kBg,
    colorScheme: base.colorScheme.copyWith(
      primary: kGold,
      secondary: kGreen,
      surface: kSurface,
      error: kRed,
      onPrimary: kBg,
      onSurface: kTextPrimary,
    ),
    textTheme: GoogleFonts.cairoTextTheme(base.textTheme).apply(
      bodyColor: kTextPrimary,
      displayColor: kTextPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: kBg,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.cairo(
        color: kTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: kGold),
    ),
    cardTheme: CardThemeData(
      color: kSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: kGold.withValues(alpha: 0.1)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kGold,
        foregroundColor: kBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.cairo(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kGold,
        side: BorderSide(color: kGold.withValues(alpha: 0.4)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kGold,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: kSurface,
      selectedColor: kGold,
      labelStyle: GoogleFonts.cairo(color: kTextPrimary, fontSize: 13),
      secondaryLabelStyle: GoogleFonts.cairo(
        color: kBg,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: kGold.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return kGold;
        return kTextSecond;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return kGold.withValues(alpha: 0.4);
        }
        return kSurface;
      }),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return kGold;
        return kTextSecond;
      }),
    ),
    dividerTheme: DividerThemeData(
      color: kGold.withValues(alpha: 0.15),
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kSurface,
      contentTextStyle: GoogleFonts.cairo(color: kTextPrimary),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: kSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: GoogleFonts.cairo(
        color: kTextPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: GoogleFonts.cairo(
        color: kTextPrimary,
        fontSize: 14,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kGold.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: kGold.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kGold, width: 2),
      ),
      labelStyle: GoogleFonts.cairo(color: kTextSecond),
      hintStyle: GoogleFonts.cairo(color: kTextSecond),
    ),
  );
}

TextStyle arabicStyle({double fontSize = 22, Color? color}) =>
    GoogleFonts.amiri(
      fontSize: fontSize,
      color: color ?? kTextPrimary,
      height: 2.0,
    );

TextStyle cairoStyle({
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w400,
  Color? color,
  double? height,
}) =>
    GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? kTextPrimary,
      height: height,
    );

BoxDecoration cardDecoration({Color? color, double? radius}) => BoxDecoration(
      color: color ?? kSurface,
      borderRadius: BorderRadius.circular(radius ?? 16),
      border: Border.all(color: kGold.withValues(alpha: 0.1)),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    );
