import 'package:flutter/material.dart';

class AppColors {
  static const bg = Color(0xFF0B0F14);
  static const surface = Color(0xFF141A22);
  static const surface2 = Color(0xFF1C2430);
  static const border = Color(0xFF2A3441);
  static const text = Color(0xFFE6EDF5);
  static const muted = Color(0xFF8B98A8);
  static const accent = Color(0xFF3DDC97);
  static const info = Color(0xFF6CB6FF);
  static const warn = Color(0xFFE8C45D);
  static const danger = Color(0xFFE85D5D);
  static const locked = Color(0xFF5A6573);
}

ThemeData buildAppTheme() {
  const scheme = ColorScheme.dark(
    surface: AppColors.surface,
    primary: AppColors.info,
    secondary: AppColors.accent,
    error: AppColors.danger,
    onSurface: AppColors.text,
    onPrimary: Color(0xFF061018),
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.text,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.info),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.info,
        foregroundColor: const Color(0xFF061018),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: Color(0x332A6FDB),
    ),
  );
}
