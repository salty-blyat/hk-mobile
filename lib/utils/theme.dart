import 'package:flutter/material.dart';

class AppTheme {
  static const Color menuColor = Color(0xFF068047);
  static const Color primaryColor = Color(0xFF0D4A4D); 
  static const Color primaryColorLigt = Color(0xFF885EA0);
  static const Color dangerColor = Color(0xFFc5000f);
  static const Color successColor = Color(0xFF068047);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color secondaryColor = Color(0xFFEDEEF0);
  static const Color defaultColor = Color(0xFF5F5F5F);
  static const Color secondaryColorRgb = Color(0xFF0163AA);
  static BorderRadiusGeometry borderRadius = BorderRadius.circular(4);
  static const TextStyle style = TextStyle(
    fontSize: 16.0,
    fontFamilyFallback: ['Gilroy', 'Kantumruy'],
  );
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
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
      textTheme: TextTheme(
        displayLarge: style.copyWith(
          fontSize: 32.0,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        bodyLarge: style.copyWith(
          fontSize: 15.0,
          color: Colors.black,
        ),
        bodyMedium: style.copyWith(
          fontSize: 14.0,
          color: Colors.black,
        ),
        bodySmall: style.copyWith(
          fontSize: 12.0,
          color: Colors.black,
        ),
        titleMedium: style.copyWith(
          fontSize: 16.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titleSmall: style.copyWith(
          fontSize: 14.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: style.copyWith(
          fontSize: 22.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Button theme
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      // AppBar theme
      appBarTheme: AppBarTheme(
        color: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        titleTextStyle: style.copyWith(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 12.0,
        ),
        counterStyle: style.copyWith(
          fontSize: 12.0,
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: const BorderSide(color: primaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: style.copyWith(color: Colors.red, fontSize: 12),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: style.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        suffixIconColor: Colors.black54,
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
          textStyle: style,
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        dayPeriodShape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
        cancelButtonStyle: ButtonStyle(
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontFamilyFallback: ['Gilroy', 'Kantumruy'],
            ),
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontFamilyFallback: ['Gilroy', 'Kantumruy'],
            ),
          ),
        ),
        timeSelectorSeparatorTextStyle: WidgetStateProperty.all(
          style.copyWith(
            fontSize: 50,
            color: Colors.black,
          ),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        headerHeadlineStyle: style,
        headerHelpStyle: style,
        dayStyle: style,
        weekdayStyle: style,
        yearStyle: style,
        rangePickerHeaderHeadlineStyle: style,
        rangePickerHeaderHelpStyle: style,
        confirmButtonStyle: ButtonStyle(
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontFamilyFallback: ['Gilroy', 'Kantumruy'],
            ),
          ),
        ),
        cancelButtonStyle: ButtonStyle(
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontFamilyFallback: ['Gilroy', 'Kantumruy'],
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: style.copyWith(fontSize: 14.0),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: Colors.black,
        leadingAndTrailingTextStyle: style,
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: Colors.white,
        labelStyle: style,
        side: BorderSide(color: Colors.transparent),
        padding: EdgeInsets.zero,
        labelPadding: EdgeInsets.zero,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: style,
        contentTextStyle: style,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadius,
        ),
      ),
    );
  }
}
