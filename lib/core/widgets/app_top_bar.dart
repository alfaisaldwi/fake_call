import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_palette.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;

  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
  });

  static const height = 68.0;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  static ThemeData themed(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final isDark = theme.brightness == Brightness.dark;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        toolbarHeight: height,
        backgroundColor: palette.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: palette.textPrimary,
        scrolledUnderElevation: 0.5,
        shadowColor: palette.outline,
        leadingWidth: 76,
        titleSpacing: 0,
        titleTextStyle: theme.textTheme.titleLarge?.copyWith(
          color: palette.textPrimary,
          fontWeight: FontWeight.w600,
          height: 1.1,
        ),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) => Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: palette.surface,
            shape: BoxShape.circle,
            border: Border.all(color: palette.outline),
          ),
          child: Icon(Icons.arrow_back, size: 22, color: palette.textPrimary),
        ),
      ),
      scaffoldBackgroundColor: palette.background,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sub = subtitle;
    final lead = leading;
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: palette.background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: palette.textPrimary,
      scrolledUnderElevation: 0.5,
      shadowColor: palette.outline,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      title: Row(
        children: [
          if (lead != null) ...[lead, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge?.copyWith(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
                if (sub != null)
                  Text(
                    sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: palette.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [...actions, const SizedBox(width: 12)],
    );
  }
}

class LargeTopBar extends StatelessWidget {
  static const _expandedHeight = 132.0;

  final String title;
  final String? subtitle;
  final List<Widget> actions;

  const LargeTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sub = subtitle;
    return SliverAppBar(
      pinned: true,
      expandedHeight: _expandedHeight,
      toolbarHeight: AppTopBar.height,
      backgroundColor: palette.background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: palette.textPrimary,
      scrolledUnderElevation: 0.5,
      shadowColor: palette.outline,
      automaticallyImplyLeading: false,
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      actions: [...actions, const SizedBox(width: 12)],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final top = MediaQuery.paddingOf(context).top;
          final range = _expandedHeight - AppTopBar.height;
          final expanded =
              ((constraints.maxHeight - top - AppTopBar.height) / range).clamp(
                0.0,
                1.0,
              );
          final titleStyle = TextStyle.lerp(
            textTheme.titleLarge,
            textTheme.headlineMedium,
            expanded,
          )?.copyWith(color: palette.textPrimary, fontWeight: FontWeight.w700);
          return Padding(
            padding: EdgeInsets.fromLTRB(16, top, 72, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle,
                ),
                if (sub != null)
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topLeft,
                      heightFactor: expanded,
                      child: Opacity(
                        opacity: expanded,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            sub,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.copyWith(
                              color: palette.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 12 + 10 * expanded),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TopBarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool outlined;
  final Color? color;

  const TopBarButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.outlined = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: outlined ? palette.surface : Colors.transparent,
        foregroundColor: color ?? palette.textPrimary,
        fixedSize: const Size.square(44),
        side: outlined ? BorderSide(color: palette.outline) : null,
      ),
      icon: Icon(icon, size: outlined ? 22 : 26),
    );
  }
}
