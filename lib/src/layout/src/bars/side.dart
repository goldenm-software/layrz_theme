part of '../../layout.dart';

class ThemedSidebar extends StatefulWidget {
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

  /// [enableNotifications] is a boolean that enables the notifications button and page.
  final bool enableNotifications;

  /// [notifications] is the list of notifications to be displayed in the drawer.
  final List<ThemedNotificationItem> notifications;

  /// [ThemedSidebar] is the custom native [Drawer]
  const ThemedSidebar({
    super.key,
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
    this.enableNotifications = true,
    this.notifications = const [],
  });

  @override
  State<ThemedSidebar> createState() => _ThemedSidebarState();
}

class _ThemedSidebarState extends State<ThemedSidebar> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get backgroundColor =>
      widget.backgroundColor ??
      (isDark
          ? kDarkBackgroundColor
          : widget.fromScaffold
              ? kLightBackgroundColor
              : Theme.of(context).primaryColor);
  Color get activeColor => validateColor(color: backgroundColor);
  dynamic get appTitle => widget.appTitle;
  String get companyName => widget.companyName;
  String? get version => widget.version;
  bool get displayActions =>
      widget.onSettingsTap != null || widget.onProfileTap != null || widget.onLogoutTap != null || widget.enableAbout;

  bool get isMobile => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  bool get isMacOS => !kIsWeb && Platform.isMacOS;

  bool actionsExpanded = false;
  bool isExpanded = false;
  double get width => MediaQuery.sizeOf(context).width;

  ThemedNavigatorPushFunction get onNavigatorPush =>
      widget.onNavigatorPush ?? (path) => Navigator.of(context).pushNamed(path);
  ThemdNavigatorPopFunction get onNavigatorPop => widget.onNavigatorPop ?? Navigator.of(context).pop;
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);

  String get currentPath => widget.currentPath ?? '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleOnTap(VoidCallback? onTap) {
    if (onTap == null) return;

    if (widget.fromScaffold) {
      Navigator.of(context).pop(); // Close the drawer
      Future.delayed(const Duration(milliseconds: 230), () {
        WidgetsBinding.instance.addPostFrameCallback((_) => onTap.call());
      });
      return;
    }

    return onTap.call();
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
      decoration: generateContainerElevation(
        context: context,
        radius: 0,
        color: backgroundColor,
      ).copyWith(
        boxShadow: widget.fromScaffold
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 10,
                )
              ]
            : null,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isMacOS) ...[
              const SizedBox(height: 40),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15).add(const EdgeInsets.only(top: 10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ThemedImage(
                      path: useBlack(color: backgroundColor) ? widget.logo.normal : widget.logo.white,
                      width: 30 * kLogoAspectRatio,
                      height: 30,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  if (widget.enableNotifications) ...[
                    const SizedBox(width: 10),
                    ThemedNotificationIcon(
                      dense: true,
                      notifications: widget.notifications,
                      backgroundColor: backgroundColor,
                      inAppBar: true,
                      expandToLeft: true,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildItem(ThemedNavigatorSeparator(), removePadding: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 5),
                decoration: BoxDecoration(
                  color: isExpanded ? activeColor.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          drawAvatar(
                            context: context,
                            name: widget.userName,
                            avatar: widget.userAvatar,
                            dynamicAvatar: widget.userDynamicAvatar,
                            color: backgroundColor,
                            shadowColor: Colors.black.withOpacity(0.2),
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
                          Icon(
                            isExpanded ? MdiIcons.chevronUp : MdiIcons.chevronDown,
                            color: sidebarTextColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isExpanded) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    return _buildItem(
                      actions[index],
                      depth: 1,
                    );
                  },
                ),
              ),
            ],
            _buildItem(ThemedNavigatorSeparator(), removePadding: true),
            const SizedBox(height: 10),
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return _buildItem(widget.items[index]);
                  },
                ),
              ),
            ),
            if (widget.version != null) ...[
              const SizedBox(height: 5),
              _buildItem(ThemedNavigatorSeparator(), removePadding: true),
              InkWell(
                onTap: () => showThemedAboutDialog(
                  context: context,
                  companyName: widget.companyName,
                  logo: widget.logo,
                  version: widget.version,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10).add(const EdgeInsets.only(top: 10)),
                  child: Center(
                    child: Text(
                      "v${widget.version!}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: sidebarTextColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItem(ThemedNavigatorItem item, {int depth = 0, bool removePadding = false}) {
    if (item is ThemedNavigatorLabel) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 5).add(EdgeInsets.only(
          left: 10 * depth.toDouble(),
        )),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: item.label ??
            Text(
              item.labelText ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: validateColor(color: backgroundColor),
                  ),
            ),
      );
    }

    if (item is ThemedNavigatorPage) {
      bool highlight = currentPath.startsWith(item.path);
      bool isExpanded = highlight;

      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 5).add(EdgeInsets.only(
                  left: 10 * depth.toDouble(),
                )),
                decoration: BoxDecoration(
                  color: highlight ? activeColor.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: item.children.isEmpty
                        ? () => handleOnTap(() => onNavigatorPush.call(item.path))
                        : () {
                            setState(() => isExpanded = !isExpanded);
                          },
                    hoverColor: validateColor(color: backgroundColor).withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item.icon != null) ...[
                            Icon(
                              item.icon ?? MdiIcons.help,
                              size: 18,
                              color: highlight ? activeColor : validateColor(color: backgroundColor),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Expanded(
                            child: item.label ??
                                Text(
                                  item.labelText ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: highlight ? activeColor : validateColor(color: backgroundColor),
                                      ),
                                ),
                          ),
                          if (item.children.isNotEmpty) ...[
                            Icon(
                              isExpanded ? MdiIcons.chevronUp : MdiIcons.chevronDown,
                              size: 20,
                              color: validateColor(color: backgroundColor),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (isExpanded) ...[
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: item.children.length,
                  itemBuilder: (context, index) {
                    return _buildItem(
                      item.children[index],
                      depth: depth + 1,
                    );
                  },
                ),
              ],
            ],
          );
        },
      );
    }

    if (item is ThemedNavigatorAction) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 5).add(EdgeInsets.only(
          left: 10 * depth.toDouble(),
        )),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => handleOnTap(item.onTap),
            hoverColor: validateColor(color: backgroundColor).withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.icon != null) ...[
                    Icon(
                      item.icon ?? MdiIcons.help,
                      size: 18,
                      color: validateColor(color: backgroundColor),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: item.label ??
                        Text(
                          item.labelText ?? '',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: validateColor(color: backgroundColor),
                              ),
                        ),
                  ),
                ],
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
          padding: removePadding ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 5),
          child: Divider(
            indent: 5,
            endIndent: 5,
            color: dividerColor,
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(40, (_) {
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
