part of '../../layout.dart';

class ThemedAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// [buttons] is the list of buttons to be displayed in the drawer.
  final List<ThemedNavigatorItem> items;

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

  /// [isDesktop] is the flag to know if the drawer is in desktop mode.
  /// By default is `false`.
  /// If `true`, the drawer will be displayed as a drawer and enables the option to contract it
  final bool isDesktop;

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

  /// [mobileBreakpoint] is the breakpoint to display the notifications.
  /// By default is `kMediumGrid`.
  final double mobileBreakpoint;

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

  /// [isMobile] is the flag to know if the app is in mobile mode.
  final bool? isMobile;

  /// [ThemedAppBar] is the app bar of the app.
  const ThemedAppBar({
    super.key,
    this.items = const [],
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
    this.isDesktop = false,
    this.enableAlternativeUserMenu = false,
    this.additionalActions = const [],
    this.backgroundColor,
    this.notifications = const [],
    this.mobileBreakpoint = kMediumGrid,
    this.enableNotifications = true,
    this.onNavigatorPush,
    this.onNavigatorPop,
    this.isBackEnabled = true,
    this.currentPath,
    this.hideAvatar = false,
    this.avatarRadius = 5,
    this.isMobile,
  });

  static bool get isMacOS => ThemedPlatform.isMacOS;

  static Size get size => Size.fromHeight(isMacOS ? 50 : 55);

  @override
  Size get preferredSize => size;

  @override
  State<ThemedAppBar> createState() => _ThemedAppBarState();
}

class _ThemedAppBarState extends State<ThemedAppBar> with TickerProviderStateMixin {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get activeColor => isDark ? Colors.white : Theme.of(context).primaryColor;

  String get logo => isDark ? widget.logo.white : widget.logo.normal;
  String get favicon => isDark ? widget.favicon.white : widget.favicon.normal;

  Color get backgroundColor => widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
  double get width => MediaQuery.of(context).size.width;
  bool get isMobile => widget.isMobile ?? width < widget.mobileBreakpoint;

  String get currentPath => widget.currentPath ?? ModalRoute.of(context)?.settings.name ?? '';
  bool get isHome => currentPath == widget.homePath;

  bool get isMacOS => ThemedPlatform.isMacOS;

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
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double logoHeight = ThemedAppBar.size.height - 20;
            double logoWidth = logoHeight * kLogoAspectRatio;
            String logoPath = logo;

            if (isMobile) {
              logoWidth = constraints.maxWidth - 120;
              logoHeight = logoWidth / kLogoAspectRatio;

              if (logoHeight > ThemedAppBar.size.height - 20) {
                logoHeight = ThemedAppBar.size.height - 20;
              }

              if (constraints.maxWidth < 300) {
                logoWidth = ThemedAppBar.size.height - 20;
                logoHeight = ThemedAppBar.size.height - 20;
                logoPath = favicon;
              }
            }

            return SizedBox(
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
                        onTap: () => Scaffold.of(context).openDrawer(),
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
                      width: logoWidth,
                      height: logoHeight,
                      child: ThemedImage(
                        path: logoPath,
                        width: logoWidth,
                        height: logoHeight,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
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
                              if (item is ThemedNavigatorLabel) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: item.label ?? Text(item.labelText ?? ''),
                                );
                              }

                              if (item is ThemedNavigatorPage) {
                                bool highlight = currentPath.startsWith(item.path);

                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                                  decoration: BoxDecoration(
                                    color: highlight ? activeColor.withOpacity(0.2) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => item.onTap.call(onNavigatorPush),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (item.icon != null) ...[
                                              Icon(
                                                item.icon ?? MdiIcons.help,
                                                size: 16,
                                                color: highlight ? activeColor : validateColor(color: backgroundColor),
                                              ),
                                              const SizedBox(width: 10),
                                            ],
                                            item.label ?? Text(item.labelText ?? ''),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (item is ThemedNavigatorAction) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: item.onTap,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (item.icon != null) ...[
                                              Icon(
                                                item.icon ?? MdiIcons.help,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 10),
                                            ],
                                            item.label ?? Text(item.labelText ?? ''),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (item is ThemedNavigatorSeparator) {
                                if (item.type == ThemedSeparatorType.line) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                                    child: const VerticalDivider(),
                                  );
                                }

                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
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
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    const Spacer(),
                  ],
                  if (widget.enableNotifications) ...[
                    const SizedBox(width: 10),
                    ThemedNotificationIcon(
                      notifications: widget.notifications,
                      backgroundColor: backgroundColor,
                      location: ThemedNotificationLocation.appBar,
                    ),
                  ],
                  if (!widget.hideAvatar) ...[
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
