// ignore_for_file: use_build_context_synchronously

part of '../../layout.dart';

class ThemedCustomNotificationLocation {
  /// [top] is the top position of the notification icon.
  final double? top;

  /// [bottom] is the bottom position of the notification icon.
  final double? bottom;

  /// [left] is the left position of the notification icon.
  final double? left;

  /// [right] is the right position of the notification icon.
  final double? right;

  /// [width] is the width of the notification icon.
  final double width;

  /// [alignment] is the alignment of the notification icon.
  final Alignment alignment;

  /// [ThemedCustomNotificationLocation] defines the exact location and width of the notification tray.
  const ThemedCustomNotificationLocation({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.width,
    required this.alignment,
  });
}

/// [ThemedNotificationLocation] defeines the location of the notification.
enum ThemedNotificationLocation {
  /// [ThemedNotificationLocation.appBar] defines the notification location in the app bar.
  ///
  /// Layout mode: [ThemedLayoutStyle.dual]
  /// Mobile layout mode: [ThemedLayoutStyle.appBar]
  appBar,

  /// [ThemedNotificationLocation.miniBar] defines the notification location in the mini bar.
  ///
  /// Layout mode: [ThemedLayoutStyle.mini]
  /// Mobile layout mode: `null`
  miniBar,

  /// [ThemedNotificationLocation.bottomBar] defines the notification location in the bottom bar.
  ///
  /// Layout mode: `null`
  /// Mobile layout mode: [ThemedLayoutStyle.bottomBar]
  bottomBar,

  /// [ThemedNotificationLocation.sideBar] defines the notification location in the side bar.
  ///
  /// Layout mode: [ThemedLayoutStyle.sidebar]
  /// Mobile layout mode: `null`
  sideBar,

  /// [ThemedNotificationLocation.custom]
  ///
  /// Using this mode, you can provide the exact location using `ThemedCustomNotificationLocation` to
  /// move the notification icon to the desired location.
  custom,
  ;
}

class ThemedNotificationIcon extends StatefulWidget {
  /// [notifications] is the list of notifications to be displayed in the
  /// notification icon.
  final List<ThemedNotificationItem> notifications;

  /// [backgroundColor] is the background color of the notification icon.
  final Color backgroundColor;

  /// [forceFullSize] is a boolean that forces the notification icon to be
  /// displayed in full size.
  final bool forceFullSize;

  /// [expandToLeft] is a boolean that indicates whether the notification icon
  /// should expand to the left or not.
  final bool expandToLeft;

  /// [dense] is a boolean that indicates whether the notification icon should
  /// be displayed in a dense mode or not.
  final bool dense;

  /// [icon] is the icon of the notification icon.
  final IconData? icon;

  /// [child] is the child of the notification icon.
  final Widget? child;

  /// [badgeColor] is the color of the badge.
  final Color? badgeColor;

  /// [badgeLabelBuilder] is the builder of the badge label.
  /// Receives the number of notifications as a parameter.
  /// and returns a widget.
  final Widget? Function(int)? badgeLabelBuilder;

  /// [location] is the location of the notification icon.
  final ThemedNotificationLocation location;

  /// [customLocation] is the custom location of the notification icon.
  final ThemedCustomNotificationLocation? customLocation;

  /// Creates a [ThemedNotificationIcon] widget.
  const ThemedNotificationIcon({
    super.key,
    required this.notifications,
    required this.backgroundColor,
    this.forceFullSize = false,
    this.expandToLeft = false,
    this.dense = false,
    this.icon,
    this.child,
    this.badgeColor,
    this.badgeLabelBuilder,
    required this.location,
    this.customLocation,
  }) : assert(location != ThemedNotificationLocation.custom || customLocation != null);

  @override
  State<ThemedNotificationIcon> createState() => _ThemedNotificationIconState();
}

class _ThemedNotificationIconState extends State<ThemedNotificationIcon> with SingleTickerProviderStateMixin {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get backgroundColor => widget.backgroundColor;
  List<ThemedNotificationItem> get notifications => widget.notifications;

  Color get notificationIconColor => validateColor(color: backgroundColor).withOpacity(notifications.isEmpty ? 0.5 : 1);

  late AnimationController _controller;
  OverlayEntry? _overlay;
  final GlobalKey _key = GlobalKey();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: kHoverDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        hoverColor: validateColor(color: backgroundColor).withOpacity(0.1),
        key: _key,
        onTap: _buildOverlay,
        child: Padding(
          padding: EdgeInsets.all(widget.dense ? 5 : 10),
          child: Badge(
            isLabelVisible: notifications.isNotEmpty,
            backgroundColor: widget.badgeColor ?? Colors.orange,
            label: widget.badgeLabelBuilder?.call(notifications.length),
            offset: const Offset(10, -12),
            smallSize: 10,
            largeSize: 10,
            child: widget.child ??
                Icon(
                  widget.icon ?? LayrzIcons.solarOutlineBellBing,
                  color: notificationIconColor,
                  size: widget.dense ? 15 : 18,
                ),
          ),
        ),
      ),
    );
  }

  Future<void> _buildOverlay() async {
    if (_overlay != null) {
      await _destroyOverlay();
    }

    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size screenSize = MediaQuery.of(context).size;
    EdgeInsets padding = MediaQuery.of(context).padding;
    Size iconSize = renderBox.size;

    double? bottom;
    double? right;
    double? top;
    double? left;
    double? width;
    late Alignment alignment;

    switch (widget.location) {
      case ThemedNotificationLocation.custom:
        top = widget.customLocation!.top;
        bottom = widget.customLocation!.bottom;
        left = widget.customLocation!.left;
        right = widget.customLocation!.right;
        width = widget.customLocation!.width;
        alignment = Alignment.topLeft;
        break;
      case ThemedNotificationLocation.appBar:
        alignment = Alignment.topRight;
        top = padding.top + iconSize.width + offset.dy + 10;
        right = (screenSize.width - offset.dx - iconSize.width - padding.right);
        width = screenSize.width * 0.5;
        if (width > 400) width = 400;
        if (widget.forceFullSize) {
          left = padding.left + 10;
          right = padding.right + 10;
          width = null;
        }
        break;
      case ThemedNotificationLocation.miniBar:
        alignment = Alignment.bottomLeft;
        left = padding.left + iconSize.width + offset.dx + 10;
        bottom = padding.bottom + 10;

        width = screenSize.width * 0.5;
        if (width > 400) width = 400;
        break;
      case ThemedNotificationLocation.bottomBar:
        alignment = Alignment.bottomRight;
        bottom = 20 + iconSize.height + padding.bottom;
        right = 10 + padding.right;
        width = screenSize.width * 0.5;
        if (width > 400) width = 400;
        if (widget.forceFullSize) {
          left = padding.left + 10;
          right = padding.right + 10;
          width = null;
        }
        break;
      case ThemedNotificationLocation.sideBar:
        alignment = Alignment.topLeft;
        top = padding.top + iconSize.width + offset.dy + 10;
        left = padding.left + iconSize.width + offset.dx + 10;
        width = screenSize.width * 0.5;
        if (width > 400) width = 400;
        break;
      default:
        return;
    }

    _overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(child: GestureDetector(onTap: _destroyOverlay)),
              Positioned(
                top: top,
                bottom: bottom,
                left: left,
                right: right,
                child: KeyboardListener(
                  focusNode: _focusNode,
                  onKeyEvent: (event) {
                    if (event.logicalKey == LogicalKeyboardKey.escape) {
                      _destroyOverlay();
                    }
                  },
                  child: ScaleTransition(
                    scale: _controller,
                    alignment: alignment,
                    child: Container(
                      width: width == null ? null : width - 50,
                      constraints: BoxConstraints(
                        maxHeight: screenSize.height * 0.4,
                        minHeight: 56,
                        maxWidth: 400,
                      ),
                      decoration: generateContainerElevation(
                        context: context,
                        elevation: 3,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: notifications.isEmpty
                          ? SizedBox(
                              height: 56,
                              child: Center(
                                child: Text(i18n?.t('layrz.notifications.empty') ?? 'No notifications'),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              padding: kListViewPadding,
                              itemExtent: 75,
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                ThemedNotificationItem item = notifications[index];
                                DateTime at = item.at ?? DateTime.now();

                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: item.onTap != null
                                        ? () {
                                            _destroyOverlay(callback: item.onTap);
                                          }
                                        : null,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ThemedAvatar(
                                            icon: item.icon ?? LayrzIcons.solarOutlineBellBing,
                                            color: item.color ?? Theme.of(context).primaryColor,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.title,
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                ),
                                                Text(
                                                  item.content,
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        fontSize: 13,
                                                      ),
                                                  textAlign: TextAlign.justify,
                                                  maxLines: 2,
                                                ),
                                                Text(
                                                  at.format(pattern: '%I:%M %p'),
                                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: validateColor(
                                                          color: Theme.of(context).scaffoldBackgroundColor,
                                                        ).withOpacity(0.5),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlay!);
    await _controller.forward();
    _focusNode.requestFocus();
  }

  Future<void> _destroyOverlay({VoidCallback? callback}) async {
    _focusNode.unfocus();
    await _controller.reverse();
    _overlay?.remove();
    _overlay = null;

    callback?.call();
  }
}
