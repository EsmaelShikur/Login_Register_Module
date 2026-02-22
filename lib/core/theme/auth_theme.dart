import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/auth_constants.dart';

/// Dark futuristic neon theme for the auth module
class AuthDarkTheme {
  AuthDarkTheme._();

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AuthColors.darkBackground,
        colorScheme: const ColorScheme.dark(
          primary: AuthColors.neonCyan,
          secondary: AuthColors.neonPurple,
          surface: AuthColors.darkSurface,
          error: AuthColors.error,
          onPrimary: AuthColors.darkBackground,
          onSecondary: AuthColors.darkBackground,
          onSurface: AuthColors.darkTextPrimary,
          onError: Colors.white,
        ),
        textTheme: _darkTextTheme,
        inputDecorationTheme: _darkInputTheme,
        elevatedButtonTheme: _darkButtonTheme,
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AuthColors.neonCyan;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(AuthColors.darkBackground),
          side: const BorderSide(color: AuthColors.neonCyanDim, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      );

  static const TextTheme _darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AuthColors.darkTextPrimary,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AuthColors.darkTextPrimary,
      letterSpacing: -0.3,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AuthColors.darkTextPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AuthColors.darkTextPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: AuthColors.darkTextSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: AuthColors.darkTextHint,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AuthColors.darkBackground,
      letterSpacing: 0.5,
    ),
  );

  static InputDecorationTheme get _darkInputTheme => InputDecorationTheme(
        filled: true,
        fillColor: AuthColors.darkCard.withOpacity(0.8),
        hintStyle: const TextStyle(
          color: AuthColors.darkTextHint,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AuthSpacing.md,
          vertical: AuthSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthRadius.md),
          borderSide: const BorderSide(
            color: AuthColors.darkTextHint,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthRadius.md),
          borderSide: BorderSide(
            color: AuthColors.darkTextHint.withOpacity(0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthRadius.md),
          borderSide: const BorderSide(
            color: AuthColors.neonCyan,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthRadius.md),
          borderSide: const BorderSide(
            color: AuthColors.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthRadius.md),
          borderSide: const BorderSide(
            color: AuthColors.error,
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(
          color: AuthColors.error,
          fontSize: 12,
        ),
      );

  static ElevatedButtonThemeData get _darkButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthColors.neonCyan,
          foregroundColor: AuthColors.darkBackground,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthRadius.md),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      );
}

/// Light clean modern theme variant
class AuthLightTheme {
  AuthLightTheme._();

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AuthColors.lightBackground,
        colorScheme: const ColorScheme.light(
          primary: AuthColors.lightPrimary,
          secondary: AuthColors.lightAccent,
          surface: AuthColors.lightSurface,
          error: AuthColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AuthColors.lightTextPrimary,
        ),
        textTheme: _lightTextTheme,
        inputDecorationTheme: _lightInputTheme,
        elevatedButtonTheme: _lightButtonTheme,
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AuthColors.lightPrimary;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
          side:
              const BorderSide(color: AuthColors.lightTextSecondary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      );

  static const TextTheme _lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AuthColors.lightTextPrimary,
      letterSpacing: -0.5,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AuthColors.lightTextPrimary,
      letterSpacing: -0.3,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AuthColors.lightTextPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: AuthColors.lightTextPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: AuthColors.lightTextSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: AuthColors.lightTextHint,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.5,
    ),
  );

  static InputDecorationTheme get _lightInputTheme => InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(
          color: AuthColors.lightTextHint,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AuthSpacing.md,
          vertical: AuthSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthRadius.md),
          borderSide: const BorderSide(
            color: AuthColors.lightTextHint,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthRadius.md),
          borderSide: const BorderSide(
            color: Color(0xFFDDE3EF),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthRadius.md),
          borderSide: const BorderSide(
            color: AuthColors.lightPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthRadius.md),
          borderSide: const BorderSide(
            color: AuthColors.error,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AuthRadius.md),
          borderSide: const BorderSide(
            color: AuthColors.error,
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(
          color: AuthColors.error,
          fontSize: 12,
        ),
      );

  static ElevatedButtonThemeData get _lightButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthColors.lightPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AuthRadius.md),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      );
}
