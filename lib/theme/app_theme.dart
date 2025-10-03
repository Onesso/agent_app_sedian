import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color lightBlue = Color(0xFF0082BB);
  static const Color darkBlueHighlight = Color(0xFF023448);

  // Secondary Colors
  static const Color lightGreen = Color(0xFFBED600);
  static const Color mobileAppGreen = Color(0xFF59C391);

  // Neutral Colors
  static const Color darkGray = Color(0xFF4E4E4E);
  static const Color darkGrayT = Color(0xFF717171);
  static const Color midGray = Color(0xFF979797);
  static const Color lightGray = Color(0xFFEDEDED);
  static const Color lightGrayT2 = Color(0xFFF6F6F6);
  static const Color lightGrayT1 = Color(0xFFFBFBFB);
  static const Color white = Color(0xFFFFFFFF);

  // Alert Colors
  static const Color errorRed = Color(0xFFB3261E);
  static const Color successGreen = Color(0xFF3C8930);
  static const Color infoBlue = Color(0xFF005B82);
  static const Color warningYellow = Color(0xFFFFC43D);

  //Brand Alert Palette
  static const Color alertError    = Color(0xFFB3261E); // MobileApp Error Red
  static const Color alertSuccess  = Color(0xFF3C8930); // Ecobank Dark Green
  static const Color alertInfo     = Color(0xFF005B82); // Ecobank Dark Blue
  static const Color alertWarning  = Color(0xFFFFC43D); // MobileApp Yellow

// Text contrast helpers
  static const Color alertOnDark   = Colors.white;
  static const Color alertOnLight  = Color(0xFF1F2937); // for yellow banner text


  // Font Colors
  static const Color textTitleBody = darkGray; // #4E4E4E
  static const Color textLinksLabels = lightBlue; // #0082BB
  static const Color textFieldOutline = midGray; // #979797

  // Icon Colors
  static const Color iconGreen = mobileAppGreen; // #59C391
  static const Color iconWhite = white; // #FFFFFF

  // Button Colors
  static const Color primaryButton = lightGreen; // #BED600
  static const Color secondaryButton = lightBlue; // #0082BB
  static Color primaryButtonPressed = primaryButton.withOpacity(0.6); // 60% fill
  static Color secondaryButtonPressed = secondaryButton.withOpacity(0.6); // 60% fill

  // Light Theme
  static ThemeData light() {
    final base = ThemeData.light().copyWith(
      scaffoldBackgroundColor: white,
    );

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: lightBlue,
        secondary: lightGreen,
        background: white,
        error: errorRed,
        onPrimary: white, // Text color on primary buttons
        onSecondary: white, // Text color on secondary buttons
      ),
      textTheme: _buildTextTheme(base.textTheme),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      appBarTheme: _appBarTheme(),
    );
  }

  // Text Theme based on Gilroy font
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      // Headlines
      displaySmall: base.displaySmall!.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
        height: 28.0 / 22.0,
        letterSpacing: 0.2,
        color: textTitleBody,
      ),
      displayMedium: base.displayMedium?.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600, // SemiBold
        fontSize: 45.0,
        height: 52.0 / 45.0, // line height ratio
        letterSpacing: 0.0,
        color: textTitleBody,
      ) ??
          const TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            fontSize: 45.0,
            height: 52.0 / 45.0,
            letterSpacing: 0.0,
            color: textTitleBody,
          ),
      displayLarge: base.displayLarge?.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600, // SemiBold
        fontSize: 52.0,
        height: 62.0 / 52.0, // line height ratio
        letterSpacing: 0.0,
        color: textTitleBody,
      ) ??
          const TextStyle(
            fontFamily: 'Gilroy',
            fontWeight: FontWeight.w600,
            fontSize: 45.0,
            height: 52.0 / 45.0,
            letterSpacing: 0.0,
            color: textTitleBody,
          ),
      headlineMedium: base.headlineMedium!.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
        height: 24.0 / 16.0,
        letterSpacing: 0.2,
        color: textTitleBody,
      ),
      headlineSmall: base.headlineSmall!.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
        height: 20.0 / 14.0,
        letterSpacing: 0.2,
        color: textTitleBody,
      ),
      titleSmall: base.titleSmall!.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600,
        fontSize: 12.0,
        height: 18.0 / 12.0,
        letterSpacing: 0.2,
        color: textTitleBody,
      ),
      // Labels
      bodyLarge: base.bodyLarge!.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
        height: 20.0 / 14.0,
        letterSpacing: 0.2,
        color: textTitleBody,
      ),
      bodyMedium: base.bodyMedium!.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
        height: 18.0 / 12.0,
        letterSpacing: 0.5,
        color: textTitleBody,
      ),
      // Body Text
      titleMedium: base.titleMedium!.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
        height: 24.0 / 16.0,
        letterSpacing: 0.2,
        color: textTitleBody,
      ),
      titleLarge: base.titleLarge!.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
        height: 20.0 / 14.0,
        letterSpacing: 0.2,
        color: textTitleBody,
      ),
      labelSmall: base.labelSmall!.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
        height: 18.0 / 12.0,
        letterSpacing: 0.5,
        color: textTitleBody,
      ),
      // Captions
      bodySmall: base.bodySmall!.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.normal,
        fontSize: 11.0,
        height: 16.0 / 11.0,
        letterSpacing: 0.5,
        color: textTitleBody,
      ),
      labelLarge: base.labelLarge!.copyWith(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600,
        fontSize: 11.0,
        height: 16.0 / 11.0,
        letterSpacing: 0.5,
        color: textTitleBody,
      ),

    );
  }

  // Primary Button (Light Green)
  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryButton,
        foregroundColor: Colors.white,
        minimumSize: const Size(328, 40), // Width: 328, Height: 40
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), // Radius: 8px
        textStyle: const TextStyle(
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // Secondary Button (Light Blue)
  static OutlinedButtonThemeData _outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: secondaryButton,
        foregroundColor: Colors.white,
        minimumSize: const Size(328, 40),
        side: BorderSide.none, // Remove default outline
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // Text Link Buttons
  static TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: textLinksLabels,
        textStyle: const TextStyle(
          fontFamily: 'Gilroy',
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.2,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // Input Fields
  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: lightGrayT1, // #FBFBFB
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: textFieldOutline, width: 1.0), // #979797
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: lightBlue, width: 1.5), // Focus to Light Blue
      ),
      contentPadding: const EdgeInsets.all(16.0),
      hintStyle: TextStyle(color: midGray, fontFamily: 'Gilroy'),
      labelStyle: TextStyle(color: darkGrayT, fontFamily: 'Gilroy'),
    );
  }

  // App Bar
  static AppBarTheme _appBarTheme() {
    return const AppBarTheme(
      backgroundColor: white,
      foregroundColor: darkGray, // Color of the title
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: lightBlue, size: 24), // Back button color
      titleTextStyle: TextStyle(
        fontFamily: 'Gilroy',
        fontWeight: FontWeight.w600,
        fontSize: 16,
        letterSpacing: 0.2,
        color: darkGray, // #4E4E4E
      ),
    );
  }
}