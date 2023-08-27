part of inputs;

typedef OnSearch = void Function(String value);

class ThemedSearchInput extends StatefulWidget {
  final String value;
  final OnSearch onSearch;
  final double maxWidth;
  final String labelText;
  final Widget? customChild;
  final bool disabled;
  final ThemedSearchPosition position;

  /// [ThemedSearchInput] is a search input.
  const ThemedSearchInput({
    super.key,

    /// [value] is the value of the search input.
    required this.value,

    /// [onSearch] is the callback function when the search input is changed.
    required this.onSearch,

    /// [maxWidth] is the maximum width of the search input.
    this.maxWidth = 300,

    /// [labelText] is the label text of the search input.
    this.labelText = 'Search',

    /// [customChild] is the custom widget to be displayed.
    /// Replaces the [ThemedTextInput] widget.
    this.customChild,

    /// [disabled] is the flag to disable the search input.
    /// Defaults to `false`.
    this.disabled = false,

    /// [position] is the position of the search input.
    /// Defaults to [ThemedSearchPosition.auto].
    this.position = ThemedSearchPosition.left,
  });

  @override
  State<ThemedSearchInput> createState() => _ThemedSearchInputState();
}

class _ThemedSearchInputState extends State<ThemedSearchInput> with TickerProviderStateMixin {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  late AnimationController animation;
  OverlayEntry? overlay;
  final GlobalKey _key = GlobalKey();
  bool isHovering = false;

  double get height => 40;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: kHoverDuration);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customChild != null) {
      return InkWell(
        onTap: widget.disabled ? null : _handleTap,
        child: widget.customChild,
      );
    }

    return Container(
      width: height,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: _key,
          onTap: _handleTap,
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: Icon(
              MdiIcons.magnify,
              size: 15,
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    if (overlay == null) {
      _buildOverlay();
    } else {
      _destroyOverlay();
    }
  }

  _PredictedPosition _predictPosition({
    required Offset offset,
    required Size size,
    required double screenWidth,
    required double maxWidth,
    ThemedSearchPosition? overridePosition,
  }) {
    ThemedSearchPosition position = overridePosition ?? widget.position;

    double left = 0;
    double right = 0;

    if (position == ThemedSearchPosition.right) {
      left = offset.dx;
      right = screenWidth - (left + maxWidth);

      if (right < 10) {
        right = 10;
      }
    } else {
      right = screenWidth - (offset.dx + size.width);
      left = screenWidth - (right + maxWidth);

      if (left < 10) {
        left = 10;
      }
    }

    return _PredictedPosition(
      left: left,
      right: right,
    );
  }

  void _buildOverlay() {
    RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero);
    double screenWidth = MediaQuery.of(context).size.width;

    _PredictedPosition position = _predictPosition(
      offset: offset,
      size: box.size,
      screenWidth: screenWidth,
      maxWidth: widget.maxWidth,
    );

    double left = position.left;
    double right = position.right;

    overlay = OverlayEntry(
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            _destroyOverlay();
            return false;
          },
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned.fill(child: GestureDetector(onTap: _destroyOverlay)),
                Positioned(
                  top: offset.dy,
                  left: left,
                  right: right,
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: Tween<double>(begin: 0, end: 1).animate(animation),
                        alignment:
                            widget.position == ThemedSearchPosition.left ? Alignment.centerRight : Alignment.centerLeft,
                        child: Actions(
                          actions: {
                            DismissIntent: CallbackAction<DismissIntent>(
                              onInvoke: (DismissIntent intent) {
                                _destroyOverlay();
                                return null;
                              },
                            ),
                          },
                          child: Container(
                            height: height,
                            decoration: generateContainerElevation(context: context),
                            child: RawKeyboardListener(
                              focusNode: FocusNode(),
                              onKey: (ev) {
                                if (ev.logicalKey == LogicalKeyboardKey.escape) {
                                  _destroyOverlay();
                                }
                              },
                              child: TextField(
                                onChanged: widget.onSearch,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: widget.labelText,
                                  labelStyle: Theme.of(context).textTheme.labelSmall,
                                  prefixIcon: Icon(MdiIcons.magnify),
                                  filled: true,
                                  isDense: true,
                                ),
                                onSubmitted: (value) {
                                  widget.onSearch.call(value);
                                  _destroyOverlay();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(overlay!);
    animation.forward();
  }

  void _destroyOverlay() async {
    await animation.reverse();
    overlay?.remove();
    overlay = null;
  }
}

/// [ThemedSearchPosition] is the position of the search input.
/// Basically means the position of the search input when is active.
enum ThemedSearchPosition {
  /// [ThemedSearchPosition.left] is the position of the search input on the left, will spawn to the left.
  left,

  /// [ThemedSearchPosition.right] is the position of the search input on the right, will spawn to the right.
  right,
}

class _PredictedPosition {
  final double left;
  final double right;

  const _PredictedPosition({
    required this.left,
    required this.right,
  });

  @override
  String toString() {
    return '_PredictedPosition{left: $left, right: $right}';
  }
}
