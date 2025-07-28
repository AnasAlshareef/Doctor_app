import 'package:flutter/material.dart';

class AppTheme {
  // Colors - مجموعة ألوان عصرية جديدة
  static const Color primaryColor = Color(0xFF6200EE); // بنفسجي عميق
  static const Color accentColor = Color(0xFF03DAC6); // فيروزي
  static const Color backgroundColor = Color(0xFFF8F8F8); // رمادي فاتح
  static const Color textColor = Color(0xFF333333); // رمادي داكن
  static const Color errorColor = Color(0xFFB00020); // أحمر داكن
  static const Color successColor = Color(0xFF4CAF50); // أخضر
  static const Color cardColor = Color(0xFFFFFFFF); // أبيض
  static const Color secondaryTextColor = Color(0xFF757575); // رمادي متوسط
  static const Color dividerColor = Color(0xFFEEEEEE); // رمادي فاتح جداً
  static const Color shadowColor = Color(0x1A000000); // ظل شفاف

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: accentColor,
      background: backgroundColor,
      error: errorColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        shadowColor: shadowColor,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: dividerColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: dividerColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(color: secondaryTextColor),
      hintStyle: TextStyle(color: secondaryTextColor.withOpacity(0.7)),
      prefixIconColor: secondaryTextColor,
      suffixIconColor: secondaryTextColor,
    ),
    cardTheme: CardThemeData(
      elevation: 3,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: secondaryTextColor,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: primaryColor, width: 3),
        ),
      ),
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: dividerColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(fontSize: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    iconTheme: IconThemeData(color: secondaryTextColor),
    dividerTheme: DividerThemeData(color: dividerColor, thickness: 1),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textColor),
      bodyLarge: TextStyle(fontSize: 16, color: textColor),
      bodyMedium: TextStyle(fontSize: 14, color: textColor),
      bodySmall: TextStyle(fontSize: 12, color: secondaryTextColor),
    ),
  );
}