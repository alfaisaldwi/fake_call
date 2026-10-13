import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class AppForegroundListener extends StatefulWidget {
  final void Function(BuildContext context, bool isForeground) onChanged;
  final Widget child;

  const AppForegroundListener({
    super.key,
    required this.onChanged,
    required this.child,
  });

  @override
  State<AppForegroundListener> createState() => _AppForegroundListenerState();
}

class _AppForegroundListenerState extends State<AppForegroundListener> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onResume: () => widget.onChanged(context, true),
      onHide: () => widget.onChanged(context, false),
    );
    final state = SchedulerBinding.instance.lifecycleState;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onChanged(
          context,
          state == null || state == AppLifecycleState.resumed,
        );
      }
    });
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
