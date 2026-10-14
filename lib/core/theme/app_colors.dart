import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF5D74EE);
  static const primaryDark = Color(0xFF4458CF);
  static const accent = Color(0xFF8FB8FA);
  static const brandPastel = Color(0xFFB3CBFC);
  static const brandSky = Color(0xFFC2E3FE);
  static const brandPeriwinkle = Color(0xFFA5B8FD);
  static const brandCoral = Color(0xFFF26B6B);
  static const brandInk = Color(0xFF1E2A5A);
  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7FA6F7), Color(0xFF5D74EE)],
  );
  static const primaryTint = Color(0xFFECF0FF);
  static const background = Color(0xFFF4F6FD);
  static const surface = Color(0xFFFFFFFF);
  static const outline = Color(0xFFDFE4F3);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const error = Color(0xFFD93A3A);
  static const callBackground = Color(0xFF0B141A);
  static const callSurface = Color(0xFF1F2C34);
  static const callPanel = Color(0xE61F2C34);
  static const callButton = Color(0x26FFFFFF);
  static const callButtonActive = Color(0xFFFFFFFF);
  static const callIconActive = Color(0xFF0B141A);
  static const callSecondaryText = Color(0xB3FFFFFF);
  static const endCall = Color(0xFFEA0038);
}
