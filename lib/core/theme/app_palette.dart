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
  );

  static const dark = AppPalette(
    primary: Color(0xFF6EA4FF),
    background: Color(0xFF0B1220),
    surface: Color(0xFF151E2E),
    outline: Color(0xFF26324A),
    textPrimary: Color(0xFFE6EBF5),
    textSecondary: Color(0xFF94A3B8),
    primaryTint: Color(0xFF1A2B4D),
  );

  final Color primary;
  final Color background;
  final Color surface;
  final Color outline;
  final Color textPrimary;
  final Color textSecondary;
  final Color primaryTint;

  const AppPalette({
    required this.primary,
    required this.background,
    required this.surface,
    required this.outline,
    required this.textPrimary,
    required this.textSecondary,
    required this.primaryTint,
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
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      outline: outline ?? this.outline,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      primaryTint: primaryTint ?? this.primaryTint,
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
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
