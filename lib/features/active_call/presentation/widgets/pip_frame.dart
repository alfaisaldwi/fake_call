import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PipFrame extends StatelessWidget {
  static const size = Size(112, 168);

  final Widget child;

  const PipFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: AppColors.callSurface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Color(0x66000000))],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
