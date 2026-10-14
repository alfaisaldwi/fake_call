import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'looping_animation.dart';

const _glass = Color(0x29FFFFFF);
const _glassBorder = Color(0x40FFFFFF);

double _wave(double t, [double phase = 0]) =>
    math.sin((t + phase) * 2 * math.pi);

class IncomingCallIllustration extends StatelessWidget {
  const IncomingCallIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return LoopingAnimation(
      duration: const Duration(milliseconds: 2400),
      builder: (context, t) => Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < 3; i++) _ring((t + i / 3) % 1),
          Container(
            width: 150,
            height: 250,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: _glass,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: _glassBorder, width: 1.5),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 36, color: AppColors.primary),
                ),
                const SizedBox(height: 12),
                Container(width: 70, height: 8, decoration: _bar(0.9)),
                const SizedBox(height: 6),
                Container(width: 50, height: 6, decoration: _bar(0.5)),
                const Spacer(),
                Transform.translate(
                  offset: Offset(0, -6 * _wave(t * 2).abs()),
                  child: const CircleAvatar(
                    radius: 22,
                    backgroundColor: Color(0xFF1DAA61),
                    child: Icon(Icons.call, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ring(double progress) {
    final size = 150 + 170 * progress;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35 * (1 - progress)),
          width: 2,
        ),
      ),
    );
  }
}

class CustomizeIllustration extends StatelessWidget {
  const CustomizeIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return LoopingAnimation(
      duration: const Duration(milliseconds: 3200),
      builder: (context, t) => SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 170,
              height: 200,
              decoration: BoxDecoration(
                color: _glass,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: _glassBorder, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: 0.08 * _wave(t),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.face,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(width: 90, height: 10, decoration: _bar(0.9)),
                ],
              ),
            ),
            _chip(t, 0, const Alignment(-1, -0.75), Icons.badge_outlined),
            _chip(t, 0.33, const Alignment(1, -0.35), Icons.image_outlined),
            _chip(t, 0.66, const Alignment(-0.85, 0.85), Icons.movie_outlined),
            _chip(t, 0.5, const Alignment(0.95, 0.75), Icons.timer_outlined),
          ],
        ),
      ),
    );
  }

  Widget _chip(double t, double phase, Alignment alignment, IconData icon) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: Offset(0, 10 * _wave(t, phase)),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(blurRadius: 20, color: Color(0x33000000)),
            ],
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
      ),
    );
  }
}

class EscapeIllustration extends StatelessWidget {
  const EscapeIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return LoopingAnimation(
      duration: const Duration(milliseconds: 3600),
      builder: (context, t) {
        final slide = Curves.easeOutBack.transform(
          ((t - 0.15) / 0.25).clamp(0.0, 1.0),
        );
        final fadeOut = 1 - ((t - 0.85) / 0.15).clamp(0.0, 1.0);
        return SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.square(
                dimension: 190,
                child: CustomPaint(painter: _ClockPainter(t)),
              ),
              const Icon(Icons.directions_run, size: 64, color: Colors.white),
              Positioned(
                bottom: 8,
                child: Opacity(
                  opacity: slide.clamp(0.0, 1.0) * fadeOut,
                  child: Transform.translate(
                    offset: Offset(0, 40 * (1 - slide)),
                    child: _missedCard(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _missedCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(blurRadius: 24, color: Color(0x40000000))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 8,
                decoration: _bar(1, AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.call_missed,
                    size: 14,
                    color: AppColors.endCall,
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 56,
                    height: 6,
                    decoration: _bar(0.4, AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final double t;

  const _ClockPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final track = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final arc = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;
    final inner = rect.deflate(5);
    canvas.drawCircle(rect.center, inner.width / 2, track);
    canvas.drawArc(inner, -math.pi / 2, 2 * math.pi * (1 - t), false, arc);
  }

  @override
  bool shouldRepaint(_ClockPainter oldDelegate) => oldDelegate.t != t;
}

BoxDecoration _bar(double opacity, [Color color = Colors.white]) {
  return BoxDecoration(
    color: color.withValues(alpha: opacity),
    borderRadius: BorderRadius.circular(4),
  );
}
