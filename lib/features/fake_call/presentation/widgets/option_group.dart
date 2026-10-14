import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class OptionGroup extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;

  const OptionGroup({
    super.key,
    required this.title,
    required this.child,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final desc = description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.labelLarge?.copyWith(
            color: context.palette.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (desc != null) ...[
          const SizedBox(height: 2),
          Text(
            desc,
            style: textTheme.bodySmall?.copyWith(
              color: context.palette.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
