
import 'package:ap_solutions/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    scaffoldBackgroundColor: bg,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: GoogleFonts.ralewayTextTheme(),
    useMaterial3: true,
  );

  static final TextStyle appBarTitleStyle = TextStyle(
    fontSize: 21.sp,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
}
