import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';

abstract final class AppTheme {
  static ButtonStyle brandButton(ButtonStyle? base) {
    return (base ?? const ButtonStyle()).copyWith(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
      backgroundBuilder: (context, states, child) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: states.contains(WidgetState.disabled)
              ? null
              : AppColors.brandGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }

  static final ThemeData light = build();
  static final ThemeData dark = build(brightness: Brightness.dark);

  static ThemeData build({
    String? fontFamily,
    Brightness brightness = Brightness.light,
  }) {
    final p = brightness == Brightness.dark
        ? AppPalette.dark
        : AppPalette.light;
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
          primary: p.primary,
          secondary: AppColors.accent,
          error: AppColors.error,
        ).copyWith(
          surface: p.surface,
          onSurface: p.textPrimary,
          onSurfaceVariant: p.textSecondary,
          outlineVariant: p.outline,
        );
    final rounded = BorderRadius.circular(14);
    return ThemeData(
      brightness: brightness,
      extensions: [p],
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: p.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardThemeData(
        color: p.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: p.outline),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: p.surface,
        selectedColor: p.primaryTint,
        checkmarkColor: p.primary,
        side: WidgetStateBorderSide.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? BorderSide(color: p.primary, width: 1.4)
              : BorderSide(color: p.outline),
        ),
        shape: const StadiumBorder(),
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          color: p.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.background,
        hintStyle: TextStyle(color: p.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: rounded,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: rounded,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: rounded,
          borderSide: BorderSide(color: p.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: rounded,
          borderSide: const BorderSide(color: AppColors.error, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: rounded,
          borderSide: const BorderSide(color: AppColors.error, width: 1.8),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: p.outline, thickness: 1, space: 32),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: p.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        contentTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: p.textSecondary,
          fontSize: 14,
          height: 1.45,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: p.surface,
        elevation: 0,
        modalElevation: 0,
        dragHandleColor: p.outline,
        dragHandleSize: const Size(36, 4),
        modalBarrierColor: Colors.black.withValues(alpha: 0.32),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
