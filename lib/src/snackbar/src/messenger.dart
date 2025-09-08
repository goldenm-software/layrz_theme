part of '../snackbar.dart';

typedef ThemedSnackbarCallback = bool Function();

class ThemedSnackbarMessenger extends StatefulWidget {
  /// [child] is the widget that will be wrapped by the snackbar messenger.
  /// It is required to use the `ThemedSnackbarMessenger.of(context)` method.
  final Widget child;

  /// [maxWidth] is the maximum width of the snackbar.
  final double maxWidth;

  /// [mobileBreakpoint] is the breakpoint for mobile devices.
  /// It is used to determine if the snackbar should be displayed on the bottom of the screen
  final double mobileBreakpoint;

  /// defaults to `true` when `true` and [mobileBreakpoint] is reached, the snackbar will consider the `MediaQuery.viewInsetsOf(context).bottom` property to consider the virtual keyboard height when showing the snackbar on Android and iOS devices.
  ///
  final bool useViewInsetsBottom;

  /// [ThemedSnackbarMessenger] is a widget that provides a way to show snackbars
  /// using the Layrz Design styling.
  ///
  /// The stack of snackbars will be displayed on the top right of the screen on desktop and tablet devices, growing
  /// from the top to the bottom.
  ///
  /// For mobile devices, the snackbars will be displayed on the bottom of the screen and growing from the bottom
  /// to the top.
  const ThemedSnackbarMessenger({
    super.key,
    required this.child,
    this.maxWidth = 400,
    this.mobileBreakpoint = kSmallGrid,
    this.useViewInsetsBottom = true,
  });

  @override
  State<ThemedSnackbarMessenger> createState() => ThemedSnackbarMessengerState();

  static ThemedSnackbarMessengerState of(BuildContext context) {
    assert(debugCheckHasThemedSnackbarMessenger(context));
    final _ThemedSnackbarScope? scope = context.findAncestorWidgetOfExactType<_ThemedSnackbarScope>();
    return scope!.state;
  }

  static ThemedSnackbarMessengerState? maybeOf(BuildContext context) {
    final _ThemedSnackbarScope? scope = context.findAncestorWidgetOfExactType<_ThemedSnackbarScope>();
    return scope?.state;
  }
}

class ThemedSnackbarMessengerState extends State<ThemedSnackbarMessenger>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  /// [_screenSize] is the size of the screen.
  /// It is used to calculate the position of the snackbars.
  ///
  /// This value is calculated initially on the `initState` method and updated by
  /// the `didChangeMetrics` method.
  late Size _screenSize;

  /// [_viewPadding] is the padding of the screen.
  /// This value is used to calculate the position of the snackbars.
  ///
  /// It is calculated initially on the `initState` method and updated by
  /// the `didChangeMetrics` method.
  late EdgeInsets _viewPadding;

  /// [_ready] is a flag to indicate if the messenger is ready to show snackbars.
  ///
  /// This value will be true after the first build and when the screen size is available.
  bool _ready = false;

  /// [visibleSnackbars] is a list of snackbars that are currently visible.
  final List<ThemedSnackbar> snackbars = [];

  /// [showSnackbar] is called to show a snackbar.
  ///
  /// To use it, call `ThemedSnackbarMessenger.of(context).showSnackbar(snackbar)`.
  /// Also, you need to set this in your `MaterialApp`:`
  /// ```dart
  /// MaterialApp(
  ///   ...
  ///   builder: (context, child) {
  ///     return ThemedSnackbarMessenger(
  ///       child: child ?? const SizedBox(),
  ///     );
  ///   },
  /// );
  /// ```
  /// Without the builder, you cannot invoke `ThemedSnackbarMessenger.of(context)`.
  void showSnackbar(ThemedSnackbar snackbar) {
    snackbars.add(snackbar);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});

      _resetControllers();
    });
  }

  /// [show] is an alias of [showSnackbar].
  void show(ThemedSnackbar snackbar) => showSnackbar(snackbar);

  /// [_width] is the width of the snackbar.
  /// It is calculated based on the screen size and the maximum width.
  double get _width {
    double width = _screenSize.width * 0.7;
    if (width > widget.maxWidth) width = widget.maxWidth;

    if (ThemedPlatform.isAndroid || ThemedPlatform.isIOS || _screenSize.width < widget.mobileBreakpoint) {
      if (MediaQuery.orientationOf(context) == Orientation.portrait) {
        width = _screenSize.width - _viewPadding.horizontal;
        width -= 30; // Left and right
      }
    }

    return width;
  }

  /// [_height] is the height of the snackbar. computed based on the message text.
  double _height = 0;

  /// [_resetControllers] is used to reset the animation controllers.
  /// It stops the current animations, resets them, and calculates the new height based on the current snackbar.
  void _resetControllers({bool clearAll = false}) {
    _timerController.stop();
    _fadeController.stop();
    _timerController.reset();
    _fadeController.reset();

    if (clearAll) {
      snackbars.clear();
      setState(() {});
      return;
    }

    final snackbar = snackbars.firstOrNull;
    if (snackbar == null) return;

    _timerController.duration = snackbar.duration;
    _fadeController.duration = const Duration(milliseconds: 150);

    double effectiveWidth = _width;
    effectiveWidth -= 30; // Icon of the left
    effectiveWidth -= 10; // Spacer

    effectiveWidth -= 30; // Close icon on the right
    effectiveWidth -= 10; // Spacer

    effectiveWidth -= 30; // Padding

    TextPainter messagePainter = TextPainter(
      text: TextSpan(
        text: snackbar.message,
        style: _messageStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: effectiveWidth);

    double effectiveHeight = 0.0;
    for (final line in messagePainter.computeLineMetrics()) {
      effectiveHeight += line.height;
    }

    if (snackbar.title != null) {
      TextPainter titlePainter = TextPainter(
        text: TextSpan(
          text: snackbar.title,
          style: _titleStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: effectiveWidth);

      for (final line in titlePainter.computeLineMetrics()) {
        effectiveHeight += line.height;
      }
    }
    // computedHeight + 10;
    _height = max(effectiveHeight, 30 + 10);

    _fadeController.forward(from: 0.0);
  }

  /// [_timerController] is used to control the animation of the snackbar.
  late AnimationController _timerController;

  /// [_fadeController] is used to control the fade animation of the snackbar.
  late AnimationController _fadeController;

  /// [_totalSnackbars] is the total number of snackbars that are stacked
  int get _totalSnackbars => snackbars.length;

  /// [_currentSnackbar] is the current snackbar that is being displayed.
  ThemedSnackbar? get _currentSnackbar => snackbars.firstOrNull;

  /// [_backgroundColor] is the background color of the snackbar.
  Color get _backgroundColor => _currentSnackbar?.color ?? Colors.blue;

  /// [_titleStyle] helps to build the title style
  /// It uses the current theme to build the style
  TextStyle? get _titleStyle => Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold);

  /// [_messageStyle] helps to build the message style
  /// It uses the current theme to build the style
  TextStyle? get _messageStyle => Theme.of(context).textTheme.bodyMedium;

  /// [_hoveringClose] is used to determine if the close icon is being hovered.
  bool _hoveringClose = false;

  bool get _isMobile => _screenSize.width < widget.mobileBreakpoint;

  late EdgeInsets _viewInsets;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(vsync: this);
    _timerController.addStatusListener(_timerStatusListener);

    _fadeController = AnimationController(vsync: this);
    _fadeController.addStatusListener(_fadeStatusListener);

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenSize = MediaQuery.sizeOf(context);
      _viewPadding = MediaQuery.viewPaddingOf(context);
      _ready = true;
      setState(() {});
    });
  }

  void _timerStatusListener(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      await _fadeController.reverse();
      await Future.delayed(const Duration(milliseconds: 100));
      // Remove the snackbar from the list and rebuild the widget
      if (snackbars.isNotEmpty) snackbars.removeAt(0);
      setState(() {});

      // Reset the controllers for the next snackbar
      _resetControllers();
    }
  }

  void _fadeStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _timerController.forward(from: 0.0);
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _screenSize = MediaQuery.sizeOf(context);
      _viewPadding = MediaQuery.viewPaddingOf(context);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timerController.stop();
    _timerController.removeStatusListener(_timerStatusListener);
    _timerController.dispose();

    _fadeController.stop();
    _fadeController.removeStatusListener(_fadeStatusListener);
    _fadeController.dispose();
    snackbars.clear();
    _ready = false;
    _screenSize = Size.zero;
    _viewPadding = EdgeInsets.zero;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // To consider the virtual keyboard height when showing the snackbar on mobile devices
    _viewInsets = MediaQuery.viewInsetsOf(context);
    double viewInsetsBottom = 0;
    if (widget.useViewInsetsBottom) {
      viewInsetsBottom = _viewInsets.bottom;
    }
    return _ThemedSnackbarScope(
      state: this,
      child: Stack(
        children: [
          widget.child,
          if (_ready) ...[
            if (_currentSnackbar != null) ...[
              Positioned(
                top: _isMobile ? null : 15 + _viewPadding.top,
                right: _isMobile ? 15 + _viewPadding.right : 15 + _viewPadding.right,
                bottom: _isMobile ? 15 + _viewPadding.bottom + viewInsetsBottom : null,
                left: _isMobile ? 15 + _viewPadding.left : null,
                width: _isMobile ? null : _width,
                height: _height + 20,
                child: Material(
                  color: Colors.transparent,
                  child: MouseRegion(
                    onEnter: (_) => _timerController.stop(),
                    onExit: (_) => _timerController.forward(),
                    child: FadeTransition(
                      opacity: _fadeController,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha((255 * 0.1).toInt()),
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: AnimatedBuilder(
                                animation: _timerController,
                                builder: (context, child) {
                                  return LinearProgressIndicator(
                                    value:
                                        (_currentSnackbar!.duration.inMilliseconds * _timerController.value) /
                                        _currentSnackbar!.duration.inMilliseconds,
                                    backgroundColor: validateColor(color: _backgroundColor).withValues(alpha: 0.5),
                                    color: validateColor(color: _backgroundColor),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 5,
                              left: 5,
                              right: 5,
                              bottom: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _backgroundColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      _currentSnackbar!.icon ?? LayrzIcons.solarOutlineInfoCircle,
                                      color: validateColor(color: _backgroundColor),
                                      size: 30,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (_currentSnackbar!.title != null) ...[
                                            Text(
                                              _currentSnackbar!.title!,
                                              style: _titleStyle?.copyWith(
                                                color: validateColor(color: _backgroundColor),
                                              ),
                                              textAlign: TextAlign.justify,

                                              overflow: TextOverflow.visible,
                                            ),
                                          ],
                                          Text(
                                            _currentSnackbar!.message,
                                            style: _messageStyle?.copyWith(
                                              color: validateColor(color: _backgroundColor).withValues(
                                                alpha: _currentSnackbar!.title == null ? 1 : 0.8,
                                              ),
                                            ),
                                            textAlign: TextAlign.justify,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () {
                                          snackbars.removeAt(0);
                                          setState(() {});

                                          _resetControllers();
                                        },
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: Icon(
                                            LayrzIcons.solarOutlineCloseCircle,
                                            color: validateColor(color: _backgroundColor),
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              if (_totalSnackbars > 1) ...[
                Positioned(
                  top: _isMobile ? null : 10 + _viewPadding.top,
                  right: _isMobile ? 10 + _viewPadding.right : 10 + _viewPadding.right,
                  bottom: _isMobile ? 10 + _viewPadding.bottom + _height + viewInsetsBottom : null,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onHover: (value) => setState(() => _hoveringClose = value),
                          onTap: () => _resetControllers(clearAll: true),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: Center(
                              child: _hoveringClose
                                  ? Icon(
                                      LayrzIcons.mdiClose,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : Text(
                                      _totalSnackbars > 9 ? '+9' : _totalSnackbars.toString(),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ],
      ),
    );
  }
}

class _ThemedSnackbarScope extends InheritedWidget {
  final ThemedSnackbarMessengerState state;

  const _ThemedSnackbarScope({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ThemedSnackbarScope old) => true;
}
