import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  AppFonts._();

  static const double h1 = 40;
  static const double h2 = 32;
  static const double h3 = 24;
  static const double h4 = 20;
  static const double h5 = 16;

  static TextStyle textStyleWithSize(
    final double fontSize, {
    final FontWeight? weight,
    final Color? color,
  }) {
    return GoogleFonts.inter(
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: weight,
        color: color == null ? Colors.black : color,
      ),
    );
  }
}
