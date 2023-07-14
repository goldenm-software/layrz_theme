part of layout;

class ThemedNotificationIcon extends StatefulWidget {
  final List<ThemedNotificationItem> notifications;
  final Color backgroundColor;
  final bool inAppBar;
  final bool forceFullSize;

  const ThemedNotificationIcon({
    super.key,

    /// [notifications] is the list of notifications to be displayed in the
    /// notification icon.
    required this.notifications,

    /// [backgroundColor] is the background color of the notification icon.
    required this.backgroundColor,

    /// [inAppBar] is a boolean that indicates whether the notification icon is
    /// in the app bar or not.
    this.inAppBar = false,

    /// [forceFullSize] is a boolean that forces the notification icon to be
    /// displayed in full size.
    this.forceFullSize = false,
  });

  @override
  State<ThemedNotificationIcon> createState() => _ThemedNotificationIconState();
}

class _ThemedNotificationIconState extends State<ThemedNotificationIcon> with SingleTickerProviderStateMixin {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get backgroundColor => widget.backgroundColor;
  List<ThemedNotificationItem> get notifications => widget.notifications;

  Color get notificationIconColor => isDark
      ? Colors.white.withOpacity(notifications.isEmpty ? 0.5 : 1)
      : Colors.black.withOpacity(notifications.isEmpty ? 0.5 : 1);

  IconData get notificationIcon => notifications.isNotEmpty ? MdiIcons.bellBadge : MdiIcons.bell;

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
        key: _key,
        onTap: _buildOverlay,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            notificationIcon,
            color: notificationIconColor,
            size: 18,
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
    double right = screenSize.width - offset.dx - renderBox.size.width + padding.right;
    double? top;
    double? left;

    if (widget.inAppBar) {
      top = offset.dy + renderBox.size.height + padding.top + 10;
      bottom = null;
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
                    alignment: widget.inAppBar ? Alignment.topRight : Alignment.bottomRight,
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
                              itemExtent: 56,
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                ThemedNotificationItem item = notifications[index];

                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: item.onTap != null
                                        ? () {
                                            _destroyOverlay(callback: item.onTap);
                                          }
                                        : null,
                                    child: Container(
                                      height: 56,
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
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.title,
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                              ),
                                              Text(item.content, style: Theme.of(context).textTheme.bodySmall),
                                            ],
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
