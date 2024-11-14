part of "../../layout.dart";

class ThemedMiniBar extends StatefulWidget {
  /// [items] is the list of buttons to be displayed
  final List<ThemedNavigatorItem> items;

  /// [persistentItems] is the list of buttons to be displayed
  final List<ThemedNavigatorItem> persistentItems;

  /// [enableAbout] is a boolean that enables the about button.
  final bool enableAbout;

  /// [onSettingsTap] is the callback to be executed when the settings button
  final VoidCallback? onSettingsTap;

  /// [onProfileTap] is the callback to be executed when the profile button
  final VoidCallback? onProfileTap;

  /// [onLogoutTap] is the callback to be executed when the logout button
  final VoidCallback? onLogoutTap;

  /// [onThemeSwitchTap] is a callback that is called when the theme switch
  /// button is tapped.
  final VoidCallback? onThemeSwitchTap;

  /// [appTitle] is the title of the app.
  final String appTitle;

  /// [companyName] is the name of the company.
  final String companyName;

  /// [logo] is the logo of the app. Can be a path or a url.
  final AppThemedAsset logo;

  /// [favicon] is the favicon of the app. Can be a path or a url.
  final AppThemedAsset favicon;

  /// [userName] is the name of the user.
  final String userName;

  /// [userAvatar] is the avatar of the user. Can be a path or a url.
  final String? userAvatar;

  /// [userDynamicAvatar] is the dynamic avatar of the user.
  final Avatar? userDynamicAvatar;

  /// [version] is the version of the app.
  final String? version;

  /// [additionalActions] is the list of additional actions to be displayed in the drawer.
  /// This actions will be displayed before the about, settings, profile and logout buttons.
  final List<ThemedNavigatorItem> additionalActions;

  /// [mobileBreakpoint] is the breakpoint to be used to determine if the device is mobile or not.
  /// By default is `kMediumGrid`.
  final double mobileBreakpoint;

  /// [backgroundColor] is the background color of the drawer.
  /// By default is `Theme.of(context).primaryColor`.
  final Color? backgroundColor;

  /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
  /// By default is `Navigator.of(context).pushNamed`
  final ThemedNavigatorPushFunction? onNavigatorPush;

  /// [onNavigatorPop] is the callback to be executed when the back button is tapped.
  /// By default is `Navigator.of(context).pop`
  final ThemdNavigatorPopFunction? onNavigatorPop;

  /// [currentPath] is the current path of the navigator. Overrides the default path detection.
  /// By default, we get the current path from `ModalRoute.of(context)?.settings.name`.
  final String? currentPath;

  /// [enableNotifications] is a boolean that enables the notifications button and page.
  final bool enableNotifications;

  /// [notifications] is the list of notifications to be displayed in the drawer.
  final List<ThemedNotificationItem> notifications;

  /// [homePath] is the path of the home page.
  final String homePath;

  /// [depthColorFactor] is the factor to be used to calculate the color of the depth.
  /// By default is `0.15`.
  final double depthColorFactor;

  /// [avatarRadius] is the radius of the avatar.
  /// By default is `5`.
  final double avatarRadius;

  /// [ThemedMiniBar] is the custom native [Drawer]
  const ThemedMiniBar({
    super.key,
    this.items = const [],
    this.persistentItems = const [],
    this.enableAbout = true,
    this.onSettingsTap,
    this.onProfileTap,
    this.onLogoutTap,
    this.onThemeSwitchTap,
    required this.appTitle,
    this.companyName = 'Golden M, Inc',
    required this.logo,
    required this.favicon,
    this.userName = "Golden M",
    this.userAvatar,
    this.userDynamicAvatar,
    this.version,
    this.additionalActions = const [],
    this.mobileBreakpoint = kMediumGrid,
    this.backgroundColor,
    this.onNavigatorPush,
    this.onNavigatorPop,
    this.currentPath,
    this.enableNotifications = true,
    this.notifications = const [],
    this.homePath = '/home',
    this.depthColorFactor = 0.15,
    this.avatarRadius = 5,
  });

  @override
  State<ThemedMiniBar> createState() => _ThemedMiniBarState();
}

class _ThemedMiniBarState extends State<ThemedMiniBar> with TickerProviderStateMixin {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get backgroundColor =>
      isDark ? Theme.of(context).scaffoldBackgroundColor : widget.backgroundColor ?? Theme.of(context).primaryColor;
  String get favicon => useBlack(color: backgroundColor) ? widget.favicon.normal : widget.favicon.white;
  double get faviconSize => 25;
  double get actionSize => 50;
  String get currentPath => widget.currentPath ?? '';
  Color get activeColor => validateColor(color: backgroundColor);

  ThemedNavigatorPushFunction get onNavigatorPush =>
      widget.onNavigatorPush ?? (path) => Navigator.of(context).pushNamed(path);
  ThemdNavigatorPopFunction get onNavigatorPop => widget.onNavigatorPop ?? Navigator.of(context).pop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      padding: const EdgeInsets.all(10),
      decoration: generateContainerElevation(
        context: context,
        radius: 0,
        elevation: 2,
        color: backgroundColor,
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          InkWell(
            onTap: () => onNavigatorPush.call(widget.homePath),
            child: ThemedImage(
              path: favicon,
              width: faviconSize,
              height: faviconSize,
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildItem(ThemedNavigatorSeparator(type: ThemedSeparatorType.dots)),
                    ThemedAppBarAvatar(
                      asTaskBar: false,
                      tooltipPosition: ThemedTooltipPosition.right,
                      appTitle: widget.appTitle,
                      logo: widget.logo,
                      favicon: widget.favicon,
                      version: widget.version,
                      companyName: widget.companyName,
                      userName: widget.userName,
                      userDynamicAvatar: widget.userDynamicAvatar,
                      enableAbout: widget.enableAbout,
                      onSettingsTap: widget.onSettingsTap,
                      onProfileTap: widget.onProfileTap,
                      onLogoutTap: widget.onLogoutTap,
                      onNavigatorPush: onNavigatorPush,
                      onNavigatorPop: onNavigatorPop,
                      additionalActions: widget.additionalActions,
                      backgroundColor: widget.backgroundColor,
                      onThemeSwitchTap: widget.onThemeSwitchTap,
                      avatarRadius: widget.avatarRadius,
                    ),
                    if (widget.persistentItems.isNotEmpty) ...[
                      _buildItem(ThemedNavigatorSeparator(type: ThemedSeparatorType.dots)),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.persistentItems.length,
                        itemBuilder: (context, index) {
                          return _buildItem(widget.persistentItems[index]);
                        },
                      ),
                    ],
                    if (widget.items.isNotEmpty) ...[
                      _buildItem(ThemedNavigatorSeparator(type: ThemedSeparatorType.dots)),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          return _buildItem(widget.items[index]);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (widget.enableNotifications) ...[
            const SizedBox(height: 10),
            _buildItem(ThemedNavigatorSeparator()),
            ThemedNotificationIcon(
              dense: true,
              notifications: widget.notifications,
              backgroundColor: backgroundColor,
              location: ThemedNotificationLocation.miniBar,
              expandToLeft: false,
              forceFullSize: false,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItem(ThemedNavigatorItem item, {int depth = 0}) {
    if (item is ThemedNavigatorLabel) {
      return ThemedTooltip(
        position: ThemedTooltipPosition.right,
        message: item.labelText ?? item.label?.toString() ?? '',
        child: Container(
          margin: const EdgeInsets.all(5),
          width: actionSize - 10,
          height: actionSize - 10,
          child: Center(
            child: Icon(
              MdiIcons.label,
              color: validateColor(color: backgroundColor),
              size: 20,
            ),
          ),
        ),
      );
    }

    if (item is ThemedNavigatorPage) {
      bool highlight = currentPath.startsWith(item.path);
      bool isExpanded = highlight;
      AnimationController controller = AnimationController(
        duration: kHoverDuration,
        vsync: this,
        value: isExpanded ? 1 : 0,
      );

      return StatefulBuilder(
        builder: (context, setState) {
          bool highlightTop = isExpanded && item.children.isNotEmpty;

          Widget baseWidget = ThemedTooltip(
            position: ThemedTooltipPosition.right,
            message: item.labelText ?? item.label?.toString() ?? '',
            child: Container(
              margin: const EdgeInsets.all(5),
              // margin: highlight && depth == 0 ? EdgeInsets.zero : const EdgeInsets.all(5),
              // padding: highlight && depth == 0 ? const EdgeInsets.all(5) : EdgeInsets.zero,
              width: actionSize - 10,
              height: actionSize - 10,
              decoration: BoxDecoration(
                color: highlightTop
                    ? activeColor.withOpacity(0.2)
                    : highlight
                        ? activeColor
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(actionSize),
              ),
              clipBehavior: Clip.antiAlias,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (item.children.isEmpty) {
                      item.onTap.call(onNavigatorPush);
                    } else {
                      setState(() => isExpanded = !isExpanded);
                      if (isExpanded) {
                        controller.forward();
                      } else {
                        controller.reverse();
                      }
                    }
                  },
                  hoverColor: validateColor(color: backgroundColor).withOpacity(0.1),
                  child: Center(
                    child: Icon(
                      highlightTop ? MdiIcons.menuDown : (item.icon ?? MdiIcons.help),
                      size: highlightTop ? 22 : 18,
                      color: highlightTop
                          ? validateColor(color: backgroundColor)
                          : highlight
                              ? backgroundColor
                              : validateColor(color: backgroundColor),
                    ),
                  ),
                ),
              ),
            ),
          );

          bool display = isExpanded && item.children.isNotEmpty;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: kHoverDuration,
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(display ? widget.depthColorFactor : 0),
                  borderRadius: BorderRadius.circular(actionSize),
                ),
                child: Column(
                  children: [
                    baseWidget,
                    SizeTransition(
                      sizeFactor: CurvedAnimation(
                        parent: controller,
                        curve: Curves.easeInOutQuart,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: item.children.length,
                        itemBuilder: (context, index) {
                          return _buildItem(
                            item.children[index],
                            depth: depth + 1,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }

    if (item is ThemedNavigatorAction) {
      return ThemedTooltip(
        position: ThemedTooltipPosition.right,
        message: item.labelText ?? item.label?.toString() ?? '',
        child: Container(
          margin: const EdgeInsets.all(5),
          width: actionSize - 10,
          height: actionSize - 10,
          decoration: BoxDecoration(
            // color: validateColor(color: backgroundColor).withOpacity(0.2),
            borderRadius: BorderRadius.circular(actionSize),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(actionSize),
              hoverColor: validateColor(color: backgroundColor).withOpacity(0.1),
              onTap: item.onTap,
              child: Center(
                child: Icon(
                  item.icon ?? MdiIcons.help,
                  color: validateColor(color: backgroundColor),
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (item is ThemedNavigatorSeparator) {
      Color dividerColor = validateColor(color: backgroundColor).withOpacity(0.2);
      if (item.type == ThemedSeparatorType.line) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Divider(
            indent: 2,
            endIndent: 2,
            color: dividerColor,
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (_) {
            return Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: dividerColor,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      );
    }

    return const SizedBox();
  }
}
