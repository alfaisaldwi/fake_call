import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  static const light = AppPalette(
    primary: AppColors.primary,
    background: AppColors.background,
    surface: AppColors.surface,
    outline: AppColors.outline,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    primaryTint: AppColors.primaryTint,
    selectedText: AppColors.primaryDark,
  );

  static const dark = AppPalette(
    primary: Color(0xFF93A6FF),
    background: Color(0xFF0B1220),
    surface: Color(0xFF151E2E),
    outline: Color(0xFF26324A),
    textPrimary: Color(0xFFE6EBF5),
    textSecondary: Color(0xFF94A3B8),
    primaryTint: Color(0xFF1F2650),
    selectedText: Color(0xFFD3DBFF),
  );

  final Color primary;
  final Color background;
  final Color surface;
  final Color outline;
  final Color textPrimary;
  final Color textSecondary;
  final Color primaryTint;
  final Color selectedText;

  const AppPalette({
    required this.primary,
    required this.background,
    required this.surface,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.primaryTint,
    required this.selectedText,
  });

  @override
  AppPalette copyWith({
    Color? primary,
    Color? background,
    Color? surface,
    Color? outline,
    Color? textPrimary,
    Color? textSecondary,
    Color? primaryTint,
    Color? selectedText,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      outline: outline ?? this.outline,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      primaryTint: primaryTint ?? this.primaryTint,
      selectedText: selectedText ?? this.selectedText,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      primaryTint: Color.lerp(primaryTint, other.primaryTint, t)!,
      selectedText: Color.lerp(selectedText, other.selectedText, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
