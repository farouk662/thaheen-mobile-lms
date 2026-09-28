import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color seed = Color(0xFF1B4F8C); // deep blue — top of the loop
  static const Color primary = Color(0xFF1B4F8C); // same as seed, main brand color
  static const Color primaryLight = Color(0xFF2E8FC0); // mid-tone blue from the gradient
  static const Color accent = Color(0xFF4FC7D9); // teal/cyan — bottom of the loop

  // Neutral / semantic — not from the logo, kept minimal
  static const Color background = Color(0xFFF7F9FB);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color error = Color(0xFFD64545);
  static const Color success = Color(0xFF2FA84F);
}
