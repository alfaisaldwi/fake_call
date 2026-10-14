import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/clock_time.dart';

class RingTimeChip extends StatelessWidget {
  final ClockTime? selected;
  final ValueChanged<ClockTime> onChanged;

  const RingTimeChip({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static String format(BuildContext context, ClockTime time) {
    return MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay(hour: time.hour, minute: time.minute),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final current = selected;
    final soon = TimeOfDay.fromDateTime(
      DateTime.now().add(const Duration(minutes: 15)),
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: current == null
          ? soon
          : TimeOfDay(hour: current.hour, minute: current.minute),
      helpText: AppLocalizations.of(context).ringAtPickerTitle,
    );
    if (picked != null) onChanged(ClockTime(picked.hour, picked.minute));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final time = selected;
    final isSelected = time != null;
    return ChoiceChip(
      avatar: Icon(
        Icons.schedule_rounded,
        size: 18,
        color: isSelected ? context.palette.selectedText : null,
      ),
      label: Text(
        time == null
            ? l10n.ringAtPick
            : l10n.ringAtLabel(format(context, time)),
        style: isSelected
            ? TextStyle(
                color: context.palette.selectedText,
                fontWeight: FontWeight.w600,
              )
            : null,
      ),
      selected: isSelected,
      showCheckmark: false,
      onSelected: (_) => _pick(context),
    );
  }
}
