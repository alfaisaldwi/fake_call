import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/app_permission.dart';
import '../bloc/permissions_bloc.dart';

class PermissionChecklist extends StatelessWidget {
  const PermissionChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      (
        AppPermission.notification,
        Icons.notifications_active_outlined,
        l10n.permissionNotificationTitle,
        l10n.permissionNotificationBody,
      ),
      (
        AppPermission.fullScreen,
        Icons.lock_open_outlined,
        l10n.permissionFullScreenTitle,
        l10n.permissionFullScreenBody,
      ),
      (
        AppPermission.camera,
        Icons.videocam_outlined,
        l10n.permissionCameraTitle,
        l10n.permissionCameraBody,
      ),
      (
        AppPermission.exactAlarm,
        Icons.alarm_on_outlined,
        l10n.permissionExactAlarmTitle,
        l10n.permissionExactAlarmBody,
      ),
      (
        AppPermission.battery,
        Icons.battery_charging_full_outlined,
        l10n.permissionBatteryTitle,
        l10n.permissionBatteryBody,
      ),
    ];
    return BlocBuilder<PermissionsBloc, PermissionsState>(
      builder: (context, state) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (index, item) in items.indexed)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 400 + 120 * index),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 24 * (1 - value)),
                    child: child,
                  ),
                ),
                child: _PermissionTile(
                  icon: item.$2,
                  title: item.$3,
                  body: item.$4,
                  granted: state.snapshot.isGranted(item.$1),
                  onRequest: () => context.read<PermissionsBloc>().add(
                    PermissionRequested(item.$1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final bool granted;
  final VoidCallback onRequest;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.granted,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: granted ? 0.22 : 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: granted
                ? Semantics(
                    key: const ValueKey('granted'),
                    label: l10n.permissionGranted,
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFF1DAA61),
                      child: Icon(Icons.check, size: 18, color: Colors.white),
                    ),
                  )
                : FilledButton(
                    key: const ValueKey('allow'),
                    onPressed: onRequest,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: Text(l10n.permissionAllow),
                  ),
          ),
        ],
      ),
    );
  }
}
