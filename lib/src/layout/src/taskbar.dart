part of '../layout.dart';

class ThemedTaskbar extends StatefulWidget {
  /// [items] is the list of buttons to be displayed in the taskbar.
  final List<ThemedNavigatorItem> items;

  /// [persistentItems] is the list of buttons to be displayed in the taskbar.
  final List<ThemedNavigatorItem> persistentItems;

  /// [appTitle] is the title of the app.
  final String appTitle;

  /// [companyName] is the name of the company.
  final String companyName;

  /// [logo] is the logo of the app. Can be a path or a url.
  final AppThemedAsset logo;

  /// [favicon] is the favicon of the app. Can be a path or a url.
  final AppThemedAsset favicon;

  /// [version] is the version of the app.
  final String? version;

  /// [userName] is the name of the user.
  final String userName;

  /// [userDynamicAvatar] is the dynamic avatar of the user.
  final Avatar? userDynamicAvatar;

  /// [enableAbout] is a boolean that enables the about button and page.
  final bool enableAbout;

  /// [onSettingsTap] is a callback that is called when the settings button is
  final VoidCallback? onSettingsTap;

  /// [onProfileTap] is a callback that is called when the profile button is
  final VoidCallback? onProfileTap;

  /// [onLogoutTap] is a callback that is called when the logout button is
  final VoidCallback? onLogoutTap;

  /// [onThemeSwitchTap] is a callback that is called when the theme switch
  /// button is tapped.
  final VoidCallback? onThemeSwitchTap;

  /// [backgroundColor] is the background color of the taskbar.
  final Color? backgroundColor;

  /// [notifications] is the list of notifications to be displayed in the
  /// taskbar.
  final List<ThemedNotificationItem> notifications;

  /// [dateFormat] is the format of the date.
  /// See https://strftime.org/ for more information.
  final String dateFormat;

  /// [timeFormat] is the format of the time.
  /// See https://strftime.org/ for more information.
  final String timeFormat;

  /// [additionalActions] is the list of additional actions to be displayed in
  /// the taskbar.
  final List<ThemedNavigatorItem> additionalActions;

  /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
  /// By default is `Navigator.of(context).pushNamed`
  final ThemedNavigatorPushFunction? onNavigatorPush;

  /// [currentPath] is the current path of the navigator. Overrides the default path detection.
  /// By default, we get the current path from `ModalRoute.of(context)?.settings.name`.
  final String? currentPath;

  /// [enableNotifications] is a boolean that enables the notifications button and page.
  final bool enableNotifications;

  /// [onNavigatorPop] is the callback to be executed when a navigator item is popped.
  /// By default is `Navigator.of(context).pop`
  final ThemdNavigatorPopFunction? onNavigatorPop;

  /// [ThemedTaskbar] is the taskbar of the application.
  const ThemedTaskbar({
    super.key,
    required this.items,
    this.persistentItems = const [],
    required this.appTitle,
    this.companyName = 'Golden M, Inc',
    required this.logo,
    required this.favicon,
    this.version,
    this.userName = "Golden M",
    this.userDynamicAvatar,
    this.enableAbout = true,
    this.onSettingsTap,
    this.onProfileTap,
    this.onLogoutTap,
    this.onThemeSwitchTap,
    this.backgroundColor,
    this.notifications = const [],
    this.dateFormat = '%Y/%m/%d',
    this.timeFormat = '%H:%M %p',
    this.additionalActions = const [],
    this.onNavigatorPush,
    this.currentPath,
    this.enableNotifications = true,
    this.onNavigatorPop,
  });

  static double get height => 55;

  @override
  State<ThemedTaskbar> createState() => _ThemedTaskbarState();
}

class _ThemedTaskbarState extends State<ThemedTaskbar> with TickerProviderStateMixin {
  late Timer _timer;
  late DateTime _now;
  Color get backgroundColor => widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get activeColor => isDark ? Colors.white : Theme.of(context).primaryColor;
  String get favicon => useBlack(color: backgroundColor) ? widget.favicon.normal : widget.favicon.white;
  List<ThemedNavigatorItem> get items => widget.items;
  List<ThemedNavigatorItem> get persistentItems => widget.persistentItems;
  List<ThemedNotificationItem> get notifications => widget.notifications;
  ThemedNavigatorPushFunction get onNavigatorPush =>
      widget.onNavigatorPush ?? (path) => Navigator.of(context).pushNamed(path);
  ThemdNavigatorPopFunction get onNavigatorPop => widget.onNavigatorPop ?? Navigator.of(context).pop;

  String get currentPath => widget.currentPath ?? '';

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ThemedTaskbar.height,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
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
              asTaskBar: true,
              onThemeSwitchTap: widget.onThemeSwitchTap,
              onNavigatorPush: onNavigatorPush,
              onNavigatorPop: onNavigatorPop,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: persistentItems.length,
                      itemBuilder: (context, index) {
                        return _buildItem(persistentItems[index]);
                      },
                    ),
                    if (persistentItems.isNotEmpty && items.isNotEmpty) ...[
                      _buildItem(ThemedNavigatorSeparator()),
                    ],
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _buildItem(items[index]);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _now.format(pattern: '%H:%M %p'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  _now.format(pattern: '%Y/%m/%d'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (widget.enableNotifications) ...[
              const SizedBox(width: 10),
              ThemedNotificationIcon(
                notifications: notifications,
                backgroundColor: backgroundColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItem(ThemedNavigatorItem item) {
    if (item is ThemedNavigatorLabel) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: item.label ?? Text(item.labelText ?? ''),
      );
    }

    if (item is ThemedNavigatorPage) {
      if (item.children.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: item.children.length,
          itemBuilder: (context, index) {
            return _buildItem(item.children[index]);
          },
        );
      }
      bool highlight = currentPath.startsWith(item.path);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 4),
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
        margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 4),
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
          margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 4),
          child: const VerticalDivider(),
        );
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 4),
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
