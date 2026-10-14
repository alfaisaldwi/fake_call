import 'package:flutter/material.dart';

class OnboardingSlide extends StatelessWidget {
  final double offset;
  final Widget illustration;
  final String title;
  final String body;

  const OnboardingSlide({
    super.key,
    required this.offset,
    required this.illustration,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final distance = offset.abs().clamp(0.0, 1.0);
    final width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Expanded(
            child: Transform.translate(
              offset: Offset(offset * width * 0.35, 0),
              child: Transform.scale(
                scale: 1 - 0.15 * distance,
                child: Opacity(
                  opacity: 1 - 0.6 * distance,
                  child: Center(child: illustration),
                ),
              ),
            ),
          ),
          Opacity(
            opacity: 1 - distance,
            child: Transform.translate(
              offset: Offset(offset * width * 0.6, 0),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
