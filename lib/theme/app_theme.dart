import 'package:flutter/material.dart';

class AppColors {
  static const Color spaceCadet = Color(0xFF2B2D42);
  static const Color spaceCadet100 = Color(0xFF08090D);
  static const Color spaceCadet200 = Color(0xFF11121A);
  static const Color spaceCadet300 = Color(0xFF191B27);
  static const Color spaceCadet400 = Color(0xFF222334);
  static const Color spaceCadet500 = Color(0xFF2B2D42);
  static const Color spaceCadet600 = Color(0xFF4A4D72);
  static const Color spaceCadet700 = Color(0xFF6D71A0);
  static const Color spaceCadet800 = Color(0xFF9DA0BF);
  static const Color spaceCadet900 = Color(0xFFCED0DF);

  static const Color coolGray = Color(0xFF8D99AE);
  static const Color coolGray100 = Color(0xFF1A1E25);
  static const Color coolGray200 = Color(0xFF343C4A);
  static const Color coolGray300 = Color(0xFF4F5B6F);
  static const Color coolGray400 = Color(0xFF697994);
  static const Color coolGray500 = Color(0xFF8D99AE);
  static const Color coolGray600 = Color(0xFFA4AEBF);
  static const Color coolGray700 = Color(0xFFBBC2CF);
  static const Color coolGray800 = Color(0xFFD2D6DF);
  static const Color coolGray900 = Color(0xFFE8EBEF);

  static const Color antiFlashWhite = Color(0xFFEDF2F4);
  static const Color antiFlashWhite100 = Color(0xFF24353B);
  static const Color antiFlashWhite200 = Color(0xFF496A77);
  static const Color antiFlashWhite300 = Color(0xFF759BAB);
  static const Color antiFlashWhite400 = Color(0xFFB1C6CF);
  static const Color antiFlashWhite500 = Color(0xFFEDF2F4);
  static const Color antiFlashWhite600 = Color(0xFFF0F4F6);
  static const Color antiFlashWhite700 = Color(0xFFF4F7F8);
  static const Color antiFlashWhite800 = Color(0xFFF7FAFA);
  static const Color antiFlashWhite900 = Color(0xFFFBFCFD);

  static const Color redPantone = Color(0xFFEF233C);
  static const Color redPantone100 = Color(0xFF330409);
  static const Color redPantone200 = Color(0xFF660813);
  static const Color redPantone300 = Color(0xFF9A0C1C);
  static const Color redPantone400 = Color(0xFFCD0F26);
  static const Color redPantone500 = Color(0xFFEF233C);
  static const Color redPantone600 = Color(0xFFF25063);
  static const Color redPantone700 = Color(0xFFF57C8A);
  static const Color redPantone800 = Color(0xFFF8A8B1);
  static const Color redPantone900 = Color(0xFFFCD3D8);

  static const Color crimson = Color(0xFFD80032);
  static const Color crimson100 = Color(0xFF2B000A);
  static const Color crimson200 = Color(0xFF560014);
  static const Color crimson300 = Color(0xFF81001E);
  static const Color crimson400 = Color(0xFFAB0028);
  static const Color crimson500 = Color(0xFFD80032);
  static const Color crimson600 = Color(0xFFFF124A);
  static const Color crimson700 = Color(0xFFFF4E77);
  static const Color crimson800 = Color(0xFFFF89A4);
  static const Color crimson900 = Color(0xFFFFC4D2);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.spaceCadet,
        secondary: AppColors.coolGray,
        surface: AppColors.antiFlashWhite,
        error: AppColors.redPantone,
        onPrimary: AppColors.antiFlashWhite,
        onSecondary: AppColors.antiFlashWhite,
        onSurface: AppColors.spaceCadet,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.antiFlashWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.spaceCadet,
        foregroundColor: AppColors.antiFlashWhite,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.coolGray300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.coolGray300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.spaceCadet, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.spaceCadet,
          foregroundColor: AppColors.antiFlashWhite,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.spaceCadet;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.antiFlashWhite),
        side: const BorderSide(color: AppColors.coolGray400, width: 2),
      ),
      iconTheme: const IconThemeData(
        color: AppColors.coolGray500,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.antiFlashWhite,
        unselectedLabelColor: AppColors.coolGray600,
        indicatorColor: AppColors.antiFlashWhite,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.spaceCadet,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.spaceCadet,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.spaceCadet,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.coolGray400,
        ),
      ),
    );
  }
}

