part of layout;

class ThemedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final List<ThemedNavigatorItem> items;
  final String homePath;
  final bool disableLeading;
  final String appTitle;
  final AppThemedAsset logo;
  final AppThemedAsset favicon;
  final String? version;
  final String companyName;
  final String userName;
  final Avatar? userDynamicAvatar;
  final bool enableAbout;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoutTap;
  final VoidCallback? onThemeSwitchTap;
  final bool isDesktop;
  final bool enableAlternativeUserMenu;
  final List<ThemedNavigatorItem> additionalActions;
  final Color? backgroundColor;
  final List<ThemedNotificationItem> notifications;
  final double mobileBreakpoint;
  final bool forceNotificationIcon;
  final bool disableNotifications;
  final ThemedNavigatorPushFunction? onNavigatorPush;
  final ThemdNavigatorPopFunction? onNavigatorPop;
  final bool isBackEnabled;

  const ThemedAppBar({
    super.key,

    /// [scaffoldKey] is the key of the scaffold.
    required this.scaffoldKey,

    /// [buttons] is the list of buttons to be displayed in the drawer.
    this.items = const [],

    /// [homePath] is the path of the home page.
    this.homePath = '/home',

    /// [disableLeading] is a boolean that prevents the back button from being
    /// displayed.
    this.disableLeading = false,

    /// [enableAbout] is a boolean that enables the about button.
    this.enableAbout = true,

    /// [onSettingsTap] is the callback to be executed when the settings button
    this.onSettingsTap,

    /// [onProfileTap] is the callback to be executed when the profile button
    this.onProfileTap,

    /// [onLogoutTap] is the callback to be executed when the logout button
    this.onLogoutTap,

    /// [onThemeSwitchTap] is a callback that is called when the theme switch
    /// button is tapped.
    this.onThemeSwitchTap,

    /// [appTitle] is the title of the app.
    required this.appTitle,

    /// [companyName] is the name of the company.
    this.companyName = 'Golden M, Inc',

    /// [logo] is the logo of the app. Can be a path or a url.
    required this.logo,

    /// [favicon] is the favicon of the app. Can be a path or a url.
    required this.favicon,

    /// [userName] is the name of the user.
    this.userName = "Golden M",

    /// [userDynamicAvatar] is the dynamic avatar of the user.
    /// In other components like `ThemedDrawer`, the prop is `ThemedDrawer.userDynamicAvatar`.
    this.userDynamicAvatar,

    /// [version] is the version of the app.
    this.version,

    /// [isDesktop] is the flag to know if the drawer is in desktop mode.
    /// By default is `false`.
    /// If `true`, the drawer will be displayed as a drawer and enables the option to contract it
    this.isDesktop = false,

    /// [enableAlternativeUserMenu] is the flag to know if the user menu is displayed as a button
    /// or as a menu.
    /// By default is `false`.
    /// If `true`, the user menu will be displayed as a button and enables the option to contract it
    /// and display the user menu as a menu.
    this.enableAlternativeUserMenu = false,

    /// [additionalActions] is the list of additional actions to be displayed in the app bar.
    /// By default is `[]`.
    /// Its important to note that the additional actions are displayed in the app bar only if
    /// [enableAlternativeUserMenu] is `true`.
    this.additionalActions = const [],

    /// [backgroundColor] is the background color of the app bar.
    /// Overrides the default background color from `Theme.of(context).scaffoldBackgroundColor`.
    this.backgroundColor,

    /// [notifications] is the list of notifications to be displayed in the app bar.
    /// By default is `[]`. Only will appear when the `mobileBreakpoint` is reached.
    this.notifications = const [],

    /// [mobileBreakpoint] is the breakpoint to display the notifications.
    /// By default is `kMediumGrid`.
    this.mobileBreakpoint = kMediumGrid,

    /// [forceNotificationIcon] is the flag to force the notification icon to be displayed.
    /// By default is `false`.
    this.forceNotificationIcon = false,

    /// [disableNotifications] is the flag to disable the notifications.
    /// By default is `false`.
    this.disableNotifications = false,

    /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
    /// By default is `Navigator.of(context).pushNamed`
    this.onNavigatorPush,

    /// [onNavigatorPop] is the callback to be executed when the back button is tapped.
    /// By default is `Navigator.of(context).pop`
    this.onNavigatorPop,

    /// [isBackEnabled] is the flag to enable the back button.
    /// By default is `true`.
    this.isBackEnabled = true,
  });

  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  static Size get size => Size.fromHeight(isMacOS ? 50 : 55);

  @override
  Size get preferredSize => size;

  @override
  State<ThemedAppBar> createState() => _ThemedAppBarState();
}

class _ThemedAppBarState extends State<ThemedAppBar> with TickerProviderStateMixin {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  String get logo => isDark ? widget.logo.white : widget.logo.normal;
  Color get backgroundColor => widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
  double get width => MediaQuery.of(context).size.width;
  bool get isMobile => width < widget.mobileBreakpoint;

  String get currentPath => ModalRoute.of(context)?.settings.name ?? '';
  bool get isHome => currentPath == widget.homePath;

  bool get isMacOS => !kIsWeb && Platform.isMacOS;

  ThemedNavigatorPushFunction get onNavigatorPush =>
      widget.onNavigatorPush ?? (path) => Navigator.of(context).pushNamed(path);

  ThemdNavigatorPopFunction get onNavigatorPop => widget.onNavigatorPop ?? Navigator.of(context).pop;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _overrideAppBar();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: ThemedAppBar.size.height,
          child: Row(
            children: [
              if (isMacOS) ...[
                const SizedBox(width: 62),
              ],
              if (isMobile) ...[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => widget.scaffoldKey.currentState?.openDrawer(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        MdiIcons.dotsVertical,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ] else if (!isHome && widget.isBackEnabled) ...[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => onNavigatorPop.call(),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        MdiIcons.chevronLeft,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              InkWell(
                onTap: (!isMobile && !isHome) ? () => onNavigatorPush.call(widget.homePath) : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  height: ThemedAppBar.size.height - 10,
                  child: AspectRatio(
                    aspectRatio: 1000 / 300, // 1000px X 300px - default dimensions of logos from Layrz
                    child: ThemedImage(
                      path: logo,
                    ),
                  ),
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Row(
                        children: widget.items.map((item) {
                          return item.toAppBarItem(
                            context: context,
                            backgroundColor: backgroundColor,
                            onNavigatorPush: onNavigatorPush,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                if (widget.forceNotificationIcon) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ThemedNavigatorSeparator(
                      type: ThemedSeparatorType.dots,
                    ).toAppBarItem(
                      context: context,
                      backgroundColor: backgroundColor,
                      onNavigatorPush: onNavigatorPush,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (!widget.disableNotifications) ...[
                    ThemedNotificationIcon(
                      notifications: widget.notifications,
                      backgroundColor: backgroundColor,
                      inAppBar: true,
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
                    additionalActions: widget.additionalActions,
                    backgroundColor: widget.backgroundColor,
                    onThemeSwitchTap: widget.onThemeSwitchTap,
                  ),
                ],
              ] else ...[
                const Spacer(),
                if (!widget.disableNotifications) ...[
                  ThemedNotificationIcon(
                    notifications: widget.notifications,
                    backgroundColor: backgroundColor,
                    inAppBar: true,
                    forceFullSize: width < kSmallGrid,
                  ),
                ],
                const SizedBox(width: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _overrideAppBar() {
    bool isOpen = widget.scaffoldKey.currentState?.isDrawerOpen ?? false;
    SystemUiOverlayStyle style = Theme.of(context).appBarTheme.systemOverlayStyle!;

    if (isOpen) {
      style = style.copyWith(
        statusBarIconBrightness: useBlack(color: backgroundColor) ? Brightness.light : Brightness.dark,
        statusBarBrightness: useBlack(color: backgroundColor) ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness: useBlack(color: backgroundColor) ? Brightness.light : Brightness.dark,
      );
    }

    SystemChrome.setSystemUIOverlayStyle(style);
  }
}
