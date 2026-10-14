import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_dialog.dart';
import '../../../../core/widgets/caller_avatar.dart';
import '../../../../core/widgets/top_toast.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/call_config.dart';
import '../../domain/entities/caller_preset.dart';
import '../bloc/caller_presets_bloc.dart';

class CallerPresetBar extends StatelessWidget {
  final CallConfig config;
  final ValueChanged<CallerPreset> onApply;

  const CallerPresetBar({
    super.key,
    required this.config,
    required this.onApply,
  });

  void _showMessage(BuildContext context, CallerPresetsState state) {
    switch (state) {
      case CallerPresetSaved(:final name):
        TopToast.show(
          context,
          AppLocalizations.of(context).presetsSaved(name),
          type: ToastType.success,
        );
      case CallerPresetsError(:final message):
        TopToast.show(context, message, type: ToastType.error);
      case CallerPresetsLoaded():
        break;
    }
  }

  Future<void> _confirmDelete(BuildContext context, CallerPreset preset) async {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<CallerPresetsBloc>();
    final confirmed = await showAppDialog(
      context: context,
      icon: Icons.delete_outline_rounded,
      tone: DialogTone.danger,
      title: l10n.presetsDeleteTitle(preset.name),
      message: l10n.presetsDeleteBody,
      cancelLabel: l10n.cropCancel,
      confirmLabel: l10n.presetsDelete,
    );
    if (confirmed == true) bloc.add(CallerPresetDeleteRequested(preset.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return BlocConsumer<CallerPresetsBloc, CallerPresetsState>(
      listenWhen: (_, current) => current is! CallerPresetsLoaded,
      listener: _showMessage,
      builder: (context, state) {
        final presets = state.presets;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                l10n.presetsTitle,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (presets.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 4, 0),
                child: Text(
                  l10n.presetsEmpty,
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(
              height: 92,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _SaveTile(
                    label: l10n.presetsSave,
                    onTap: () => context.read<CallerPresetsBloc>().add(
                      CallerPresetSaveRequested(config),
                    ),
                  ),
                  for (final preset in presets)
                    _PresetTile(
                      preset: preset,
                      selected: preset.matches(config),
                      onTap: () => onApply(preset),
                      onLongPress: () => _confirmDelete(context, preset),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SaveTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SaveTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _TileFrame(
      label: label,
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.primaryContainer,
          border: Border.all(color: scheme.primary, width: 1.5),
        ),
        child: Icon(Icons.bookmark_add_outlined, color: scheme.primary),
      ),
    );
  }
}

class _PresetTile extends StatelessWidget {
  final CallerPreset preset;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _PresetTile({
    required this.preset,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _TileFrame(
      label: preset.name,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? scheme.primary : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: CallerAvatar(
              callerName: preset.name,
              avatarPath: preset.avatarPath,
              radius: 23,
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: scheme.surface,
              child: Icon(
                preset.callType == CallType.video ? Icons.videocam : Icons.call,
                size: 12,
                color: scheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TileFrame extends StatelessWidget {
  final String label;
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _TileFrame({
    required this.label,
    required this.child,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onLongPress,
        child: SizedBox(
          width: 72,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child,
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
