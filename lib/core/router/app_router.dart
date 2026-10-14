import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../widgets/top_toast.dart';

import '../../features/active_call/presentation/pages/active_call_page.dart';
import '../../features/fake_call/domain/entities/call_config.dart';
import '../../features/fake_call/presentation/pages/call_setup_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/onboarding/presentation/pages/splash_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/';
  static const activeCall = '/active-call';
  static const settings = '/settings';
}

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: TopToast.navigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (_, _) => _fade(const OnboardingPage()),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (_, _) => _fade(const CallSetupPage()),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.activeCall,
        redirect: (_, state) =>
            state.extra is CallConfig ? null : AppRoutes.home,
        builder: (_, state) =>
            ActiveCallPage(config: state.extra! as CallConfig),
      ),
    ],
  );

  static String get _currentPath =>
      router.routerDelegate.currentConfiguration.uri.path;

  static void openActiveCall(CallConfig config) {
    if (_currentPath == AppRoutes.activeCall) return;
    router.go(AppRoutes.activeCall, extra: config);
  }

  static CustomTransitionPage<void> _fade(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }

  static void leaveSplash({required bool showOnboarding}) {
    if (_currentPath != AppRoutes.splash) return;
    router.go(showOnboarding ? AppRoutes.onboarding : AppRoutes.home);
  }

  static void openSettings() => router.push(AppRoutes.settings);

  static void finishOnboarding() => router.go(AppRoutes.home);

  static void backToHome() {
    if (_currentPath != AppRoutes.home) router.go(AppRoutes.home);
  }
}
