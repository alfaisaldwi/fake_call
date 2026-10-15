import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DraggablePip extends StatefulWidget {
  static const holdDuration = Duration(milliseconds: 180);

  final Size size;
  final EdgeInsets margin;
  final VoidCallback? onTap;
  final Widget child;

  const DraggablePip({
    super.key,
    required this.size,
    required this.margin,
    this.onTap,
    required this.child,
  });

  @override
  State<DraggablePip> createState() => _DraggablePipState();
}

class _DraggablePipState extends State<DraggablePip> {
  static const _snapDuration = Duration(milliseconds: 280);
  static const _flingProjection = 0.18;

  Alignment _corner = Alignment.bottomRight;
  Offset? _dragPosition;
  Offset _dragOrigin = Offset.zero;

  Offset _cornerPosition(Alignment corner, Size area) {
    final margin = widget.margin;
    final size = widget.size;
    return Offset(
      corner.x < 0 ? margin.left : area.width - margin.right - size.width,
      corner.y < 0 ? margin.top : area.height - margin.bottom - size.height,
    );
  }

  Offset _clamp(Offset position, Size area) {
    final margin = widget.margin;
    final size = widget.size;
    final maxX = area.width - margin.right - size.width;
    final maxY = area.height - margin.bottom - size.height;
    return Offset(
      position.dx.clamp(margin.left, maxX < margin.left ? margin.left : maxX),
      position.dy.clamp(margin.top, maxY < margin.top ? margin.top : maxY),
    );
  }

  void _onStart(Size area) {
    HapticFeedback.selectionClick();
    setState(() {
      _dragOrigin = _cornerPosition(_corner, area);
      _dragPosition = _dragOrigin;
    });
  }

  void _onMove(LongPressMoveUpdateDetails details, Size area) {
    setState(() {
      _dragPosition = _clamp(_dragOrigin + details.offsetFromOrigin, area);
    });
  }

  void _onEnd(LongPressEndDetails details, Size area) {
    final current = _dragPosition ?? _cornerPosition(_corner, area);
    final projected =
        current + details.velocity.pixelsPerSecond * _flingProjection;
    final center = projected + widget.size.center(Offset.zero);
    setState(() {
      _corner = Alignment(
        center.dx < area.width / 2 ? -1 : 1,
        center.dy < area.height / 2 ? -1 : 1,
      );
      _dragPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final area = constraints.biggest;
        final dragging = _dragPosition != null;
        final position = _dragPosition ?? _cornerPosition(_corner, area);
        return Stack(
          children: [
            AnimatedPositioned(
              duration: dragging ? Duration.zero : _snapDuration,
              curve: Curves.easeOutCubic,
              left: position.dx,
              top: position.dy,
              child: RawGestureDetector(
                behavior: HitTestBehavior.opaque,
                gestures: {
                  TapGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                        TapGestureRecognizer
                      >(
                        TapGestureRecognizer.new,
                        (recognizer) => recognizer.onTap = widget.onTap,
                      ),
                  LongPressGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                        LongPressGestureRecognizer
                      >(
                        () => LongPressGestureRecognizer(
                          duration: DraggablePip.holdDuration,
                        ),
                        (recognizer) {
                          recognizer
                            ..onLongPressStart = ((_) => _onStart(area))
                            ..onLongPressMoveUpdate = ((d) => _onMove(d, area))
                            ..onLongPressEnd = ((d) => _onEnd(d, area));
                        },
                      ),
                },
                child: AnimatedScale(
                  scale: dragging ? 1.06 : 1,
                  duration: const Duration(milliseconds: 150),
                  child: widget.child,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
