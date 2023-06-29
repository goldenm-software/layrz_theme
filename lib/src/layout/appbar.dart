part of layrz_theme;

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
  final Avatar? userAvatar;

  final bool enableAbout;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoutTap;

  final bool isDesktop;

  final bool enableAlternativeUserMenu;

  final List<ThemedNavigatorItem> additionalActions;

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

    /// [enableAbout], [onSettingsTap], [onProfileTap] and [onLogoutTap] are
    /// enablers of about, settings, profile and logout buttons and pages.
    this.enableAbout = true,
    this.onSettingsTap,
    this.onProfileTap,
    this.onLogoutTap,

    /// [appTitle] is the title of the app.
    required this.appTitle,

    /// [companyName] is the name of the company.
    this.companyName = 'Golden M, Inc',

    /// [logo] and [favicon] is the logo of the app. Can be a path or a url.
    required this.logo,
    required this.favicon,

    /// [userName] is the name of the user.
    this.userName = "Golden M",

    /// [userAvatar] is the dynamic avatar of the user.
    /// In other components like `ThemedDrawer`, the prop is `ThemedDrawer.userDynamicAvatar`.
    this.userAvatar,

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
  });

  static Size get size => const Size.fromHeight(55);

  @override
  Size get preferredSize => size;

  @override
  State<ThemedAppBar> createState() => _ThemedAppBarState();
}

class _ThemedAppBarState extends State<ThemedAppBar> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> get scaffoldKey => widget.scaffoldKey;
  final GlobalKey _userMenuKey = GlobalKey();
  List<ThemedNavigatorItem> get items => widget.items;
  String get homePath => widget.homePath;
  bool get disableLeading => widget.disableLeading;
  String get appTitle => widget.appTitle;
  AppThemedAsset get logo => widget.logo;
  AppThemedAsset get favicon => widget.favicon;
  String? get version => widget.version;

  Size get preferredSize => widget.preferredSize;

  bool get isMacOS => !kIsWeb && Platform.isMacOS;
  bool get isIOS => !kIsWeb && Platform.isIOS;

  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;

  String get path => ModalRoute.of(context)?.settings.name ?? "";
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  double get width => MediaQuery.of(context).size.width;
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get drawerColor => isDark ? Colors.grey.shade900 : Theme.of(context).primaryColor;
  Color get itemColor => isDark ? Colors.white : Theme.of(context).primaryColor;
  String get logoUri => !isDark ? logo.normal : logo.white;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: kHoverDuration);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double availableSize = width - 40;
    Widget logoWidget = ThemedImage(
      path: logoUri,
      width: 100,
      height: 30,
    );

    logoWidget = Padding(
      padding: const EdgeInsets.all(10),
      child: ThemedImage(
        path: logoUri,
        width: 100,
        height: 30,
      ),
    );

    availableSize -= 120;

    if (isMacOS) {
      availableSize -= 20;

      if (path != homePath) {
        availableSize += 40;
      }
    }

    if (!disableLeading) {
      if (path != homePath) {
        availableSize -= 100;
      }
    }
    availableSize -= 40;

    if (widget.enableAlternativeUserMenu) {
      availableSize -= 50;
    }

    List<Widget> buttons = items.map(_parseNavigatorItem).toList();

    return Container(
      decoration: generateContainerElevation(
        context: context,
        elevation: 1,
        radius: 0,
        reverse: true,
      ),
      child: AppBar(
        systemOverlayStyle: Scaffold.of(context).isDrawerOpen && isIOS
            ? SystemUiOverlayStyle(
                statusBarIconBrightness: useBlack(color: drawerColor) ? Brightness.light : Brightness.dark,
                statusBarBrightness: useBlack(color: drawerColor) ? Brightness.light : Brightness.dark,
                systemNavigationBarIconBrightness: useBlack(color: drawerColor) ? Brightness.light : Brightness.dark,
              )
            : null,
        title: path == homePath
            ? logoWidget
            : MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  child: logoWidget,
                  onTap: () => Navigator.of(context).pushNamed(homePath),
                ),
              ),
        automaticallyImplyLeading: disableLeading ? false : path != homePath,
        leadingWidth: isMacOS ? 135 : null,
        leading: disableLeading
            ? null
            : width < kSmallGrid
                ? Row(
                    children: [
                      if (isMacOS) ...[
                        const SizedBox(width: 80),
                      ],
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: IconButton(
                          icon: Icon(
                            MdiIcons.dotsVertical,
                            size: 25,
                            color: itemColor,
                          ),
                          onPressed: () {
                            if (scaffoldKey.currentState != null) {
                              scaffoldKey.currentState?.openDrawer();
                            } else {
                              Scaffold.of(context).openDrawer();
                            }
                          },
                        ),
                      ),
                    ],
                  )
                : path != homePath
                    ? Row(
                        children: [
                          if (isMacOS) ...[
                            const SizedBox(width: 80),
                          ],
                          SizedBox(
                            width: 55,
                            height: 55,
                            child: InkWell(
                              child: Icon(
                                MdiIcons.chevronLeft,
                                size: 25,
                                color: itemColor,
                              ),
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      )
                    : null,
        actions: width >= kSmallGrid
            ? [
                SizedBox(
                  width: availableSize, // 120 of the logo + 40 of the user menu + 40 of margins
                  height: preferredSize.height,
                  child: SingleChildScrollView(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: buttons,
                    ),
                  ),
                ),
                if (widget.enableAlternativeUserMenu) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15).add(const EdgeInsets.only(right: 10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(preferredSize.height ~/ 10, (_) {
                        return Container(
                          width: 2,
                          height: 2,
                          decoration: BoxDecoration(
                            color: itemColor.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  ),
                  InkWell(
                    key: _userMenuKey,
                    onTap: _createOverlay,
                    child: Tooltip(
                      message: widget.userName,
                      child: drawAvatar(
                        context: context,
                        size: 30,
                        name: widget.userName,
                        dynamicAvatar: widget.userAvatar,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ]
            : null,
      ),
    );
  }

  Future<void> _createOverlay() async {
    if (_overlayEntry != null) {
      return;
    }

    List<Widget> actions = [
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
                  version: version,
                ),
              ),
            );
          },
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
    ].map(_parseNavigatorItemAsListTile).toList();

    RenderBox renderBox = _userMenuKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size size = renderBox.size;

    double top = offset.dy + size.height + 5;
    double right = 10;

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
                width: 180,
                child: ScaleTransition(
                  scale: _animationController,
                  alignment: Alignment.topRight,
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: generateContainerElevation(
                          context: context,
                          radius: 5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: actions,
                        ),
                      );
                    },
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
  }

  Future<void> _destroyOverlay() async {
    await _animationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  Widget _parseNavigatorItem(ThemedNavigatorItem item) {
    String path = ModalRoute.of(context)?.settings.name ?? "";
    if (item is ThemedNavigatorSeparator) {
      if (item.type == ThemedSeparatorType.line) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: VerticalDivider(
            color: itemColor.withOpacity(0.5),
            width: 0,
            thickness: 1,
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(preferredSize.height ~/ 10, (_) {
            return Container(
              width: 2,
              height: 2,
              decoration: BoxDecoration(
                color: itemColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      );
    }

    if (item is ThemedNavigatorLabel) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: item.label ??
            Text(
              item.labelText ?? "",
              style: TextStyle(
                color: itemColor,
                fontSize: 14,
              ),
            ),
      );
    }

    if (item is ThemedNavigatorAction) {
      bool highlight = item.highlight;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: (preferredSize.height - 25) * 0.2),
        child: ThemedButton(
          style: highlight ? ThemedButtonStyle.filledTonal : ThemedButtonStyle.text,
          icon: item.icon,
          label: item.label,
          labelText: item.labelText,
          onTap: highlight ? null : item.onTap,
          color: itemColor,
        ),
      );
    }

    if (item is ThemedNavigatorPage) {
      bool highlight = path.startsWith(item.path);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: (preferredSize.height - 25) * 0.2),
        child: ThemedButton(
          style: highlight ? ThemedButtonStyle.filledTonal : ThemedButtonStyle.text,
          icon: item.icon,
          label: item.label,
          labelText: item.labelText,
          onTap: () {
            if (!highlight) {
              Navigator.of(context).pushNamed(item.path);
            }
          },
          color: itemColor,
        ),
      );
    }

    return const SizedBox();
  }

  Widget _parseNavigatorItemAsListTile(ThemedNavigatorItem item) {
    String path = ModalRoute.of(context)?.settings.name ?? "";
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5);
    if (item is ThemedNavigatorSeparator) {
      if (item.type == ThemedSeparatorType.line) {
        return Padding(
          padding: padding,
          child: Divider(color: Theme.of(context).dividerColor),
        );
      }

      return Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(30, (_) {
            return Container(
              width: 2,
              height: 2,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      );
    }

    if (item is ThemedNavigatorLabel) {
      return Container(
        width: double.infinity,
        padding: padding,
        child: item.label ??
            Text(
              item.labelText ?? "",
              textAlign: TextAlign.justify,
            ),
      );
    }

    if (item is ThemedNavigatorAction) {
      bool highlight = item.highlight;
      return InkWell(
        onTap: highlight
            ? null
            : () {
                _destroyOverlay();
                item.onTap.call();
              },
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(item.icon),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  item.labelText ?? "",
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (item is ThemedNavigatorPage) {
      bool highlight = path.startsWith(item.path);
      return InkWell(
        onTap: highlight
            ? null
            : () {
                _destroyOverlay();
                Navigator.of(context).pushNamed(item.path);
              },
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              if (item.icon != null) ...[
                Icon(item.icon),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  item.labelText ?? "",
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
