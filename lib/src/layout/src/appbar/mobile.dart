part of '../../layout.dart';

class ThemedMobileAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// [homePath] is the path of the home page.
  final String homePath;

  /// [disableLeading] is a boolean that prevents the back button from being
  /// displayed.
  final bool disableLeading;

  /// [appTitle] is the title of the app.
  final String appTitle;

  /// [logo] is the logo of the app. Can be a path or a url.
  final AppThemedAsset logo;

  /// [favicon] is the favicon of the app. Can be a path or a url.
  final AppThemedAsset favicon;

  /// [version] is the version of the app.
  final String? version;

  /// [companyName] is the name of the company.
  final String companyName;

  /// [userName] is the name of the user.
  final String userName;

  /// [userDynamicAvatar] is the dynamic avatar of the user.
  /// In other components like `ThemedDrawer`, the prop is `ThemedDrawer.userDynamicAvatar`.
  final Avatar? userDynamicAvatar;

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

  /// [enableAlternativeUserMenu] is the flag to know if the user menu is displayed as a button
  /// or as a menu.
  /// By default is `false`.
  /// If `true`, the user menu will be displayed as a button and enables the option to contract it
  /// and display the user menu as a menu.
  final bool enableAlternativeUserMenu;

  /// [additionalActions] is the list of additional actions to be displayed in the app bar.
  /// By default is `[]`.
  /// Its important to note that the additional actions are displayed in the app bar only if
  /// [enableAlternativeUserMenu] is `true`.
  final List<ThemedNavigatorItem> additionalActions;

  /// [backgroundColor] is the background color of the app bar.
  /// Overrides the default background color from `Theme.of(context).scaffoldBackgroundColor`.
  final Color? backgroundColor;

  /// [notifications] is the list of notifications to be displayed in the app bar.
  /// By default is `[]`. Only will appear when the `mobileBreakpoint` is reached.
  final List<ThemedNotificationItem> notifications;

  /// [enableNotifications] is the flag to force the notification icon to be displayed.
  /// By default is `false`.
  final bool enableNotifications;

  /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
  /// By default is `Navigator.of(context).pushNamed`
  final ThemedNavigatorPushFunction? onNavigatorPush;

  /// [onNavigatorPop] is the callback to be executed when the back button is tapped.
  /// By default is `Navigator.of(context).pop`
  final ThemdNavigatorPopFunction? onNavigatorPop;

  /// [isBackEnabled] is the flag to enable the back button.
  /// By default is `true`.
  final bool isBackEnabled;

  /// [currentPath] is the current path of the navigator. Overrides the default path detection.
  /// By default, we get the current path from `ModalRoute.of(context)?.settings.name`.
  final String? currentPath;

  /// [hideAvatar] is the flag to hide the avatar.
  /// By default is `false`.
  final bool hideAvatar;

  /// [avatarRadius] is the radius of the avatar.
  /// By default is `5`.
  final double avatarRadius;

  /// [items] is the list of buttons to be displayed.
  final List<ThemedNavigatorItem> items;

  /// [ThemedMobileAppBar] is the app bar of the app.
  const ThemedMobileAppBar({
    super.key,
    this.homePath = '/home',
    this.disableLeading = false,
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
    this.userDynamicAvatar,
    this.version,
    this.enableAlternativeUserMenu = false,
    this.additionalActions = const [],
    this.backgroundColor,
    this.notifications = const [],
    this.enableNotifications = true,
    this.onNavigatorPush,
    this.onNavigatorPop,
    this.isBackEnabled = true,
    this.currentPath,
    this.hideAvatar = false,
    this.avatarRadius = 5,
    this.items = const [],
  });

  static bool get isMacOS => ThemedPlatform.isMacOS;

  static Size get size => Size.fromHeight(isMacOS ? 50 : 55);

  @override
  Size get preferredSize => size;

  @override
  State<ThemedMobileAppBar> createState() => _ThemedMobileAppBarState();
}

class _ThemedMobileAppBarState extends State<ThemedMobileAppBar> with TickerProviderStateMixin {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get activeColor => isDark ? Colors.white : Theme.of(context).primaryColor;

  String get logo => isDark ? widget.logo.white : widget.logo.normal;
  String get favicon => isDark ? widget.favicon.white : widget.favicon.normal;

  Color get backgroundColor => widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
  double get width => MediaQuery.of(context).size.width;

  String get currentPath => widget.currentPath ?? ModalRoute.of(context)?.settings.name ?? '';
  bool get isHome => currentPath == widget.homePath;

  bool get isMacOS => ThemedPlatform.isMacOS;

  double get actionSize => 50;

  ThemedNavigatorPushFunction get onNavigatorPush =>
      widget.onNavigatorPush ?? (path) => Navigator.of(context).pushNamed(path);

  ThemdNavigatorPopFunction get onNavigatorPop => widget.onNavigatorPop ?? Navigator.of(context).pop;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: ThemedAppBar.size.height,
              child: Row(
                children: [
                  if (widget.isBackEnabled && !isHome) ...[
                    ThemedButton(
                      style: ThemedButtonStyle.fab,
                      icon: MdiIcons.chevronLeft,
                      labelText: 'Back',
                      tooltipEnabled: false,
                      onTap: widget.onNavigatorPop ?? () => Navigator.of(context).pop(),
                    ),
                  ],
                  Expanded(
                    child: ThemedImage(
                      path: isDark ? widget.logo.white : widget.logo.normal,
                      height: 40,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Row(
                    children: widget.items.map((item) {
                      return _buildItem(item);
                    }).toList(),
                  ),
                  if (widget.enableNotifications) ...[
                    const SizedBox(width: 10),
                    ThemedNotificationIcon(
                      notifications: widget.notifications,
                      backgroundColor: backgroundColor,
                      location: ThemedNotificationLocation.appBar,
                    ),
                  ],
                  const SizedBox(width: 10),
                  ThemedAppBarAvatar(
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(ThemedNavigatorItem item) {
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

      return StatefulBuilder(
        builder: (context, setState) {
          bool highlightTop = isExpanded && item.children.isNotEmpty;
          return ThemedTooltip(
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
                      final first = item.children.whereType<ThemedNavigatorPage>().firstOrNull;
                      if (first != null) {
                        onNavigatorPush.call(first.path);
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
      if (item.type == ThemedSeparatorType.line) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 5),
          child: const VerticalDivider(),
        );
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (_) {
            return Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
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
