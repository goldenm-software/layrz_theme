part of '../../layout.dart';

class ThemedAppBarAvatar extends StatefulWidget {
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

  /// [additionalActions] is the list of additional actions to be displayed in the app bar.
  /// By default is `[]`.
  final List<ThemedNavigatorItem> additionalActions;

  /// [backgroundColor] is the background color of the app bar.
  /// Overrides the default background color from `Theme.of(context).scaffoldBackgroundColor`.
  final Color? backgroundColor;

  /// [asTaskBar] is a boolean that indicates if the app bar is used as a task bar.
  final bool asTaskBar;

  /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
  /// By default is `Navigator.of(context).pushNamed`
  final ThemedNavigatorPushFunction? onNavigatorPush;

  /// [onNavigatorPop] is the callback to be executed when the back button is tapped.
  /// By default is `Navigator.of(context).pop`
  final ThemdNavigatorPopFunction? onNavigatorPop;

  /// Creates a [ThemedAppBarAvatar] widget.
  const ThemedAppBarAvatar({
    super.key,
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
    this.additionalActions = const [],
    this.backgroundColor,
    this.asTaskBar = false,
    this.onNavigatorPush,
    this.onNavigatorPop,
  });

  @override
  State<ThemedAppBarAvatar> createState() => _ThemedAppBarAvatarState();
}

class _ThemedAppBarAvatarState extends State<ThemedAppBarAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;
  final GlobalKey _userMenuKey = GlobalKey();
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
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
          elevation: 3,
          color: Theme.of(context).scaffoldBackgroundColor,
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
                child: KeyboardListener(
                  focusNode: _focusNode,
                  onKeyEvent: (event) {
                    if (event.logicalKey == LogicalKeyboardKey.escape) {
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
                          decoration: generateContainerElevation(context: context),
                          clipBehavior: Clip.antiAlias,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: actions.length,
                            itemBuilder: (context, index) {
                              final item = actions[index];

                              if (item is ThemedNavigatorLabel) {
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: item.label ??
                                      Text(
                                        item.labelText ?? '',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                );
                              }

                              if (item is ThemedNavigatorPage) {
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _destroyOverlay(onTap: () => item.onTap(onNavigatorPush)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          if (item.icon != null) ...[
                                            Icon(
                                              item.icon ?? MdiIcons.help,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 5),
                                          ],
                                          item.label ??
                                              Text(
                                                item.labelText ?? '',
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (item is ThemedNavigatorAction) {
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => _destroyOverlay(onTap: item.onTap),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          if (item.icon != null) ...[
                                            Icon(
                                              item.icon ?? MdiIcons.help,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 5),
                                          ],
                                          item.label ??
                                              Text(
                                                item.labelText ?? '',
                                                style: Theme.of(context).textTheme.bodyMedium,
                                              )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (item is ThemedNavigatorSeparator) {
                                if (item.type == ThemedSeparatorType.line) {
                                  return const Divider(indent: 5, endIndent: 5);
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(45, (_) {
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

  Future<void> _destroyOverlay({VoidCallback? onTap}) async {
    _focusNode.unfocus();
    await _animationController.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});

    onTap?.call();
  }
}
