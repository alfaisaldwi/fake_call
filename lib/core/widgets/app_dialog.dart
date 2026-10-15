import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_palette.dart';

enum DialogTone { info, warning, danger }

Future<bool?> showAppDialog({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
  DialogTone tone = DialogTone.info,
  Duration? confirmDelay,
}) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: confirmDelay == null,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.32),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, _, _) => _AppDialog(
      icon: icon,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      tone: tone,
      confirmDelay: confirmDelay,
    ),
    transitionBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.96, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _AppDialog extends StatefulWidget {
  final IconData icon;
  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;
  final DialogTone tone;
  final Duration? confirmDelay;

  const _AppDialog({
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.tone,
    required this.confirmDelay,
  });

  @override
  State<_AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<_AppDialog> {
  late bool _ready = widget.confirmDelay == null;

  IconData get icon => widget.icon;
  String get title => widget.title;
  String get message => widget.message;
  String get confirmLabel => widget.confirmLabel;
  String? get cancelLabel => widget.cancelLabel;
  DialogTone get tone => widget.tone;

  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: _ready, child: _buildDialog(context));
  }

  Widget _buildDialog(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    final accent = _accent(palette);
    final cancel = cancelLabel;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Material(
          color: palette.surface,
          borderRadius: BorderRadius.circular(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 22, color: accent),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: palette.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (cancel != null) ...[
                        Expanded(
                          child: _DialogButton(
                            label: cancel,
                            background: Colors.transparent,
                            foreground: palette.textSecondary,
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(child: _buildConfirm(context, accent)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _accent(AppPalette palette) => switch (tone) {
    DialogTone.info => palette.primary,
    DialogTone.warning => const Color(0xFFF59E0B),
    DialogTone.danger => AppColors.error,
  };

  Color _onAccent(AppPalette palette) => switch (tone) {
    DialogTone.info => palette.selectedText,
    DialogTone.warning => const Color(0xFFB45309),
    DialogTone.danger => AppColors.error,
  };

  Widget _buildConfirm(BuildContext context, Color accent) {
    final palette = context.palette;
    final background = accent.withValues(alpha: 0.14);
    final foreground = _onAccent(palette);
    final delay = widget.confirmDelay;
    if (delay != null) {
      return _CountdownButton(
        label: confirmLabel,
        delay: delay,
        background: background,
        foreground: foreground,
        onReady: () => setState(() => _ready = true),
        onPressed: () => Navigator.of(context).pop(true),
      );
    }
    return _DialogButton(
      label: confirmLabel,
      background: background,
      foreground: foreground,
      onPressed: () => Navigator.of(context).pop(true),
    );
  }
}

class _CountdownButton extends StatefulWidget {
  final String label;
  final Duration delay;
  final Color background;
  final Color foreground;
  final VoidCallback onReady;
  final VoidCallback onPressed;

  const _CountdownButton({
    required this.label,
    required this.delay,
    required this.background,
    required this.foreground,
    required this.onReady,
    required this.onPressed,
  });

  @override
  State<_CountdownButton> createState() => _CountdownButtonState();
}

class _CountdownButtonState extends State<_CountdownButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.delay,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward().whenComplete(() {
      if (mounted) widget.onReady();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _remaining =>
      ((1 - _controller.value) * widget.delay.inMilliseconds / 1000).ceil();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final ready = _controller.isCompleted;
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: ready ? 1 : 0.85,
          child: FilledButton(
            onPressed: ready ? widget.onPressed : null,
            style: FilledButton.styleFrom(
              backgroundColor: widget.background,
              disabledBackgroundColor: widget.background,
              foregroundColor: widget.foreground,
              disabledForegroundColor: widget.foreground.withValues(alpha: 0.6),
              elevation: 0,
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: ready
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: _CountdownRing(
                            progress: 1 - _controller.value,
                            seconds: _remaining,
                            color: widget.foreground,
                          ),
                        ),
                ),
                Text(widget.label),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CountdownRing extends StatelessWidget {
  final double progress;
  final int seconds;
  final Color color;

  const _CountdownRing({
    required this.progress,
    required this.seconds,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 2.2,
            color: color,
            backgroundColor: color.withValues(alpha: 0.2),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween(begin: 1.6, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                ),
                child: child,
              ),
            ),
            child: Text(
              '$seconds',
              key: ValueKey(seconds),
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        minimumSize: const Size.fromHeight(46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      child: Text(label),
    );
  }
}
