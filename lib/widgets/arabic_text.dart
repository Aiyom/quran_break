import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class ArabicText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final TextAlign textAlign;

  const ArabicText(
    this.text, {
    super.key,
    this.fontSize = 22,
    this.color,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        text,
        textAlign: textAlign,
        style: arabicStyle(fontSize: fontSize, color: color),
      ),
    );
  }
}
