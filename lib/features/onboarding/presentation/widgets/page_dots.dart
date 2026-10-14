import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PageDots extends StatelessWidget {
  final int count;
  final double page;

  const PageDots({super.key, required this.count, required this.page});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          Builder(
            builder: (context) {
              final active = (1 - (page - i).abs()).clamp(0.0, 1.0);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8 + 20 * active,
                height: 8,
                decoration: BoxDecoration(
                  color: Color.lerp(
                    Colors.white.withValues(alpha: 0.7),
                    AppColors.primary,
                    active,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
      ],
    );
  }
}
