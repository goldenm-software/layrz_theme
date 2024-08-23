part of '../../layout.dart';

class ThemedBottomBar extends StatefulWidget {
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

  /// [ThemedBottomBar] is a brand-new bottom bar for your app.
  ///
  /// Renders the items in a single line, and if this item has childrens, it will render
  /// a second line with the childrens.
  ///
  /// The maximum depth of the childrens is 2. That means:
  /// - The first line is the parent item.
  /// - The second line is the children item.
  /// * ANY DEEPER THAN THIS WILL BE JOINED IN THE SAME LINE.
  const ThemedBottomBar({
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
  });

  @override
  State<ThemedBottomBar> createState() => _ThemedBottomBarState();
}

class _ThemedBottomBarState extends State<ThemedBottomBar> with TickerProviderStateMixin {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get backgroundColor =>
      isDark ? Theme.of(context).scaffoldBackgroundColor : widget.backgroundColor ?? Theme.of(context).primaryColor;
  String get favicon => useBlack(color: backgroundColor) ? widget.favicon.normal : widget.favicon.white;
  String get currentPath => widget.currentPath ?? '';
  Color get activeColor => validateColor(color: backgroundColor);
  double get actionSize => 40;

  List<ThemedNavigatorItem> _children = [];

  ThemedNavigatorPushFunction get onNavigatorPush =>
      widget.onNavigatorPush ?? (path) => Navigator.of(context).pushNamed(path);
  ThemdNavigatorPopFunction get onNavigatorPop => widget.onNavigatorPop ?? Navigator.of(context).pop;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getChildrenUrls());
  }

  @override
  void didUpdateWidget(ThemedBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _getChildrenUrls());
  }

  void _getChildrenUrls() {
    String path = widget.currentPath ?? ModalRoute.of(context)?.settings.name ?? '';
    final parent =
        widget.items.whereType<ThemedNavigatorPage>().firstWhereOrNull((parents) => path.startsWith(parents.path));

    if (parent == null) {
      _children = [];
      return;
    }

    _children = parent.children
        .map((child) {
          if (child is ThemedNavigatorPage) {
            if (child.children.isEmpty) return [child];

            return [...child.children];
          }

          return [child];
        })
        .expand((element) => element)
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      height: kBottomBarHeight * (_children.isNotEmpty ? 2 : 1),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              if (_children.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  color: activeColor.withOpacity(0.2),
                  height: kBottomBarHeight,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ..._children.map((item) => _buildItem(item, depth: 1)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: kBottomBarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ThemedAppBarAvatar(
                      tooltipPosition: ThemedTooltipPosition.top,
                      asTaskBar: true,
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
                    ),
                    _buildItem(ThemedNavigatorSeparator(type: ThemedSeparatorType.dots), removePadding: true),
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.items.isNotEmpty) ...widget.items.map((item) => _buildItem(item)),
                              if (widget.persistentItems.isNotEmpty)
                                ...widget.persistentItems.map((item) => _buildItem(item)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.enableNotifications) ...[
                      const SizedBox(height: 10),
                      _buildItem(ThemedNavigatorSeparator(), removePadding: true),
                      ThemedNotificationIcon(
                        dense: true,
                        notifications: widget.notifications,
                        backgroundColor: backgroundColor,
                        location: ThemedNotificationLocation.bottomBar,
                        expandToLeft: false,
                        forceFullSize: true,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(ThemedNavigatorItem item, {int depth = 0, bool removePadding = false}) {
    if (item is ThemedNavigatorLabel) {
      return ThemedTooltip(
        position: ThemedTooltipPosition.top,
        message: item.labelText ?? item.label?.toString() ?? '',
        child: Container(
          margin: const EdgeInsets.all(5),
          width: kBottomBarHeight,
          height: actionSize,
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
      return StatefulBuilder(
        builder: (context, setState) {
          bool highlightTop = isExpanded && item.children.isNotEmpty;

          Widget baseWidget = ThemedTooltip(
            position: ThemedTooltipPosition.top,
            message: item.labelText ?? item.label?.toString() ?? '',
            child: Container(
              margin: highlightTop
                  ? const EdgeInsets.only(
                      bottom: 5,
                      left: 5,
                      right: 5,
                    )
                  : const EdgeInsets.all(5),
              width: actionSize + (highlightTop ? 5 : 0),
              height: actionSize + (highlightTop ? 5 : 0),
              decoration: BoxDecoration(
                color: highlightTop
                    ? activeColor.withOpacity(0.2)
                    : highlight
                        ? activeColor
                        : Colors.transparent,
                borderRadius: highlightTop
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(actionSize),
                        bottomRight: Radius.circular(actionSize),
                      )
                    : BorderRadius.circular(actionSize),
              ),
              clipBehavior: Clip.antiAlias,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => item.onTap.call(onNavigatorPush),
                  hoverColor: validateColor(color: backgroundColor).withOpacity(0.1),
                  child: Center(
                    child: Icon(
                      highlightTop ? MdiIcons.menuUp : (item.icon ?? MdiIcons.help),
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

          return baseWidget;
        },
      );
    }

    if (item is ThemedNavigatorAction) {
      return ThemedTooltip(
        position: ThemedTooltipPosition.top,
        message: item.labelText ?? item.label?.toString() ?? '',
        child: Container(
          margin: const EdgeInsets.all(5),
          width: actionSize,
          height: actionSize,
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
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: actionSize,
          child: VerticalDivider(color: dividerColor),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: actionSize,
        child: Column(
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
