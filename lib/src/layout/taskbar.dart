part of layrz_theme;

class ThemedTaskbar extends StatefulWidget {
  final List<ThemedNavigatorItem> items;
  final List<ThemedNavigatorItem> persistentItems;
  final bool hideActions;

  final String appTitle;
  final String companyName;
  final AppThemedAsset logo;
  final AppThemedAsset favicon;
  final String? version;

  final String userName;
  final String? userAvatar;
  final Avatar? userDynamicAvatar;

  final List<SearchEntity> entities;
  final void Function(SearchEntity)? onEntityTap;

  final bool enableAbout;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoutTap;

  const ThemedTaskbar({
    super.key,
    required this.items,
    this.persistentItems = const [],
    this.hideActions = false,

    /// [appTitle] is the title of the app.
    required this.appTitle,

    /// [companyName] is the name of the company.
    this.companyName = 'Golden M, Inc',

    /// [logo] and [favicon] is the logo of the app. Can be a path or a url.
    required this.logo,
    required this.favicon,

    /// [version] is the version of the app.
    this.version,

    /// [userName] is the name of the user.
    this.userName = "Golden M",

    /// [userAvatar] is the avatar of the user. Can be a path or a url.
    this.userAvatar,

    /// [userDynamicAvatar] is the dynamic avatar of the user.
    this.userDynamicAvatar,

    /// [entities] is the list of entities to be listed on menu button.
    /// [onEntityTap] is the function to be called when tapping an entity.
    this.entities = const [],
    this.onEntityTap,

    /// [enableAbout], [onSettingsTap], [onProfileTap] and [onLogoutTap] are
    /// enablers of about, dark mode, settings, profile and logout buttons and pages.
    this.enableAbout = true,
    this.onSettingsTap,
    this.onProfileTap,
    this.onLogoutTap,
  });

  @override
  State<ThemedTaskbar> createState() => _ThemedTaskbarState();
}

class _ThemedTaskbarState extends State<ThemedTaskbar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? timer;
  DateTime now = DateTime.now();
  int easterEgg = 0;
  String? get version => widget.version;
  late ConfettiController _easterEggController;
  AppThemedAsset get logo => widget.logo;
  AppThemedAsset get favicon => widget.favicon;

  static double get taskbarSize => 60;
  double get _buttonHeight => taskbarSize - 25;
  Duration get _animationDuration => const Duration(milliseconds: 100);

  late OverlayState _menuState;
  OverlayEntry? _menuOverlay;
  bool isMenuHovered = false;
  String test = "Hola mundo";

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    _menuState = Overlay.of(context);

    _easterEggController = ConfettiController(
      duration: const Duration(seconds: 10),
    );

    timer = Timer.periodic(const Duration(seconds: 30), (Timer timer) {
      setState(() {
        now = DateTime.now();
      });
    });
    super.initState();
  }

  void _buildMenu() {
    _menuOverlay = _buildMenuOverlay();
    _animationController.addListener(() {
      _menuState.setState(() {});
    });
    _animationController.forward();

    _menuState.insert(_menuOverlay!);
    setState(() {});
  }

  void _destroyMenu() async {
    _animationController.reverse();
    await Future.delayed(_animationDuration);
    _menuOverlay?.remove();
    _menuOverlay = null;
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    _easterEggController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    String path = ModalRoute.of(context)?.settings.name ?? "";
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color appBarColor = isDark ? Theme.of(context).appBarTheme.backgroundColor! : Colors.white;
    Color itemColor = validateColor(color: appBarColor);
    double width = MediaQuery.of(context).size.width;

    bool isSmall = width <= kSmallGrid;

    if (!isDark) {
      itemColor = Theme.of(context).primaryColor;
    }

    if (!widget.hideActions) {
      if (widget.persistentItems.isNotEmpty) {
        items.addAll(generateButtons(
          items: widget.persistentItems,
          path: path,
          itemColor: itemColor,
          isSmall: isSmall,
        ));

        if (widget.items.isNotEmpty) {
          items.addAll(generateButtons(
            items: [ThemedNavigatorSeparator()],
            path: path,
            itemColor: itemColor,
            isSmall: isSmall,
          ));
        }
      }

      if (widget.items.isNotEmpty) {
        items.addAll(generateButtons(
          items: widget.items,
          path: path,
          itemColor: itemColor,
          isSmall: isSmall,
        ));
      }
    }

    return Container(
      width: double.infinity,
      decoration: generateContainerElevation(
        context: context,
        elevation: 1,
        radius: 0,
      ),
      child: SafeArea(
        child: SizedBox(
          height: taskbarSize,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5).add(const EdgeInsets.only(left: 10)),
            child: Row(
              children: [
                if (!isSmall) ...generateMenuButton(),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: items,
                    ),
                  ),
                ),
                if (!isSmall) ...[
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: generateDateSegment(),
                  ),
                  const SizedBox(width: 10),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _buildMenuOverlay() {
    Size size = MediaQuery.of(context).size;
    double height = size.height / 3 * 2;
    double width = 600;
    double availableHeight = size.height - taskbarSize - ThemedAppBar.size.height;

    if (availableHeight < height) {
      height = availableHeight * 0.8;
    }

    if (size.width < width) {
      width = size.width * 0.8;
    }

    return OverlayEntry(
      builder: (context) {
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    _destroyMenu();
                  },
                ),
              ),
              Positioned(
                bottom: taskbarSize + 10,
                left: 10,
                child: Column(
                  children: [
                    FadeTransition(
                      opacity: Tween<double>(begin: 0, end: 1).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: TaskbarMenu(
                            width: width,
                            height: height,
                            userName: widget.userName,
                            userAvatar: widget.userAvatar,
                            userDynamicAvatar: widget.userDynamicAvatar,
                            enableAbout: widget.enableAbout,
                            onSettingsTap: widget.onSettingsTap,
                            onProfileTap: widget.onProfileTap,
                            onLogoutTap: widget.onLogoutTap,
                            appTitle: widget.appTitle,
                            companyName: widget.companyName,
                            logo: widget.logo,
                            favicon: widget.favicon,
                            entities: widget.entities,
                            onEntityTap: widget.onEntityTap,
                            version: widget.version,
                            onHideTap: () {
                              _destroyMenu();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> generateMenuButton() {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);

    String message = i18n?.t("layrz.helpers.openMenu") ?? "Open menu";

    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color contentColot = isMenuHovered
        ? isDark
            ? Colors.grey.shade700
            : Colors.grey.shade300
        : Theme.of(context).appBarTheme.backgroundColor!;
    String logo = useBlack(color: contentColot) ? favicon.normal : favicon.white;

    return [
      Tooltip(
        message: message,
        child: MouseRegion(
          onEnter: (_) {
            if (!isMenuHovered) {
              setState(() => isMenuHovered = true);
            }
          },
          onExit: (_) {
            if (isMenuHovered) {
              setState(() => isMenuHovered = false);
            }
          },
          child: InkWell(
            // focusNode: _menuFocusNode,
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              if (_menuOverlay != null) {
                _destroyMenu();
              } else {
                _buildMenu();
              }
              // if (_menuFocusNode.hasFocus) {
              //   _menuFocusNode.unfocus();
              // } else {
              //   _menuFocusNode.requestFocus();
              // }
            },
            child: AnimatedContainer(
              duration: _animationDuration,
              width: _buttonHeight,
              height: _buttonHeight,
              decoration: BoxDecoration(
                color: contentColot,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: ThemedImage(
                  path: logo,
                  width: _buttonHeight - 10,
                  height: _buttonHeight - 10,
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
    ];
  }

  List<Widget> generateDateSegment() {
    TextStyle? theme = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: validateColor(color: Theme.of(context).appBarTheme.backgroundColor!),
        );

    return [
      Text(
        now.format(pattern: '%Y/%m/%d'),
        style: theme,
      ),
      Text(
        now.format(pattern: '%H:%M %p'),
        style: theme,
      ),
    ];
  }

  List<Widget> generateButtons({
    required List<ThemedNavigatorItem> items,
    required String path,
    required Color itemColor,
    required bool isSmall,
  }) {
    return items.map((item) {
      if (item is ThemedNavigatorSeparator) {
        if (item.type == ThemedSeparatorType.line) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: VerticalDivider(
              color: itemColor.withOpacity(0.5),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (_) {
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
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: item.label ??
              Text(
                item.labelText ?? "",
                style: Theme.of(context).textTheme.labelLarge,
              ),
        );
      }

      if (item is ThemedNavigatorAction) {
        bool highlight = item.highlight;
        Color highlightColor =
            Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: highlight ? highlightColor : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Tooltip(
            message: item.labelText ?? "",
            child: InkWell(
              onTap: highlight ? null : item.onTap,
              child: highlight
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.icon != null) ...[
                          Icon(
                            item.icon ?? MdiIcons.help,
                            color: highlight ? validateColor(color: highlightColor) : itemColor,
                          ),
                          if (!isSmall) const SizedBox(width: 5),
                        ],
                        if (!isSmall)
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: item.label ??
                                Text(
                                  item.labelText ?? "",
                                  style: TextStyle(
                                    color: validateColor(color: highlightColor),
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                          ),
                      ],
                    )
                  : item.label ??
                      Icon(
                        item.icon ?? MdiIcons.help,
                        color: highlight ? validateColor(color: highlightColor) : itemColor,
                      ),
            ),
          ),
        );
      } else if (item is ThemedNavigatorPage) {
        bool highlight = false;
        if (item.children.isEmpty) {
          highlight = path == item.path;
        } else {
          highlight = path.startsWith(item.path);
        }
        Color highlightColor =
            Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: highlight ? highlightColor : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Tooltip(
            message: item.labelText ?? "",
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(item.path);
              },
              child: highlight
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (item.icon != null) ...[
                          Icon(
                            item.icon ?? MdiIcons.help,
                            color: highlight ? validateColor(color: highlightColor) : itemColor,
                          ),
                          if (!isSmall) const SizedBox(width: 5),
                        ],
                        if (!isSmall)
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: item.label ??
                                Text(
                                  item.labelText ?? "",
                                  style: TextStyle(
                                    color: validateColor(color: highlightColor),
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                          ),
                      ],
                    )
                  : item.label ??
                      Icon(
                        item.icon ?? MdiIcons.help,
                        color: highlight ? validateColor(color: highlightColor) : itemColor,
                      ),
            ),
          ),
        );
      }

      return const SizedBox();
    }).toList();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}

enum SearchType {
  guides,
  devices,
  externalAccounts,
  users,
  tags,
  geofences,
  triggers,
  operations,
  actions,
  assets,
  charts,
  checkpoints,
  careProtocols,
  presets,
  inboundProtocols,
  inboundServices,
  outboundProtocols,
  outboundServices,
  reports,
  reportTemplates,
  workspaces,
}

class SearchEntity {
  final String id;
  final String name;
  final String? avatar;
  final IconData? icon;
  final Color? color;
  final SearchType type;

  SearchEntity({
    required this.id,
    required this.name,
    required this.type,
    this.avatar,
    this.icon,
    this.color,
  });
}
