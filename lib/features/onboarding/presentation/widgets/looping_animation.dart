import 'package:flutter/widgets.dart';

class LoopingAnimation extends StatefulWidget {
  final Duration duration;
  final Widget Function(BuildContext context, double t) builder;

  const LoopingAnimation({
    super.key,
    required this.duration,
    required this.builder,
  });

  @override
  State<LoopingAnimation> createState() => _LoopingAnimationState();
}

class _LoopingAnimationState extends State<LoopingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => widget.builder(context, _controller.value),
    );
  }
}
