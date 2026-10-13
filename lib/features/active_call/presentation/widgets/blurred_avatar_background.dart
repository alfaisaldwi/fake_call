import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/caller_avatar.dart';

class BlurredAvatarBackground extends StatelessWidget {
  final String? avatarPath;

  const BlurredAvatarBackground({super.key, required this.avatarPath});

  @override
  Widget build(BuildContext context) {
    final image = callerAvatarImage(avatarPath);
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.callBackground),
        if (image != null)
          ClipRect(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Image(
                image: image,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x99000000), Color(0x66000000), Color(0xCC000000)],
            ),
          ),
        ),
      ],
    );
  }
}
