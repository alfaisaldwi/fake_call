import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/app_foreground_listener.dart';
import '../../../../core/widgets/top_toast.dart';
import '../../../../injection_container.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/permissions_bloc.dart';
import 'permission_checklist.dart';

Future<void> showPermissionSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => BlocProvider(
      create: (_) => sl<PermissionsBloc>()..add(const PermissionsChecked()),
      child: const _PermissionSheet(),
    ),
  );
}

class _PermissionSheet extends StatelessWidget {
  const _PermissionSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return AppForegroundListener(
      onChanged: (context, isForeground) {
        if (isForeground) {
          context.read<PermissionsBloc>().add(const PermissionsChecked());
        }
      },
      child: BlocListener<PermissionsBloc, PermissionsState>(
        listenWhen: (_, current) => current is PermissionsError,
        listener: (context, state) {
          if (state is PermissionsError) {
            TopToast.show(context, state.message, type: ToastType.error);
          }
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      l10n.settingsPermissions,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      l10n.settingsPermissionsBody,
                      style: textTheme.bodyMedium?.copyWith(
                        color: context.palette.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Flexible(child: PermissionChecklist(onBrand: false)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
