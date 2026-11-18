import 'package:flutter/material.dart';

/// Unified Theme Color Palette & Design System for NCare
class AppColors {
  AppColors._();

  // --- Primary Brand Colors ---
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryDarkBlue = Color(0xFF1E56A0);
  static const Color primaryNavy = Color(0xFF1E3B8A);

  // --- Accent Colors ---
  static const Color accentOrange = Color(0xFFE28913);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentRed = Color(0xFFDC2626);

  // --- Background Colors ---
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardWhite = Colors.white;
  static const Color surfaceMuted = Color(0xFFF1F5F9);

  // --- Text Colors ---
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // --- Border Colors ---
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderSubtle = Color(0xFFE2E8F0);

  // --- Gradients ---
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E56A0),
      Color(0xFF2C74B3),
    ],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE3F2FD),
      Color(0xFFBBDEFB),
      Color(0xFF64B5F6),
      Color(0xFF2196F3),
      Color(0xFF1565C0),
      Color(0xFF0D47A1),
    ],
    stops: [0.0, 0.18, 0.42, 0.68, 0.88, 1.0],
  );

  static const LinearGradient promoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF60A5FA),
    ],
  );

  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFF97316),
      Color(0xFFEA580C),
    ],
  );
}
