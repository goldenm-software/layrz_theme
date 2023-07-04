part of layout;

class ThemedDrawer extends StatefulWidget {
  final List<ThemedNavigatorItem> items;

  final bool enableAbout;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoutTap;

  final String appTitle;
  final String companyName;
  final AppThemedAsset logo;
  final AppThemedAsset favicon;
  final String userName;
  final String? userAvatar;
  final Avatar? userDynamicAvatar;
  final String? version;

  final double paddingAmplifier;

  final bool isDesktop;
  final List<ThemedNavigatorItem> additionalActions;

  const ThemedDrawer({
    super.key,

    /// [items] is the list of buttons to be displayed in the drawer.
    this.items = const [],

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

    /// [userAvatar] is the avatar of the user. Can be a path or a url.
    this.userAvatar,

    /// [userDynamicAvatar] is the dynamic avatar of the user.
    this.userDynamicAvatar,

    /// [version] is the version of the app.
    this.version,

    /// [paddingAmplifier] is the padding amplifier of the drawer.
    /// Only will affect when the children contains more children. By default is `7`.
    this.paddingAmplifier = 7,

    /// [isDesktop] is the flag to know if the drawer is in desktop mode.
    /// By default is `false`.
    /// If `true`, the drawer will be displayed as a drawer and enables the option to contract it
    this.isDesktop = false,

    /// [additionalActions] is the list of additional actions to be displayed in the drawer.
    /// This actions will be displayed before the about, settings, profile and logout buttons.
    this.additionalActions = const [],
  });

  @override
  State<ThemedDrawer> createState() => _ThemedDrawerState();
}

class _ThemedDrawerState extends State<ThemedDrawer> with TickerProviderStateMixin {
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

  bool isDrawerExpanded = true;

  @override
  void initState() {
    super.initState();
    _userExpandController = AnimationController(vsync: this, duration: kHoverDuration);

    if (widget.isDesktop) {
      SharedPreferences.getInstance().then((prefs) {
        isDrawerExpanded = prefs.getBool('layrz.drawer.expansion') ?? false;
        setState(() {});
      });
    } else {
      isDrawerExpanded = true;
    }
  }

  @override
  void dispose() {
    _userExpandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color drawerColor = isDark ? Colors.grey.shade900 : Theme.of(context).primaryColor;

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
                  companyName: companyName,
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
    ];

    Color sidebarTextColor = validateColor(color: drawerColor);

    return Container(
      width: isDrawerExpanded ? 270 : 65,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: generateContainerElevation(
        context: context,
        radius: 0,
        color: drawerColor,
      ).copyWith(
        color: drawerColor,
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
                InkWell(
                  onTap: widget.isDesktop && !isDrawerExpanded
                      ? () {
                          setState(() => isDrawerExpanded = !isDrawerExpanded);
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setBool('layrz.drawer.expansion', isDrawerExpanded);
                          });
                        }
                      : null,
                  child: ThemedImage(
                    path: useBlack(color: drawerColor) ? widget.favicon.normal : widget.favicon.white,
                    width: 25,
                    height: 25,
                  ),
                ),
                if (isDrawerExpanded) ...[
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
                  if (!isMobile) ...[
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        setState(() => isDrawerExpanded = !isDrawerExpanded);
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setBool('layrz.drawer.expansion', isDrawerExpanded);
                        });
                      },
                      child: Icon(
                        MdiIcons.menuOpen,
                        color: sidebarTextColor,
                      ),
                    ),
                  ],
                ],
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: sidebarTextColor.withOpacity(0.2)),
            const SizedBox(height: 10),
            InkWell(
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
                    color: validateColor(color: drawerColor),
                  ),
                  if (isDrawerExpanded) ...[
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
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _userExpandController,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    ...actions.map((action) {
                      return ThemedDrawerItem(
                        item: action,
                        drawerColor: drawerColor,
                        paddingAmplifier: widget.paddingAmplifier,
                        isDrawerExpanded: isDrawerExpanded,
                      );
                    }).toList(),
                  ],
                ),
              ),
              builder: (BuildContext context, Widget? child) {
                double originalHeight = (47 * actions.length) + 10;

                return SizedBox(
                  height: _userExpandController.value * originalHeight,
                  child: child,
                );
              },
            ),
            const SizedBox(height: 10),
            Divider(color: sidebarTextColor.withOpacity(0.2)),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    ...widget.items.map((page) {
                      return ThemedDrawerItem(
                        item: page,
                        children: (page is ThemedNavigatorPage) ? page.children : [],
                        drawerColor: drawerColor,
                        paddingAmplifier: widget.paddingAmplifier,
                        isDrawerExpanded: isDrawerExpanded,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (widget.version != null) ...[
              Divider(color: sidebarTextColor.withOpacity(0.2)),
              InkWell(
                onTap: () {
                  openInfoDialog(
                    context: context,
                    appTitle: widget.appTitle,
                    i18n: i18n,
                    companyName: widget.companyName,
                    logo: isDark ? widget.favicon.white : widget.favicon.normal,
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

class ThemedDrawerItem extends StatefulWidget {
  final ThemedNavigatorItem item;
  final List<ThemedNavigatorItem> children;
  final int depth;
  final Color drawerColor;
  final double paddingAmplifier;
  final bool isDrawerExpanded;

  const ThemedDrawerItem({
    super.key,
    required this.item,
    this.children = const [],
    this.depth = 0,
    required this.drawerColor,
    required this.paddingAmplifier,
    required this.isDrawerExpanded,
  });

  @override
  State<ThemedDrawerItem> createState() => _ThemedDrawerItemState();
}

class _ThemedDrawerItemState extends State<ThemedDrawerItem> with TickerProviderStateMixin {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _controller;
  bool _isExpanded = false;
  bool _isHover = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: kHoverDuration,
    );
    Future.delayed(Duration.zero, () {
      String currentPath = ModalRoute.of(context)?.settings.name ?? '';
      bool isActive = false;

      if (widget.item is ThemedNavigatorPage) {
        ThemedNavigatorPage page = widget.item as ThemedNavigatorPage;
        isActive = currentPath.startsWith(page.path);
      }

      _controller.value = isActive ? 1 : 0;
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item is ThemedNavigatorSeparator) {
      ThemedNavigatorSeparator separator = widget.item as ThemedNavigatorSeparator;
      if (separator.type == ThemedSeparatorType.line) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Divider(color: validateColor(color: widget.drawerColor).withOpacity(0.2)),
        );
      }

      if (separator.type == ThemedSeparatorType.dots) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.isDrawerExpanded ? 40 : 10, (_) {
              return Container(
                width: 2,
                height: 2,
                decoration: BoxDecoration(
                  color: validateColor(color: widget.drawerColor).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        );
      }
    }

    String currentPath = ModalRoute.of(context)?.settings.name ?? '';

    bool isActive = false;

    if (widget.item is ThemedNavigatorPage) {
      isActive = currentPath.startsWith((widget.item as ThemedNavigatorPage).path);
    }

    Color contentColor = isActive
        ? isDark
            ? Colors.grey.shade900
            : Theme.of(context).primaryColor
        : validateColor(color: Theme.of(context).primaryColor);

    VoidCallback? onTap;

    if (widget.item is ThemedNavigatorPage) {
      onTap = () {
        Navigator.of(context).pushNamed((widget.item as ThemedNavigatorPage).path);
      };
    } else if (widget.item is ThemedNavigatorAction) {
      onTap = (widget.item as ThemedNavigatorAction).onTap;
    }

    IconData? icon;

    if (widget.item is ThemedNavigatorPage) {
      icon = (widget.item as ThemedNavigatorPage).icon;
    } else if (widget.item is ThemedNavigatorAction) {
      icon = (widget.item as ThemedNavigatorAction).icon;
    }

    Widget label = const Text("");

    if (widget.item is ThemedNavigatorPage) {
      label = (widget.item as ThemedNavigatorPage).label ??
          Text(
            (widget.item as ThemedNavigatorPage).labelText ?? "",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: contentColor,
                ),
          );
    } else if (widget.item is ThemedNavigatorAction) {
      label = (widget.item as ThemedNavigatorAction).label ??
          Text(
            (widget.item as ThemedNavigatorAction).labelText ?? "",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: contentColor,
                ),
          );
    }

    EdgeInsets offsetDepth = EdgeInsets.zero;

    if (widget.depth > 0) {
      offsetDepth =
          EdgeInsets.only(left: (widget.paddingAmplifier * (widget.isDrawerExpanded ? widget.depth : 0)).toDouble());
    }

    List<ThemedNavigatorItem> children = [];

    if (widget.item is ThemedNavigatorPage) {
      children = (widget.item as ThemedNavigatorPage).children;

      if (children.isNotEmpty) {
        onTap = () async {
          if (_isExpanded) {
            await _controller.reverse();
          } else {
            await _controller.forward();
          }
          setState(() => _isExpanded = !_isExpanded);
        };
      }
    }

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 3).add(offsetDepth),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onHover: (value) => setState(() => _isHover = value),
        onTap: onTap,
        child: AnimatedContainer(
          duration: kHoverDuration,
          padding: const EdgeInsets.all(10),
          decoration: generateContainerElevation(
            context: context,
            elevation: 0,
            radius: 5,
            color: isActive
                ? Colors.white
                : _isHover
                    ? Colors.white.withOpacity(0.4)
                    : isDark
                        ? Colors.grey.shade900
                        : Theme.of(context).primaryColor,
          ).copyWith(
            color: isActive
                ? Colors.white
                : isDark
                    ? Colors.grey.shade900
                    : Theme.of(context).primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: contentColor,
                  size: 18,
                ),
                if (widget.isDrawerExpanded) ...[const SizedBox(width: 10)],
              ] else if (!widget.isDrawerExpanded) ...[
                Icon(
                  MdiIcons.helpCircle,
                  color: contentColor,
                  size: 18,
                ),
              ],
              if (widget.isDrawerExpanded) ...[
                Expanded(
                  child: label,
                ),
                if (children.isNotEmpty) ...[
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * pi,
                        child: child,
                      );
                    },
                    child: Icon(
                      MdiIcons.chevronUp,
                      color: contentColor,
                      size: 18,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );

    String message = "";

    if (widget.item.labelText == null) {
      if (widget.item.label is Text) {
        message = (widget.item.label as Text).data ?? "";
      } else {
        message = "${widget.item.label}";
      }
    } else {
      message = widget.item.labelText!;
    }

    return Column(
      children: [
        if (widget.isDrawerExpanded) ...[
          content,
        ] else ...[
          Tooltip(
            message: message,
            child: content,
          ),
        ],
        AnimatedBuilder(
          animation: _controller,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                ...children.map((page) {
                  return ThemedDrawerItem(
                    item: page,
                    depth: widget.depth + 1,
                    drawerColor: widget.drawerColor,
                    paddingAmplifier: widget.paddingAmplifier,
                    isDrawerExpanded: widget.isDrawerExpanded,
                  );
                }).toList(),
              ],
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            double originalHeight = 47;

            return SizedBox(
              height: children.length * originalHeight * _controller.value,
              child: child,
            );
          },
        ),
      ],
    );
  }
}
