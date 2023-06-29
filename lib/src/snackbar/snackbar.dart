part of layrz_theme;

class ThemedSnackbar {
  final BuildContext context;
  final String? title;
  final String message;
  final IconData? icon;
  final Color? color;
  final Duration duration;
  final double? width;
  final int maxLines;

  /// [ThemedSnackbar] helps to build a snackbar with the current theme.
  /// It will be displayed on the top right of the screen and has the ability to stack multiple snackbars.
  ThemedSnackbar({
    /// [context] helps to get the current theme and the screen size
    required this.context,

    /// [title] helps to build the title widget. If null, the title will not be displayed
    this.title,

    /// [message] helps to build the message widget.
    required this.message,

    /// [icon] helps to build the icon widget. If null, the icon will not be displayed
    this.icon,

    /// [color] helps to build the background color of the snackbar
    this.color,

    /// [duration] helps to build the duration of the snackbar
    this.duration = const Duration(seconds: 3),

    /// [width] helps to build the width of the snackbar
    this.width,

    /// [maxLines] helps to build the max lines of the message
    this.maxLines = 2,
  })  : assert(message.isNotEmpty, 'Message must not be empty'),
        assert(duration.inSeconds > 0, 'Duration must be greater than 0 seconds');

  OverlayEntry? _entry;

  /// [key] helps to identify the snackbar
  Key? key;

  /// [padding] helps to calculate the padding of the snackbar
  EdgeInsets get padding => const EdgeInsets.all(10);

  /// [backgroundColor] helps to calculate the background color of the snackbar
  /// if [color] is not null, it will be used as the background color
  /// otherwise, it will be calculated based on the theme primary color.
  Color get backgroundColor => color ?? Theme.of(context).primaryColor;

  /// [spacing] helps to calculate the spacing between snackbars
  double get spacing => 10;

  /// [effectiveWidth] helps to calculate the width of the snackbar
  /// if [width] is not null, it will be used as the width
  /// otherwise, it will be calculated based on the screen width.
  ///
  /// When the calculated width is less than `500u`, the width will be `80%` of the screen width
  /// otherwise, the width will be `500u`.
  ///
  /// When [width] is not null, and is greater than the screen width, will be apply the same rule as above.
  double get effectiveWidth {
    double screenWidth = MediaQuery.of(context).size.width;

    if (width != null) {
      if (width! > screenWidth) {
        return screenWidth * 0.8;
      }

      return width!;
    }

    if (screenWidth < 500) {
      return screenWidth * 0.8;
    }

    return 500;
  }

  /// [effectiveHeight] helps to calculate the height of the snackbar
  /// it will be calculated based on the title and message height
  /// and the padding.
  double get effectiveHeight {
    double height = padding.vertical;

    if (title != null) {
      Size titleSize = _textSize(titleWidget);
      height += titleSize.height;
    }

    Size messageSize = _textSize(messageWidget);
    height += messageSize.height;

    height += 5; // Bottom loading indicator

    return height;
  }

  /// [titleWidget] helps to build the title widget
  Text get titleWidget => Text(
        title ?? '',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: validateColor(color: backgroundColor),
            ),
      );

  /// [messageWidget] helps to build the message widget
  Text get messageWidget => Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: validateColor(color: backgroundColor).withOpacity(title != null ? 0.8 : 1),
            ),
        maxLines: maxLines,
        textAlign: TextAlign.justify,
      );

  /// [_top] helps to calculate the top position of the snackbar
  /// it will be calculated based on the previous snackbars height
  double _top(ThemedSnackbarController controller) {
    double top = MediaQuery.of(context).padding.top;

    for (ThemedSnackbar snackbar in controller._snackbars.values) {
      if (snackbar.key == key) {
        break;
      }

      top += snackbar.effectiveHeight + spacing;
    }

    return top;
  }

  /// [show] helps to show the snackbar
  /// it will be called by the [ThemedSnackbarController]
  /// and will be added to the [Overlay]
  /// and will be removed after the [duration]
  /// and will be removed when the user tap on the close button
  void show(ThemedSnackbarController controller, Key key) {
    this.key = key;

    Widget snackbar = Padding(
      padding: padding,
      child: Container(
        width: effectiveWidth,
        height: effectiveHeight,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: padding,
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: validateColor(color: backgroundColor),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null) titleWidget,
                        messageWidget,
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        controller.remove(this);
                      },
                      child: Icon(
                        MdiIcons.closeCircle,
                        color: validateColor(color: backgroundColor),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TweenAnimationBuilder(
              duration: duration,
              tween: Tween<double>(begin: 0, end: duration.inMilliseconds.toDouble()),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  minHeight: 5,
                  value: value / duration.inMilliseconds,
                  color: validateColor(color: backgroundColor),
                  backgroundColor: validateColor(color: backgroundColor).withOpacity(0.5),
                );
              },
            ),
          ],
        ),
      ),
    );

    double completeDuration = duration.inMilliseconds.toDouble() + 400;

    Widget animation = TweenAnimationBuilder(
      duration: duration,
      tween: Tween<double>(begin: 0, end: completeDuration),
      builder: (context, value, child) {
        // Default opacity
        double opacity = 1;

        if (value < 200) {
          opacity = value / 200;
        } else if (value > completeDuration - 200) {
          opacity = (completeDuration - value) / 200;
        }

        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: snackbar,
    );

    _entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: _top(controller),
          right: 0,
          child: animation,
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  /// [hide] helps to hide the snackbar
  /// it will be called by the [ThemedSnackbarController]
  /// and will be removed from the [Overlay]
  /// and will be removed when the user tap on the close button
  void hide(ThemedSnackbarController controller) {
    _entry?.remove();
    _entry = null;
  }

  /// [_textSize] helps to calculate the size of the text
  /// it will be used to calculate the height of the snackbar
  Size _textSize(Text widget) {
    double occupedWidth = 30; // Dismiss icon

    if (icon != null) {
      occupedWidth += 30; // Snackbar icon
    }

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: widget.data,
        style: widget.style,
      ),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth: effectiveWidth - occupedWidth,
      );

    return textPainter.size;
  }
}
