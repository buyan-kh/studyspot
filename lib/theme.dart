import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFFFF7F2);
  static const navy = Color(0xFF1B2A4A);
  static const coral = Color(0xFFF27886);
  static const coralDeep = Color(0xFFE85D78);
  static const blush = Color(0xFFFFF0F3);
  static const muted = Color(0xFF7C8598);
  static const line = Color(0xFFF0E4DC);
  static const green = Color(0xFF2EAE6A);
  static const orange = Color(0xFFF0A02A);
  static const red = Color(0xFFEF5D6C);
  static const yellow = Color(0xFFE6B325);
  static const chip = Color(0xFFF7F1EC);
}

TextStyle nunito({
  double size = 14,
  FontWeight weight = FontWeight.w600,
  Color color = AppColors.navy,
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontFamily: 'Nunito',
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
    fontVariations: [FontVariation('wght', weight.value.toDouble())],
  );
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Nunito',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.coral,
      surface: AppColors.background,
    ),
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: 'Nunito',
      bodyColor: AppColors.navy,
      displayColor: AppColors.navy,
    ),
    iconTheme: const IconThemeData(color: AppColors.navy),
    splashColor: AppColors.coral.withValues(alpha: 0.12),
    highlightColor: AppColors.coral.withValues(alpha: 0.06),
    dividerColor: AppColors.line,
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.navy,
      contentTextStyle: nunito(color: Colors.white, weight: FontWeight.w700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: nunito(color: AppColors.muted, weight: FontWeight.w600),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.coral, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.coral),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.coralDeep, width: 1.6),
      ),
    ),
  );
}
