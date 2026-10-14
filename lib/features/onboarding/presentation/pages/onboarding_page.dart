import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/app_foreground_listener.dart';
import '../../../../injection_container.dart';
import '../../../permissions/presentation/bloc/permissions_bloc.dart';
import '../../../permissions/presentation/widgets/permission_checklist.dart';
import '../bloc/onboarding_bloc.dart';
import '../widgets/onboarding_illustrations.dart';
import '../widgets/onboarding_slide.dart';
import '../widgets/page_dots.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PermissionsBloc>()..add(const PermissionsChecked()),
      child: AppForegroundListener(
        onChanged: (context, isForeground) {
          if (isForeground) {
            context.read<PermissionsBloc>().add(const PermissionsChecked());
          }
        },
        child: const _OnboardingView(),
      ),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  static const _illustrations = [
    IncomingCallIllustration(),
    CustomizeIllustration(),
    EscapeIllustration(),
    PermissionChecklist(),
  ];

  static const _reminderDelay = Duration(seconds: 5);

  final _controller = PageController();
  bool _reminded = false;

  double get _page => _controller.hasClients ? _controller.page ?? 0 : 0;

  bool get _isLast => _page.round() == _illustrations.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    context.read<OnboardingBloc>().add(const OnboardingFinished());
    AppRouter.finishOnboarding();
  }

  void _onPageChanged(int index) {
    if (index != _illustrations.length - 1 || _reminded) return;
    final snapshot = context.read<PermissionsBloc>().state.snapshot;
    if (snapshot.allGranted) return;
    _reminded = true;
    final l10n = AppLocalizations.of(context);
    showAppDialog(
      context: context,
      icon: Icons.verified_user_outlined,
      title: l10n.permissionReminderTitle,
      message: l10n.permissionReminderBody,
      confirmLabel: l10n.permissionReminderConfirm,
      confirmDelay: _reminderDelay,
    );
  }

  void _next() {
    if (_isLast) return _finish();
    _controller.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final texts = [
      (l10n.onboarding1Title, l10n.onboarding1Body),
      (l10n.onboarding2Title, l10n.onboarding2Body),
      (l10n.onboarding3Title, l10n.onboarding3Body),
      (l10n.onboarding4Title, l10n.onboarding4Body),
    ];
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.brandSky, AppColors.brandPeriwinkle],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedOpacity(
                    opacity: _isLast ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: TextButton(
                      onPressed: _isLast ? null : _finish,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.brandInk,
                      ),
                      child: Text(l10n.onboardingSkip),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: texts.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) => OnboardingSlide(
                      offset: _page - index,
                      illustration: _illustrations[index],
                      title: texts[index].$1,
                      body: texts[index].$2,
                    ),
                  ),
                ),
                PageDots(count: texts.length, page: _page),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: FilledButton(
                    onPressed: _next,
                    style: AppTheme.brandButton(
                      FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _isLast ? l10n.onboardingStart : l10n.onboardingNext,
                        key: ValueKey(_isLast),
                      ),
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
}
