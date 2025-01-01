import 'package:flutter/material.dart';

class AppTheme {
  static const Color menuColor = Color(0xFF068047);
  static const Color primaryColor = Color(0xFF0B3B5C);
  static const Color dangerColor = Color(0xFFc5000f);
  static const Color successColor = Color(0xFF068047);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color secondaryColor = Color(0xFFEDEEF0);
  static ThemeData get lightTheme {
    return ThemeData(
      // Primary color
      primaryColor: primaryColor,

      // Accent color
      hintColor: Colors.amber,

      // Background and card colors
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,

      colorScheme: const ColorScheme.light(
        primary: primaryColor,
      ),
      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: primaryColor,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
        bodySmall: TextStyle(
          fontSize: 12.0,
          color: Colors.black,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
      ),

      // Button theme
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        color: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: primaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(
          fontSize: 12.0,
          color: Colors.red,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
      ),

      // ElevatedButton style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
          ),
        ),
      ),
      datePickerTheme: const DatePickerThemeData(
        headerHeadlineStyle: TextStyle(
          fontSize: 16.0,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
        headerHelpStyle: TextStyle(
          fontSize: 16.0,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
        dayStyle: TextStyle(
          fontSize: 16.0,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
        rangePickerHeaderHeadlineStyle: TextStyle(
          fontSize: 16.0,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
        rangePickerHeaderHelpStyle: TextStyle(
          fontSize: 16.0,
          fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
        ),
      ),
    );
  }
}
