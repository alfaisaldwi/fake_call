import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CallActionButton extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool isActive;
  final Color? backgroundColor;
  final double size;

  const CallActionButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.isActive = false,
    this.backgroundColor,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final background =
        backgroundColor ??
        (isActive ? AppColors.callButtonActive : AppColors.callButton);
    final foreground = isActive && backgroundColor == null
        ? AppColors.callIconActive
        : Colors.white;
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Material(
          color: background,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox.square(
              dimension: size,
              child: Icon(icon, color: foreground, size: size * 0.46),
            ),
          ),
        ),
      ),
    );
  }
}
