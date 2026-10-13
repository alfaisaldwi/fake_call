import 'package:go_router/go_router.dart';

import '../../features/active_call/presentation/pages/active_call_page.dart';
import '../../features/fake_call/domain/entities/call_config.dart';
import '../../features/fake_call/presentation/pages/call_setup_page.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const activeCall = '/active-call';
}

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(path: AppRoutes.home, builder: (_, _) => const CallSetupPage()),
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

  static void backToHome() {
    if (_currentPath != AppRoutes.home) router.go(AppRoutes.home);
  }
}
