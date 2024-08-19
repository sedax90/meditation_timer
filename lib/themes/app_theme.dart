import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: AppFonts.primary,
    colorSchemeSeed: AppColors.darkGreen,
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: AppFonts.secondary,
        fontStyle: FontStyle.italic,
        fontSize: 30,
      ),
      titleMedium: TextStyle(
        fontFamily: AppFonts.secondary,
        fontStyle: FontStyle.italic,
        fontSize: 26,
      ),
      titleSmall: TextStyle(
        fontFamily: AppFonts.secondary,
        fontStyle: FontStyle.italic,
        fontSize: 23,
      ),
    ),
    scaffoldBackgroundColor: AppColors.lightGreen,
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.sand,
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
    switchTheme: const SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(AppColors.darkGreen),
      trackOutlineColor: WidgetStatePropertyAll(AppColors.darkGreen),
      overlayColor: WidgetStatePropertyAll(AppColors.lightGreen),
      trackColor: WidgetStatePropertyAll(Colors.transparent),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.sand,
      contentTextStyle: TextStyle(
        color: AppColors.darkGreen,
        fontFamily: AppFonts.secondary,
        fontStyle: FontStyle.italic,
        fontSize: 20,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkGreen),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  );
}

class AppColors {
  static const Color lightGreen = Color.fromRGBO(179, 241, 198, 1);
  static const Color green = Color.fromRGBO(70, 177, 105, 1);
  static const Color darkGreen = Color.fromRGBO(12, 29, 23, 1);
  static const Color sand = Color.fromRGBO(244, 240, 231, 1);
}

class AppFonts {
  static const String primary = "Raleway";
  static const String secondary = "Arapey";
}
