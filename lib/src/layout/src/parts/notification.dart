part of '../../layout.dart';

class ThemedNotificationIcon extends StatefulWidget {
  /// [notifications] is the list of notifications to be displayed in the
  /// notification icon.
  final List<ThemedNotificationItem> notifications;

  /// [backgroundColor] is the background color of the notification icon.
  final Color backgroundColor;

  /// [inAppBar] is a boolean that indicates whether the notification icon is
  /// in the app bar or not.
  final bool inAppBar;

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

  /// Creates a [ThemedNotificationIcon] widget.
  const ThemedNotificationIcon({
    super.key,
    required this.notifications,
    required this.backgroundColor,
    this.inAppBar = false,
    this.forceFullSize = false,
    this.expandToLeft = false,
    this.dense = false,
    this.icon,
    this.child,
    this.badgeColor,
    this.badgeLabelBuilder,
  });

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
                  widget.icon ?? MdiIcons.bell,
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
    double? bottom = screenSize.height - offset.dy + padding.bottom + 20;
    double? right = screenSize.width - offset.dx - renderBox.size.width + padding.right;
    double? top;
    double? left;

    if (widget.inAppBar) {
      top = offset.dy + renderBox.size.height + padding.top + 10;
      bottom = null;
    }

    if (widget.expandToLeft) {
      left = offset.dx + renderBox.size.width + padding.left;
      right = null;
      top = offset.dy;
    }

    double? width = screenSize.width * 0.5;

    if (width < 200 || widget.forceFullSize) {
      left = padding.left + 10;
      right = padding.right + 10;
      width = null;
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
                child: RawKeyboardListener(
                  focusNode: _focusNode,
                  onKey: (event) {
                    if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
                      _destroyOverlay();
                    }
                  },
                  child: ScaleTransition(
                    scale: _controller,
                    alignment: widget.inAppBar
                        ? widget.expandToLeft
                            ? Alignment.topLeft
                            : Alignment.topRight
                        : Alignment.bottomRight,
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
                                          drawAvatar(
                                            context: context,
                                            icon: item.icon ?? MdiIcons.bell,
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
