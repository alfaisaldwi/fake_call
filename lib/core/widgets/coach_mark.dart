import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../theme/app_palette.dart';

class CoachMark extends StatelessWidget {
  final GlobalKey showcaseKey;
  final String title;
  final String description;
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final List<TooltipActionButton>? actions;

  const CoachMark({
    super.key,
    required this.showcaseKey,
    required this.title,
    required this.description,
    required this.child,
    this.radius = 20,
    this.padding = const EdgeInsets.all(4),
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    return Showcase(
      key: showcaseKey,
      title: title,
      description: description,
      tooltipBackgroundColor: palette.surface,
      textColor: palette.textPrimary,
      titleTextStyle: textTheme.titleSmall?.copyWith(
        color: palette.textPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
      descTextStyle: textTheme.bodyMedium?.copyWith(
        color: palette.textSecondary,
        height: 1.4,
      ),
      titlePadding: const EdgeInsets.only(bottom: 4),
      tooltipPadding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      tooltipBorderRadius: BorderRadius.circular(16),
      targetBorderRadius: BorderRadius.circular(radius),
      targetPadding: padding,
      overlayColor: Colors.black,
      overlayOpacity: 0.55,
      disableMovingAnimation: true,
      tooltipActions: actions,
      child: child,
    );
  }
}

List<TooltipActionButton> coachMarkActions(
  BuildContext context, {
  required String skip,
  required String next,
}) {
  final palette = context.palette;
  return [
    TooltipActionButton(
      type: TooltipDefaultActionType.skip,
      name: skip,
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      textStyle: TextStyle(color: palette.textSecondary, fontSize: 13.5),
    ),
    TooltipActionButton(
      type: TooltipDefaultActionType.next,
      name: next,
      backgroundColor: palette.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13.5,
        fontWeight: FontWeight.w500,
      ),
    ),
  ];
}
