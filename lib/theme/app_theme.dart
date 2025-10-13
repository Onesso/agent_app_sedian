import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF1B2032);   // Sidian Navy
  static const Color secondary = Color(0xFFF6E71D); // Sidian Yellow
  static const Color olive = Color(0xFF7A7A18); // Sidian Olive

  // Supporting Colors
  static const Color dark = Color(0xFF222428);
  static const Color lightBackground = Color(0xFFF4F5F8);
  static const Color medium = Color(0xFFEDEDED);

  // Alert Colors
  static const Color successGreen = Color(0xFF3C8930);
  static const Color warningYellow = Color(0xFFFFC409);
  static const Color errorRed = Color(0xFFEB445A);
  static const Color infoBlue = Color(0xFF5260FF);

  // Text Colors
  static const Color textPrimary = dark;
  static const Color textSecondary = Color(0xFF4E4E4E);
  static const Color textLink = primary;

  // Button Colors
  static const Color primaryButton = primary;
  static const Color secondaryButton = secondary;

  static Color primaryButtonPressed = primary.withOpacity(0.7);
  static Color secondaryButtonPressed = secondary.withOpacity(0.8);

  // Theme definition
  static ThemeData light() {
    final base = ThemeData.light();

    return base.copyWith(
      scaffoldBackgroundColor: lightBackground,
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        secondary: secondary,
        background: lightBackground,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: dark,
      ),
      textTheme: _buildTextTheme(base.textTheme),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      appBarTheme: _appBarTheme(),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.bold,
        fontSize: 52,
        color: textPrimary,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.bold,
        fontSize: 36,
        color: textPrimary,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: textPrimary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: textSecondary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.normal,
        fontSize: 13,
        color: textSecondary,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: textPrimary,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryButton,
        foregroundColor: Colors.white,
        minimumSize: const Size(328, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
          fontFamily: 'Calibri',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: secondaryButton,
        foregroundColor: dark,
        minimumSize: const Size(328, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(
          fontFamily: 'Calibri',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: textLink,
        textStyle: const TextStyle(
          fontFamily: 'Calibri',
          fontWeight: FontWeight.w600,
          fontSize: 12,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: medium, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      labelStyle: const TextStyle(color: dark, fontFamily: 'Calibri'),
      hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Calibri'),
      contentPadding: const EdgeInsets.all(16),
    );
  }

  static AppBarTheme _appBarTheme() {
    return const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Calibri',
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: dark,
      ),
      iconTheme: IconThemeData(color: primary, size: 24),
    );
  }
}
