part of '../layout.dart';

class ThemedDrawer extends StatefulWidget {
  /// [scaffoldKey] is the key of the scaffold.
  final GlobalKey<ScaffoldState> scaffoldKey;

  /// [items] is the list of buttons to be displayed in the drawer.
  final List<ThemedNavigatorItem> items;

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

  /// [paddingAmplifier] is the padding amplifier of the drawer.
  /// Only will affect when the children contains more children. By default is `7`.
  final double paddingAmplifier;

  /// [additionalActions] is the list of additional actions to be displayed in the drawer.
  /// This actions will be displayed before the about, settings, profile and logout buttons.
  final List<ThemedNavigatorItem> additionalActions;

  /// [mobileBreakpoint] is the breakpoint to be used to determine if the device is mobile or not.
  /// By default is `kMediumGrid`.
  final double mobileBreakpoint;

  /// [backgroundColor] is the background color of the drawer.
  /// By default is `Theme.of(context).primaryColor`.
  final Color? backgroundColor;

  /// [fromScaffold] is a boolean that indicates if the drawer is being used from a scaffold.
  /// By default is `false`.
  final bool fromScaffold;

  /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
  /// By default is `Navigator.of(context).pushNamed`
  final ThemedNavigatorPushFunction? onNavigatorPush;

  /// [onNavigatorPop] is the callback to be executed when the back button is tapped.
  /// By default is `Navigator.of(context).pop`
  final ThemdNavigatorPopFunction? onNavigatorPop;

  /// [currentPath] is the current path of the navigator. Overrides the default path detection.
  /// By default, we get the current path from `ModalRoute.of(context)?.settings.name`.
  final String? currentPath;

  /// [ThemedDrawer] is the custom native [Drawer]
  const ThemedDrawer({
    super.key,
    required this.scaffoldKey,
    this.items = const [],
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
    this.paddingAmplifier = 7,
    this.additionalActions = const [],
    this.mobileBreakpoint = kMediumGrid,
    this.backgroundColor,
    this.fromScaffold = false,
    this.onNavigatorPush,
    this.onNavigatorPop,
    this.currentPath,
  });

  @override
  State<ThemedDrawer> createState() => _ThemedDrawerState();
}

class _ThemedDrawerState extends State<ThemedDrawer> with TickerProviderStateMixin {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get backgroundColor =>
      widget.backgroundColor ?? (isDark ? Colors.grey.shade900 : Theme.of(context).primaryColor);

  final ScrollController _scrollController = ScrollController();
  late AnimationController _userExpandController;
  dynamic get appTitle => widget.appTitle;
  String get companyName => widget.companyName;
  String? get version => widget.version;
  bool get displayActions =>
      widget.onSettingsTap != null || widget.onProfileTap != null || widget.onLogoutTap != null || widget.enableAbout;

  bool get isMobile => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  bool get isMacOS => !kIsWeb && Platform.isMacOS;

  bool actionsExpanded = false;
  bool isExpanded = false;
  double get width => MediaQuery.of(context).size.width;

  ThemedNavigatorPushFunction get onNavigatorPush =>
      widget.onNavigatorPush ?? (path) => Navigator.of(context).pushNamed(path);
  ThemdNavigatorPopFunction get onNavigatorPop => widget.onNavigatorPop ?? Navigator.of(context).pop;
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);

  @override
  void initState() {
    super.initState();
    _userExpandController = AnimationController(vsync: this, duration: kHoverDuration);
  }

  @override
  void dispose() {
    _userExpandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ThemedNavigatorItem> actions = [
      ...widget.additionalActions,
      if (widget.enableAbout)
        ThemedNavigatorAction(
          labelText: i18n?.t('layrz.taskbar.about') ?? 'About',
          icon: MdiIcons.informationOutline,
          onTap: () => showThemedAboutDialog(
            context: context,
            companyName: widget.companyName,
            logo: widget.logo,
            version: widget.version,
          ),
        ),
      if (widget.onThemeSwitchTap != null)
        ThemedNavigatorAction(
          labelText: i18n?.t('layrz.taskbar.toggleTheme') ?? 'Toggle theme',
          icon: MdiIcons.themeLightDark,
          onTap: widget.onThemeSwitchTap!,
        ),
      if (widget.onSettingsTap != null)
        ThemedNavigatorAction(
          labelText: i18n?.t('layrz.taskbar.settings') ?? 'Settings',
          icon: MdiIcons.cogOutline,
          onTap: widget.onSettingsTap!,
        ),
      if (widget.onProfileTap != null)
        ThemedNavigatorAction(
          labelText: i18n?.t('layrz.taskbar.profile') ?? 'Edit profile',
          icon: MdiIcons.accountCircleOutline,
          onTap: widget.onProfileTap!,
        ),
      if (widget.onLogoutTap != null)
        ThemedNavigatorAction(
          labelText: i18n?.t('layrz.taskbar.signOut') ?? 'Logout',
          icon: MdiIcons.logoutVariant,
          onTap: widget.onLogoutTap!,
        ),
    ];

    Color sidebarTextColor = validateColor(color: backgroundColor);

    return Container(
      width: 270,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: generateContainerElevation(
        context: context,
        radius: 0,
        color: backgroundColor,
        shadowColor: backgroundColor,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isMacOS) ...[
              const SizedBox(height: 40),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ThemedImage(
                  path: useBlack(color: backgroundColor) ? widget.favicon.normal : widget.favicon.white,
                  width: 25,
                  height: 25,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.appTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: sidebarTextColor,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: sidebarTextColor.withOpacity(0.2)),
            const SizedBox(height: 10),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  if (isExpanded) {
                    await _userExpandController.reverse();
                  } else {
                    await _userExpandController.forward();
                  }
                  setState(() => isExpanded = !isExpanded);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    drawAvatar(
                      context: context,
                      name: widget.userName,
                      avatar: widget.userAvatar,
                      dynamicAvatar: widget.userDynamicAvatar,
                      color: validateColor(color: backgroundColor),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.userName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: sidebarTextColor,
                            ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedBuilder(
                      animation: _userExpandController,
                      child: Icon(
                        MdiIcons.chevronDown,
                        color: sidebarTextColor,
                        size: 20,
                      ),
                      builder: (BuildContext context, Widget? child) {
                        return Transform.rotate(
                          angle: _userExpandController.value * pi,
                          child: child,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_userExpandController.value == 1)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  ...actions
                      .map((item) => item.toDrawerItem(
                            context: context,
                            backgroundColor: backgroundColor,
                            fromScaffold: widget.fromScaffold,
                            onNavigatorPush: onNavigatorPush,
                            onNavigatorPop: onNavigatorPop,
                            currentPath: widget.currentPath,
                          ))
                      .toList(),
                ],
              ),
            const SizedBox(height: 10),
            Divider(color: sidebarTextColor.withOpacity(0.2)),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    ...widget.items
                        .map((item) => item.toDrawerItem(
                              context: context,
                              backgroundColor: backgroundColor,
                              fromScaffold: widget.fromScaffold,
                              onNavigatorPush: onNavigatorPush,
                              onNavigatorPop: onNavigatorPop,
                              currentPath: widget.currentPath,
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (widget.version != null) ...[
              Divider(color: sidebarTextColor.withOpacity(0.2)),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ThemedLicensesView(
                        companyName: companyName,
                        logo: widget.logo,
                        version: version,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10).add(const EdgeInsets.only(top: 10)),
                  child: Center(
                    child: Text(
                      "v${widget.version!}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: sidebarTextColor,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
