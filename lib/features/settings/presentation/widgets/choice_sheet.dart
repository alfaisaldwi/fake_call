import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class ChoiceOption<T> {
  final T value;
  final String label;
  final Widget leading;

  const ChoiceOption({
    required this.value,
    required this.label,
    required this.leading,
  });
}

Future<T?> showChoiceSheet<T>({
  required BuildContext context,
  required String title,
  required List<ChoiceOption<T>> options,
  required T selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final palette = sheetContext.palette;
      final textTheme = Theme.of(sheetContext).textTheme;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              for (final option in options)
                _ChoiceRow(
                  option: option,
                  selected: option.value == selected,
                  color: palette.primary,
                  onTap: () => Navigator.of(sheetContext).pop(option.value),
                ),
            ],
          ),
        ),
      );
    },
  );
}

class _ChoiceRow<T> extends StatelessWidget {
  final ChoiceOption<T> option;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceRow({
    required this.option,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            option.leading,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option.label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: selected ? color : null,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: selected ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: Icon(Icons.check_rounded, size: 20, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
