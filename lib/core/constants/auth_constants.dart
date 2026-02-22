import 'package:flutter/material.dart';

/// Color palette for the auth module's futuristic neon theme
class AuthColors {
  AuthColors._();

  // ─── Dark Theme Colors ───────────────────────────────────────────────────
  static const darkBackground = Color(0xFF050A18);
  static const darkSurface = Color(0xFF0D1628);
  static const darkCard = Color(0xFF111D35);

  // Neon Cyan
  static const neonCyan = Color(0xFF00F5FF);
  static const neonCyanDim = Color(0xFF00B8C4);
  static const neonCyanGlow = Color(0x4000F5FF);

  // Neon Purple
  static const neonPurple = Color(0xFFB24BF3);
  static const neonPurpleDim = Color(0xFF8B3DB8);
  static const neonPurpleGlow = Color(0x40B24BF3);

  // Neon Pink
  static const neonPink = Color(0xFFFF006E);
  static const neonPinkGlow = Color(0x40FF006E);

  // Text
  static const darkTextPrimary = Color(0xFFE8F4FF);
  static const darkTextSecondary = Color(0xFF7B8FAB);
  static const darkTextHint = Color(0xFF3D5275);

  // Status
  static const success = Color(0xFF00FF88);
  static const successGlow = Color(0x4000FF88);
  static const error = Color(0xFFFF3366);
  static const errorGlow = Color(0x40FF3366);
  static const warning = Color(0xFFFFAA00);

  // Gradients
  static const gradientCyanPurple = [neonCyan, neonPurple];
  static const gradientPurplePink = [neonPurple, neonPink];
  static const gradientDark = [darkBackground, Color(0xFF0A1525)];

  // ─── Light Theme Colors ──────────────────────────────────────────────────
  static const lightBackground = Color(0xFFF0F4FF);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFF8FAFF);

  static const lightPrimary = Color(0xFF4A6CF7);
  static const lightPrimaryDim = Color(0xFF2D4DD6);
  static const lightAccent = Color(0xFF7B3FE4);

  static const lightTextPrimary = Color(0xFF1A1F36);
  static const lightTextSecondary = Color(0xFF6B7280);
  static const lightTextHint = Color(0xFFADB5BD);

  // Password strength colors
  static const strengthWeak = Color(0xFFFF3366);
  static const strengthFair = Color(0xFFFFAA00);
  static const strengthGood = Color(0xFF00AAFF);
  static const strengthStrong = Color(0xFF00FF88);
}

/// Spacing constants
class AuthSpacing {
  AuthSpacing._();
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

/// Border radius constants
class AuthRadius {
  AuthRadius._();
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double pill = 100.0;
}

/// Animation durations
class AuthDurations {
  AuthDurations._();
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 600);
  static const verySlow = Duration(milliseconds: 1200);
}
