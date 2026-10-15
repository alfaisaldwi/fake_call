import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/onboarding_bloc.dart';

class SplashPage extends StatefulWidget {
  static const minimumDuration = Duration(milliseconds: 1800);
  static const _logoSize = 88.0;
  static const _ringsSize = 420.0;

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();
  late final Animation<double> _logoScale = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0, 0.6, curve: Curves.easeOutBack),
  );
  late final Animation<double> _textFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.45, 1, curve: Curves.easeOut),
  );
  late final Timer _minimum = Timer(SplashPage.minimumDuration, _tryLeave);

  @override
  void initState() {
    super.initState();
    _minimum;
  }

  @override
  void dispose() {
    _minimum.cancel();
    _intro.dispose();
    super.dispose();
  }

  void _tryLeave() {
    if (!mounted || _minimum.isActive) return;
    switch (context.read<OnboardingBloc>().state) {
      case OnboardingRequired():
        AppRouter.leaveSplash(showOnboarding: true);
      case OnboardingDone() || OnboardingError():
        AppRouter.leaveSplash(showOnboarding: false);
      case OnboardingChecking():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (_, _) => _tryLeave(),
      child: Scaffold(
        backgroundColor: palette.background,
        body: Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(opacity: _textFade, child: const _SplashBackdrop()),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox.square(
                    dimension: SplashPage._logoSize,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        OverflowBox(
                          maxWidth: SplashPage._ringsSize,
                          maxHeight: SplashPage._ringsSize,
                          child: FadeTransition(
                            opacity: _textFade,
                            child: CustomPaint(
                              size: const Size.square(SplashPage._ringsSize),
                              painter: _RingsPainter(
                                color: AppColors.brandPeriwinkle.withValues(
                                  alpha: isDark ? 0.14 : 0.28,
                                ),
                              ),
                            ),
                          ),
                        ),
                        ScaleTransition(
                          scale: _logoScale,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/img/launcher/launcher_icon.png',
                              width: SplashPage._logoSize,
                              height: SplashPage._logoSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _textFade,
                    child: Text(
                      l10n.homeTitle,
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  FadeTransition(
                    opacity: _textFade,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/img/elumi.png',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashBackdrop extends StatelessWidget {
  const _SplashBackdrop();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strength = isDark ? 0.18 : 0.45;
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -140,
            right: -120,
            child: _Glow(
              size: 360,
              color: AppColors.brandSky.withValues(alpha: strength),
            ),
          ),
          Positioned(
            bottom: -160,
            left: -140,
            child: _Glow(
              size: 400,
              color: AppColors.brandPeriwinkle.withValues(alpha: strength),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;

  const _Glow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  static const _radii = [90.0, 140.0, 200.0];

  final Color color;

  const _RingsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    for (final (index, radius) in _radii.indexed) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = color.withValues(alpha: color.a * (1 - index * 0.3));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RingsPainter oldDelegate) => oldDelegate.color != color;
}
