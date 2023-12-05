part of '../tooltips.dart';

class ThemedTooltip extends StatefulWidget {
  /// [child] is the widget that will be wrapped by the tooltip.
  final Widget child;

  /// [message] is the message that will be displayed in the tooltip.
  final String message;

  /// [position] is the position of the tooltip relative to the child.
  final ThemedTooltipPosition position;

  /// [color] is the color of the tooltip. By default, we use the `Theme.of(context).tooltipTheme.decoration` object.
  final Color? color;

  /// [ThemedTooltip] is a widget that displays a tooltip with a custom message.
  /// It's a re-interpretation of the [Tooltip] widget, but fixing/allowing the tap gesture to the child element.
  const ThemedTooltip({
    super.key,
    required this.child,
    required this.message,
    this.position = ThemedTooltipPosition.bottom,
    this.color,
  });

  @override
  State<ThemedTooltip> createState() => _ThemedTooltipState();
}

class _ThemedTooltipState extends State<ThemedTooltip> with TickerProviderStateMixin {
  late AnimationController _controller;
  late bool _hasMouseDetected;
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _entry;

  TextStyle? get _defaultTextStyle {
    try {
      return Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12);
    } catch (_) {
      return null;
    }
  }

  EdgeInsets get _defaultPadding => const EdgeInsets.all(5);

  @override
  void initState() {
    super.initState();
    _hasMouseDetected = RendererBinding.instance.mouseTracker.mouseIsConnected;

    RendererBinding.instance.mouseTracker.addListener(_handleMouseTrackerChange);
    GestureBinding.instance.pointerRouter.addGlobalRoute(_handlePointerEvent);

    _controller = AnimationController(duration: kHoverDuration, vsync: this);
  }

  /// [_handleMouseTrackerChange] is called when the mouse is connected/disconnected.
  void _handleMouseTrackerChange() {
    if (!mounted) return;

    final bool hasMouseDetected = RendererBinding.instance.mouseTracker.mouseIsConnected;
    if (hasMouseDetected != _hasMouseDetected) {
      setState(() => _hasMouseDetected = hasMouseDetected);
    }
  }

  /// [_handleMouseEnter] is called when the mouse enters the widget.
  void _handlePointerEvent(PointerEvent event) {
    if (_entry == null) {
      return;
    }
    if (event is PointerUpEvent || event is PointerCancelEvent) {
      _handleMouseExit();
    } else if (event is PointerDownEvent) {
      _handleMouseExit(immediately: true);
    }
  }

  /// [_handleMouseEnter] is called when the mouse enters the widget.
  /// If [immediately] is true, the tooltip will be displayed immediately.
  /// Otherwise, it will be displayed after a delay.
  void _handleMouseExit({bool immediately = false}) {
    _removeEntry(immediately: immediately);
  }

  /// [_handleMouseEnter] is called when the mouse enters the widget.
  void _handleMouseEnter() {
    if (mounted) _buildEntry();
  }

  /// [_predictTextSize] predicts the size of the tooltip based on the text.
  Size _predictTextSize(String text) {
    final double maxWidth = MediaQuery.of(context).size.width * 0.8;
    TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: _defaultTextStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return Size(
      painter.width + _defaultPadding.horizontal,
      painter.height + _defaultPadding.vertical,
    );
  }

  @override
  void dispose() {
    _removeEntry(immediately: true);
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_handlePointerEvent);
    RendererBinding.instance.mouseTracker.removeListener(_handleMouseTrackerChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Semantics(
      child: widget.child,
      tooltip: widget.message,
    );

    if (_hasMouseDetected) {
      return MouseRegion(
        key: _key,
        onEnter: (_) => _handleMouseEnter(),
        onExit: (_) => _handleMouseExit(),
        child: child,
      );
    }

    return GestureDetector(
      key: _key,
      behavior: HitTestBehavior.opaque,
      onLongPress: () => _handleMouseEnter(),
      excludeFromSemantics: true,
      child: child,
    );
  }

  /// [_removeEntry] removes the tooltip from the overlay.
  void _removeEntry({bool immediately = false}) async {
    if (!immediately) await _controller.reverse();
    _entry?.remove();
    _entry = null;
  }

  /// [_buildEntry] builds the tooltip and adds it to the overlay.
  void _buildEntry() {
    final OverlayState state = Overlay.of(context, rootOverlay: true);

    final RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
    final Offset target = box.localToGlobal(Offset.zero);

    double? top;
    double? left;
    double? right;
    double? bottom;

    Size size = _predictTextSize(widget.message);
    Size screenSize = MediaQuery.of(context).size;

    double width = size.width;
    double height = size.height;

    double halfPredictedSizeWidth = size.width / 2;
    double halfPredictedSizeHeight = size.height / 2;

    switch (widget.position) {
      case ThemedTooltipPosition.top:
        bottom = screenSize.height - target.dy + 10;
        double center = target.dx + (box.size.width / 2);

        if (center - halfPredictedSizeWidth < 0) {
          left = 0;
        } else if (center + halfPredictedSizeWidth > screenSize.width) {
          right = 0;
        } else {
          left = center - halfPredictedSizeWidth;
        }
        break;
      case ThemedTooltipPosition.bottom:
        top = target.dy + box.size.height + 10;
        double center = target.dx + (box.size.width / 2);

        if (center - halfPredictedSizeWidth < 0) {
          left = 0;
        } else if (center + halfPredictedSizeWidth > screenSize.width) {
          right = 0;
        } else {
          left = center - halfPredictedSizeWidth;
        }
        break;
      case ThemedTooltipPosition.right:
        top = target.dy + (box.size.height / 2) - halfPredictedSizeHeight;
        left = target.dx + box.size.width + 10;

        double remainingWidth = screenSize.width - left;
        if (remainingWidth < size.width) {
          right = null;
          left = target.dx - size.width - 10;

          if (left < 0) {
            left = 10;
            width = target.dx - 20;
          }
        }

        break;
      case ThemedTooltipPosition.left:
        top = target.dy + (box.size.height / 2) - halfPredictedSizeHeight;
        right = screenSize.width - target.dx + 10;

        double remainingWidth = screenSize.width - right;
        if (remainingWidth < size.width) {
          left = null;
          right = target.dx + box.size.width + 10;

          if (remainingWidth - right < 0) {
            right = null;
            left = target.dx + box.size.width + 10;
            width = screenSize.width - left - 10;

            if (width > size.width) {
              width = size.width;
            }
          }
        }
        break;
    }

    BoxDecoration decoration = BoxDecoration(color: Theme.of(context).primaryColor);

    if (Theme.of(context).tooltipTheme.decoration is BoxDecoration) {
      decoration = Theme.of(context).tooltipTheme.decoration as BoxDecoration;
    }

    if (widget.color != null) {
      decoration = decoration.copyWith(color: widget.color);
    }

    _entry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: top,
              left: left,
              right: right,
              bottom: bottom,
              width: width,
              height: height,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value,
                    child: child,
                  );
                },
                child: Container(
                  decoration: decoration,
                  padding: _defaultPadding,
                  child: Text(
                    widget.message,
                    style: _defaultTextStyle?.copyWith(
                      color: validateColor(color: decoration.color ?? Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );

    state.insert(_entry!);

    _controller.forward();
  }
}

enum ThemedTooltipPosition { top, bottom, left, right }
