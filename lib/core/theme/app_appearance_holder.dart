import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppAppearanceHolder {
  bool _isDark = false;

  bool get isDark => _isDark;

  AppPalette get palette => _isDark ? AppPalette.dark : AppPalette.light;

  void update(Brightness brightness) => _isDark = brightness == Brightness.dark;
}

class AppearanceSync extends StatelessWidget {
  final AppAppearanceHolder holder;
  final Widget child;

  const AppearanceSync({super.key, required this.holder, required this.child});

  @override
  Widget build(BuildContext context) {
    holder.update(Theme.of(context).brightness);
    return child;
  }
}
