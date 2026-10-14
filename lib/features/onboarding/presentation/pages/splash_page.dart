import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/looping_animation.dart';

class SplashPage extends StatefulWidget {
  static const minimumDuration = Duration(milliseconds: 1800);

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
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (_, _) => _tryLeave(),
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LoopingAnimation(
                        duration: const Duration(milliseconds: 2000),
                        builder: (context, t) => Stack(
                          alignment: Alignment.center,
                          children: [
                            for (var i = 0; i < 2; i++) _pulse((t + i / 2) % 1),
                          ],
                        ),
                      ),
                      ScaleTransition(
                        scale: _logoScale,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/img/launcher/launcher_icon.png',
                            width: 128,
                            height: 128,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FadeTransition(
                  opacity: _textFade,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.4),
                      end: Offset.zero,
                    ).animate(_textFade),
                    child: Column(
                      children: [
                        Text(
                          l10n.appTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.splashTagline,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pulse(double progress) {
    final size = 128 + 92 * progress;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30 + 40 * progress),
        color: Colors.white.withValues(alpha: 0.14 * (1 - progress)),
      ),
    );
  }
}
