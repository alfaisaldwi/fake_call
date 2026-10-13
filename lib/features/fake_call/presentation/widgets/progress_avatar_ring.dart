import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/caller_avatar.dart';

class ProgressAvatarRing extends StatelessWidget {
  static const size = 208.0;

  final String callerName;
  final String? avatarPath;
  final double? progress;

  const ProgressAvatarRing({
    super.key,
    required this.callerName,
    required this.avatarPath,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final value = progress;
    final avatar = CallerAvatar(
      callerName: callerName,
      avatarPath: avatarPath,
      radius: 64,
    );
    return SizedBox.square(
      dimension: size,
      child: value == null
          ? _PulseRings(child: avatar)
          : TweenAnimationBuilder<double>(
              tween: Tween(end: value),
              duration: const Duration(milliseconds: 950),
              curve: Curves.linear,
              builder: (context, animated, child) =>
                  CustomPaint(painter: _RingPainter(animated), child: child),
              child: Center(child: avatar),
            ),
    );
  }
}

class _RingPainter extends CustomPainter {
  static const _stroke = 7.0;

  final double progress;

  const _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(_stroke / 2);
    final track = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke;
    final arc = Paint()
      ..shader = const SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [AppColors.green, AppColors.teal],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _stroke;
    canvas.drawCircle(rect.center, arcRect.width / 2, track);
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      2 * math.pi * progress.clamp(0, 1),
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _PulseRings extends StatefulWidget {
  final Widget child;

  const _PulseRings({required this.child});

  @override
  State<_PulseRings> createState() => _PulseRingsState();
}

class _PulseRingsState extends State<_PulseRings>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PulsePainter(_controller),
      child: Center(child: widget.child),
    );
  }
}

class _PulsePainter extends CustomPainter {
  static const _waves = 3;
  static const _innerRadius = 64.0;

  final Animation<double> animation;

  _PulsePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;
    for (var i = 0; i < _waves; i++) {
      final t = (animation.value + i / _waves) % 1;
      final radius = _innerRadius + (maxRadius - _innerRadius) * t;
      final paint = Paint()
        ..color = AppColors.green.withValues(alpha: 0.28 * (1 - t));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_PulsePainter oldDelegate) => false;
}
