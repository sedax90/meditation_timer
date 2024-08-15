import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: AppFonts.primary,
    textTheme: const TextTheme(),
    scaffoldBackgroundColor: AppColors.lightGreen,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: const Color.fromRGBO(244, 240, 231, 1),
      modalBarrierColor: AppColors.darkGreen.withOpacity(0.75),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(
          fontFamily: AppFonts.secondary,
          fontStyle: FontStyle.italic,
          fontSize: 22,
        ),
        side: const BorderSide(
          color: AppColors.darkGreen,
        ),
        foregroundColor: AppColors.darkGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        textStyle: const TextStyle(
          fontFamily: AppFonts.secondary,
          fontStyle: FontStyle.italic,
          fontSize: 22,
        ),
        backgroundColor: AppColors.darkGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
  );
}

class AppColors {
  static const Color lightGreen = Color.fromRGBO(179, 241, 198, 1);
  static const Color green = Color.fromRGBO(70, 177, 105, 1);
  static const Color darkGreen = Color.fromRGBO(12, 29, 23, 1);
}

class AppFonts {
  static const String primary = "Raleway";
  static const String secondary = "Arapey";
}
