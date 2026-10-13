import 'dart:async';

import 'package:flutter/widgets.dart';

class TapGuard extends StatefulWidget {
  final Duration duration;
  final Widget child;

  const TapGuard({
    super.key,
    this.duration = const Duration(seconds: 1),
    required this.child,
  });

  @override
  State<TapGuard> createState() => _TapGuardState();
}

class _TapGuardState extends State<TapGuard> {
  late final Timer _timer;
  bool _armed = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.duration, () {
      if (mounted) setState(() => _armed = true);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(ignoring: !_armed, child: widget.child);
  }
}
