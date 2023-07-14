part of layout;

class ThemedAppBarAvatar extends StatefulWidget {
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
  final List<ThemedNavigatorItem> additionalActions;
  final Color? backgroundColor;
  final bool asTaskBar;
  final ThemedNavigatorPushFunction? onNavigatorPush;
  final ThemdNavigatorPopFunction? onNavigatorPop;

  const ThemedAppBarAvatar({
    super.key,

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

    /// [additionalActions] is the list of additional actions to be displayed in the app bar.
    /// By default is `[]`.
    /// Its important to note that the additional actions are displayed in the app bar only if
    /// [enableAlternativeUserMenu] is `true`.
    this.additionalActions = const [],

    /// [backgroundColor] is the background color of the app bar.
    /// Overrides the default background color from `Theme.of(context).scaffoldBackgroundColor`.
    this.backgroundColor,

    /// [asTaskBar] is a boolean that indicates if the app bar is used as a task bar.
    this.asTaskBar = false,

    /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
    /// By default is `Navigator.of(context).pushNamed`
    this.onNavigatorPush,

    /// [onNavigatorPop] is the callback to be executed when the back button is tapped.
    /// By default is `Navigator.of(context).pop`
    this.onNavigatorPop,
  });

  @override
  State<ThemedAppBarAvatar> createState() => _ThemedAppBarAvatarState();
}

class _ThemedAppBarAvatarState extends State<ThemedAppBarAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;
  final GlobalKey _userMenuKey = GlobalKey();
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  final FocusNode _focusNode = FocusNode();

  ThemedNavigatorPushFunction get onNavigatorPush =>
      widget.onNavigatorPush ?? (path) => Navigator.of(context).pushNamed(path);
  ThemdNavigatorPopFunction get onNavigatorPop => widget.onNavigatorPop ?? Navigator.of(context).pop;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: kHoverDuration);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _userMenuKey,
      onTap: _createOverlay,
      child: Tooltip(
        message: widget.userName,
        child: drawAvatar(
          context: context,
          size: 30,
          radius: widget.asTaskBar ? 5 : 30,
          name: widget.userName,
          dynamicAvatar: widget.userDynamicAvatar,
        ),
      ),
    );
  }

  Future<void> _createOverlay() async {
    if (_overlayEntry != null) {
      return;
    }

    List<ThemedNavigatorItem> actions = [
      ...widget.additionalActions,
      if (widget.enableAbout)
        ThemedNavigatorAction(
          labelText: i18n?.t('layrz.taskbar.about') ?? 'About',
          icon: MdiIcons.informationOutline,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ThemedLicensesView(
                  companyName: widget.companyName,
                  logo: widget.logo,
                  version: widget.version,
                ),
              ),
            );
          },
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

    RenderBox renderBox = _userMenuKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size size = renderBox.size;
    EdgeInsets padding = MediaQuery.of(context).padding;

    double? top = offset.dy + size.height + padding.top + 5;
    double? right = padding.right + 10;

    double? bottom;
    double? left;

    double width = MediaQuery.of(context).size.width * 0.4;
    if (width > 250) {
      width = 250;
    }

    if (widget.asTaskBar) {
      top = null;
      right = null;
      bottom = padding.bottom + ThemedTaskbar.height + 10;
      left = padding.left + 10;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(child: GestureDetector(onTap: _destroyOverlay)),
              Positioned(
                top: top,
                right: right,
                bottom: bottom,
                left: left,
                child: RawKeyboardListener(
                  focusNode: _focusNode,
                  onKey: (event) {
                    if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
                      _destroyOverlay();
                    }
                  },
                  child: ScaleTransition(
                    scale: _animationController,
                    alignment: widget.asTaskBar ? Alignment.bottomLeft : Alignment.topRight,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          constraints: BoxConstraints(maxWidth: width, minWidth: 150),
                          padding: const EdgeInsets.all(10),
                          decoration: generateContainerElevation(
                            context: context,
                            elevation: 3,
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => const Divider(),
                            itemCount: actions.length,
                            itemBuilder: (context, index) {
                              return actions[index].toDrawerItem(
                                context: context,
                                callback: _destroyOverlay,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                onNavigatorPop: onNavigatorPop,
                                onNavigatorPush: onNavigatorPush,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);

    await _animationController.forward();
    _focusNode.requestFocus();
  }

  Future<void> _destroyOverlay() async {
    _focusNode.unfocus();
    await _animationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }
}
