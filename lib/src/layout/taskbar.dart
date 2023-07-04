part of layout;

class ThemedTaskbar extends StatefulWidget {
  final List<ThemedNavigatorItem> items;
  final List<ThemedNavigatorItem> persistentItems;
  final String appTitle;
  final String companyName;
  final AppThemedAsset logo;
  final AppThemedAsset favicon;
  final String? version;
  final String userName;
  final Avatar? userDynamicAvatar;
  final bool enableAbout;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoutTap;
  final Color? backgroundColor;
  final List<ThemedNotificationItem> notifications;
  final String dateFormat;
  final String timeFormat;

  /// [ThemedTaskbar] is the taskbar of the application.
  const ThemedTaskbar({
    super.key,

    /// [items] is the list of buttons to be displayed in the taskbar.
    required this.items,

    /// [persistentItems] is the list of buttons to be displayed in the taskbar.
    this.persistentItems = const [],

    /// [appTitle] is the title of the app.
    required this.appTitle,

    /// [companyName] is the name of the company.
    this.companyName = 'Golden M, Inc',

    /// [logo] is the logo of the app. Can be a path or a url.
    required this.logo,

    /// [favicon] is the favicon of the app. Can be a path or a url.
    required this.favicon,

    /// [version] is the version of the app.
    this.version,

    /// [userName] is the name of the user.
    this.userName = "Golden M",

    /// [userDynamicAvatar] is the dynamic avatar of the user.
    this.userDynamicAvatar,

    /// [enableAbout] is a boolean that enables the about button and page.
    this.enableAbout = true,

    /// [onSettingsTap] is a callback that is called when the settings button is
    this.onSettingsTap,

    /// [onProfileTap] is a callback that is called when the profile button is
    this.onProfileTap,

    /// [onLogoutTap] is a callback that is called when the logout button is
    this.onLogoutTap,

    /// [backgroundColor] is the background color of the taskbar.
    this.backgroundColor,

    /// [notifications] is the list of notifications to be displayed in the
    /// taskbar.
    this.notifications = const [],

    /// [dateFormat] is the format of the date.
    /// See https://strftime.org/ for more information.
    this.dateFormat = '%Y/%m/%d',

    /// [timeFormat] is the format of the time.
    /// See https://strftime.org/ for more information.
    this.timeFormat = '%H:%M %p',
  });

  @override
  State<ThemedTaskbar> createState() => _ThemedTaskbarState();
}

class _ThemedTaskbarState extends State<ThemedTaskbar> with TickerProviderStateMixin {
  late Timer _timer;
  late DateTime _now;
  Color get backgroundColor => widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  String get favicon => useBlack(color: backgroundColor) ? widget.favicon.normal : widget.favicon.white;
  List<ThemedNavigatorItem> get items => widget.items;
  List<ThemedNavigatorItem> get persistentItems => widget.persistentItems;
  List<ThemedNotificationItem> get notifications => widget.notifications;
  double get height => 55;

  /* 20 = Padding.vertical of main element and 16 = Padding.vertical of the container */
  double get menuSize => height - (20 + 16);

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
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).dividerColor,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    debugPrint('Logo tapped');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ThemedImage(
                      path: favicon,
                      width: menuSize,
                      height: menuSize,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.items
                      .map((item) => item.toHorizontalWidget(context: context, backgroundColor: backgroundColor))
                      .toList(),
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
            const SizedBox(width: 10),
            ThemedNotificationIcon(
              notifications: notifications,
              backgroundColor: backgroundColor,
            ),
          ],
        ),
      ),
    );
  }
}
