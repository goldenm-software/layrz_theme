part of '../snackbar.dart';

class ThemedSnackbar extends StatefulWidget {
  /// [title] helps to build the title widget. If null, the title will not be displayed
  final String? title;

  /// [message] helps to build the message widget.
  final String message;

  /// [icon] helps to build the icon widget. If null, the icon will not be displayed
  final IconData? icon;

  /// [color] helps to build the background color of the snackbar
  final Color? color;

  /// [duration] helps to build the duration of the snackbar
  final Duration duration;

  /// [width] helps to build the width of the snackbar
  final double? width;

  /// [maxLines] helps to build the max lines of the message
  final int maxLines;

  /// [isDismissible] helps to build the dismissible behavior of the snackbar
  /// If true, the snackbar will render a close icon on the top right
  final bool isDismissible;

  /// [ThemedSnackbar] helps to build a snackbar with the current theme.
  /// It will be displayed on the top right of the screen and has the ability to stack multiple snackbars.
  ThemedSnackbar({
    Key? key,
    this.title,
    required this.message,
    this.icon,
    this.color,
    this.duration = const Duration(seconds: 3),
    this.width,
    this.maxLines = 2,
    this.isDismissible = true,
  })  : assert(message.isNotEmpty, 'Message must not be empty'),
        assert(duration.inSeconds > 0, 'Duration must be greater than 0 seconds'),
        super(key: key ?? UniqueKey());

  late final ThemedSnackbarMessengerState state;

  @override
  State<ThemedSnackbar> createState() => _ThemedSnackbarState();
}

class _ThemedSnackbarState extends State<ThemedSnackbar> with TickerProviderStateMixin {
  /// [width] is the width of the snackbar
  /// Uses the a prediction of the width of the snackbar
  /// based on the text length and the max lines
  /// But, if [widget.width] is not null, it will be used instead
  double get width {
    if (widget.width != null) return widget.width!;

    double screenWidth = MediaQuery.of(context).size.width;

    return min(screenWidth * 0.8, 400);
  }

  /// [defaultPosition] defines the default top and right position of the snackbar
  double get defaultPosition => 10;

  /// [top] refers to the position in the screen, that position depends of the number of snackbars
  /// that are currently visible
  double top(List<Map<String, dynamic>> heights) {
    EdgeInsets padding = MediaQuery.of(context).padding;
    double top = defaultPosition;

    for (final entry in heights) {
      final height = entry['height'] as double;
      final index = entry['key'] as Key;

      if (index == widget.key) break;
      top += height + spacing;
    }

    return padding.top + top;
  }

  /// [titleStyle] helps to build the title style
  /// It uses the current theme to build the style
  TextStyle? get titleStyle => Theme.of(context).textTheme.bodyMedium;

  /// [messageStyle] helps to build the message style
  /// It uses the current theme to build the style
  TextStyle? get messageStyle => Theme.of(context).textTheme.bodySmall;

  /// [effectiveWidth] is the exact space available for the text to render
  /// It is used to predict the size of the text
  double get effectiveWidth {
    double effectiveWidth = width;

    if (widget.icon != null) {
      effectiveWidth -= iconSize + elementsSpacing;
    }

    if (widget.isDismissible) {
      effectiveWidth -= 35 + elementsSpacing;
    }

    effectiveWidth -= padding.horizontal;

    return effectiveWidth;
  }

  /// [predictedTitleSize] predicts the size of the title based on the text length and the max lines
  /// It is used to predict the height of the snackbar
  Size get predictedTitleSize {
    if (widget.title == null) return Size.zero;

    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.title,
        style: titleStyle,
      ),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: effectiveWidth);

    return textPainter.size;
  }

  /// [iconSize] helps to build the size of the icon
  double get iconSize => 20;

  /// [predictedMessageSize] predicts the size of the message based on the text length and the max lines
  /// It is used to predict the height of the snackbar
  /// It uses the current theme to build the style
  Size get predictedMessageSize {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.message,
        style: messageStyle,
      ),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: effectiveWidth);

    return textPainter.size;
  }

  /// [elementsSpacing] helps to build the spacing between the elements of the snackbar
  double get elementsSpacing => 5;

  /// [backgroundColor] helps to build the background color of the snackbar
  /// In case the color is null, will use the primary color of the current theme
  Color get backgroundColor => widget.color ?? Theme.of(context).primaryColor;

  /// [spacing] helps to build the spacing between snackbars
  double get spacing => 5;

  /// [padding] helps to build the padding of the snackbar
  /// It uses the current theme to build the style
  EdgeInsets get padding => const EdgeInsets.symmetric(horizontal: 10, vertical: 5);

  /// [height] predicts the height of the snackbar based on the text length and the max lines
  double get height {
    double effectiveHeight = predictedTitleSize.height + predictedMessageSize.height;
    effectiveHeight = max(effectiveHeight, ThemedButton.height);
    effectiveHeight += padding.vertical;
    effectiveHeight += elementsSpacing;
    effectiveHeight += progressHeight;

    return effectiveHeight;
  }

  /// [_timer] is the timer that will be used to remove the snackbar
  /// after the duration is reached
  late Timer _timer;

  /// [_animationController] is the animation controller that will be used to animate the snackbar
  /// when it is shown and when it is removed
  late AnimationController _animationController;

  /// [progressHeight] is the height to be used to fix the height in the progress bar
  double get progressHeight => 5;

  /// [completeDuration] is the complete duration of the snackbar, this
  /// includes the duration itself and the animation duration
  Duration get completeDuration => widget.duration + kSnackbarAnimationDuration;

  /// [completeDurationMs] is the complete duration of the snackbar in milliseconds
  double get completeDurationMs => completeDuration.inMilliseconds.toDouble();

  @override
  void initState() {
    super.initState();
    // Creates the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: kSnackbarAnimationDuration,
    );

    // Wait for the first frame to be displayed before showing the snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Register in the messenger the used heights of the snackbar
      widget.state.registerHeight(widget.key!, height);

      // Start the animation
      await _animationController.forward();

      // When the animation is finished, start the timer
      _timer = Timer(widget.duration, () async {
        // Reverse the animation and wait for it to finish
        await _animationController.reverse();

        // Remove the snackbar from the messenger
        widget.state.removeSnackbar(widget.key!);
      });

      widget.state.registerListener(widget.key!, () {
        if (mounted) setState(() {});

        return mounted;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: kHoverDuration,
      top: top(widget.state.heights),
      right: defaultPosition,
      child: TweenAnimationBuilder(
        duration: widget.duration,
        tween: Tween<double>(begin: 0, end: completeDurationMs),
        builder: (context, value, child) {
          // Default opacity
          double opacity = 1;

          if (value < 200) {
            opacity = value / 200;
          } else if (value > completeDurationMs - 200) {
            opacity = (completeDurationMs - value) / 200;
          }

          return Opacity(
            opacity: opacity,
            child: child,
          );
        },
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.only(bottom: spacing),
          decoration: generateContainerElevation(
            context: context,
            color: backgroundColor,
            shadowColor: backgroundColor,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: padding,
                  child: Row(
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: validateColor(color: backgroundColor),
                          size: iconSize,
                        ),
                        SizedBox(width: elementsSpacing),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.title != null) ...[
                              Text(
                                widget.title!,
                                style: titleStyle?.copyWith(
                                  color: validateColor(color: backgroundColor),
                                ),
                                maxLines: widget.maxLines,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            Text(
                              widget.message,
                              style: messageStyle?.copyWith(
                                color: validateColor(color: backgroundColor).withOpacity(
                                  widget.title == null ? 1 : 0.8,
                                ),
                              ),
                              maxLines: widget.maxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (widget.isDismissible) ...[
                        SizedBox(width: elementsSpacing),
                        ThemedButton(
                          style: ThemedButtonStyle.fab,
                          tooltipEnabled: false,
                          labelText: 'Close',
                          icon: MdiIcons.close,
                          color: validateColor(color: backgroundColor),
                          onTap: () {
                            _timer.cancel();
                            widget.state.removeSnackbar(widget.key!);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(height: elementsSpacing),
              TweenAnimationBuilder(
                duration: widget.duration,
                tween: Tween<double>(begin: 0, end: widget.duration.inMilliseconds.toDouble()),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    minHeight: progressHeight,
                    value: value / widget.duration.inMilliseconds,
                    color: validateColor(color: backgroundColor),
                    backgroundColor: validateColor(color: backgroundColor).withOpacity(0.5),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
