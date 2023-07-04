part of layout;

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
  final Avatar? userDynamicAvatar;

  final bool enableAbout;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoutTap;

  final bool isDesktop;

  final bool enableAlternativeUserMenu;

  final List<ThemedNavigatorItem> additionalActions;

  final Color? backgroundColor;

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

    /// [backgroundColor] is the background color of the app bar.
    /// Overrides the default background color from `Theme.of(context).scaffoldBackgroundColor`.
    this.backgroundColor,
  });

  static Size get size => const Size.fromHeight(55);

  @override
  Size get preferredSize => size;

  @override
  State<ThemedAppBar> createState() => _ThemedAppBarState();
}

class _ThemedAppBarState extends State<ThemedAppBar> with TickerProviderStateMixin {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.of(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  String get logo => isDark ? widget.logo.white : widget.logo.normal;
  Color get backgroundColor => widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ThemedAppBar.size.height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: ThemedAppBar.size.height - 10,
            child: AspectRatio(
              aspectRatio: 1000 / 300, // 1000px X 300px - default dimensions of logos from Layrz
              child: ThemedImage(
                path: logo,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  children: widget.items
                      .map((item) => item.toHorizontalWidget(context: context, backgroundColor: backgroundColor))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
