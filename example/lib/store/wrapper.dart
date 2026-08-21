part of './store.dart';

class Layout extends StatefulWidget {
  final Widget body;

  const Layout({super.key, required this.body});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  AppStore get store => LayrzState.store as AppStore;
  ThemedLayoutStyle get layoutStyle => store.layoutStyle;

  AppThemedAsset get logo => const AppThemedAsset(
    normal: 'https://cdn.layrz.com/resources/com.layrz.one/logo/normal.svg',
    white: 'https://cdn.layrz.com/resources/com.layrz.one/logo/white.svg',
  );

  AppThemedAsset get favicon => const AppThemedAsset(
    normal: 'https://cdn.layrz.com/resources/com.layrz.one/favicon/normal.svg',
    white: 'https://cdn.layrz.com/resources/com.layrz.one/favicon/white.svg',
  );

  @override
  void initState() {
    super.initState();
    // setThemedSnackbarScaffoldKey(_scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    String path = "";

    try {
      path = GoRouterState.of(context).fullPath ?? "";
    } catch (_) {
      path = ModalRoute.of(context)?.settings.name ?? "";
    }

    return ThemedLayout(
      style: .sidebar,
      mobileStyle: .bottomBar,
      isBackEnabled: false,
      // style: layoutStyle,
      logo: logo,
      currentPath: path,
      favicon: favicon,
      appTitle: "Layrz Theme",
      enableNotifications: true,
      notifications: [
        ThemedNotificationItem(
          title: 'Notification title',
          content: 'Notification message',
          onTap: () {
            debugPrint('Notification tapped');
          },
        ),
        ThemedNotificationItem(
          title: 'Notification title',
          content: 'Notification message',
          onTap: () {
            debugPrint('Notification tapped');
          },
        ),
        ThemedNotificationItem(
          title: 'Notification title',
          content: 'Notification message',
          onTap: () {
            debugPrint('Notification tapped');
          },
        ),
      ],
      items: [
        ThemedNavigatorPage(
          labelText: 'Home',
          path: '/home',
          icon: MdiIcons.homeOutline,
          // showHeaderInSidebarMode: false,
        ),
        ThemedNavigatorPage(
          labelText: 'Colorblind modes',
          path: '/colorblind',
          icon: MdiIcons.paletteOutline,
        ),
        ThemedNavigatorPage(
          labelText: 'Theme generation',
          path: '/theme',
          icon: MdiIcons.weatherNight,
          enableBreadcumb: false,
        ),
        ThemedNavigatorPage(
          labelText: 'Inputs',
          path: '/inputs',
          icon: MdiIcons.formTextbox,
          children: [
            ThemedNavigatorPage(
              labelText: 'Text fields',
              path: '/inputs/text',
              icon: MdiIcons.formTextbox,
            ),
            ThemedNavigatorPage(
              labelText: 'Buttons',
              path: '/inputs/buttons',
              icon: MdiIcons.cursorDefaultOutline,
            ),
            ThemedNavigatorPage(
              labelText: 'Checkboxes',
              path: '/inputs/checkboxes',
              icon: MdiIcons.checkboxMarkedOutline,
            ),
            ThemedNavigatorPage(
              labelText: 'Radio buttons',
              path: '/inputs/radiobuttons',
              icon: MdiIcons.pinOutline,
            ),
            ThemedNavigatorPage(
              labelText: 'Chips',
              path: '/inputs/chips',
              icon: MdiIcons.tagOutline,
            ),
            ThemedNavigatorPage(
              labelText: 'Selectors',
              path: '/inputs/selectors',
              icon: MdiIcons.formatListChecks,
              children: [
                ThemedNavigatorPage(
                  labelText: 'General selectors',
                  path: '/inputs/selectors/general',
                  icon: MdiIcons.viewCarouselOutline,
                ),
                ThemedNavigatorPage(
                  labelText: 'Date & Time selectors',
                  path: '/inputs/selectors/datetime',
                  icon: MdiIcons.calendarSearchOutline,
                ),
              ],
            ),
            ThemedNavigatorPage(
              labelText: 'Calendar',
              path: '/inputs/calendar',
              icon: MdiIcons.calendarOutline,
            ),
          ],
        ),
        ThemedNavigatorPage(
          labelText: 'Layo',
          path: '/layo',
          icon: MdiIcons.faceRecognition,
        ),
        ThemedNavigatorPage(
          labelText: 'Avatars',
          path: '/avatars',
          icon: MdiIcons.accountOutline,
          useDefaultRedirect: false,
          children: [
            ThemedNavigatorPage(
              labelText: 'Static avatars',
              path: '/avatars/static',
              icon: MdiIcons.accountBoxOutline,
            ),
            ThemedNavigatorPage(
              labelText: 'Dynamic avatars',
              path: '/avatars/dynamic',
              icon: MdiIcons.accountPlusOutline,
            ),
          ],
        ),
        ThemedNavigatorPage(
          labelText: 'Table',
          path: '/table',
          useDefaultRedirect: false,
          icon: MdiIcons.tune,
          children: [
            ThemedNavigatorPage(
              labelText: 'Basic table',
              path: '/table/basic',
              icon: MdiIcons.tune,
            ),
            ThemedNavigatorPage(
              labelText: 'Infinite table',
              path: '/table/infinite',
              icon: MdiIcons.fileMultipleOutline,
            ),
          ],
        ),
        ThemedNavigatorPage(
          labelText: 'Tabs',
          path: '/tabs',
          useDefaultRedirect: false,
          icon: MdiIcons.album,
          children: [
            ThemedNavigatorPage(
              labelText: 'Basic tabs',
              path: '/tabs/basic',
              icon: MdiIcons.album,
            ),
            ThemedNavigatorPage(
              labelText: 'Advanced tabs',
              path: '/tabs/advanced',
              icon: MdiIcons.album,
            ),
          ],
        ),
        ThemedNavigatorPage(
          labelText: 'Snackbars',
          path: '/snackbar/basic',
          icon: MdiIcons.tagOutline,
        ),
        ThemedNavigatorPage(
          labelText: 'Alerts and Chips',
          path: '/alerts',
          icon: MdiIcons.alertCircleOutline,
        ),
        ThemedNavigatorPage(
          labelText: 'Responsive Row & Col',
          path: '/grid/responsive-row',
          icon: MdiIcons.viewGridOutline,
        ),
      ],
      persistentItems: [
        ThemedNavigatorAction(
          labelText: "GitHub repository",
          // ignore: deprecated_member_use — MDI deprecated its brand icons; no replacement exists for the GitHub logo
          icon: MdiIcons.github,
          onTap: () => launchUrlString(
            'https://github.com/goldenm-software/layrz_theme',
            mode: LaunchMode.externalApplication,
          ),
        ),
      ],

      userDynamicAvatar: const Avatar(
        type: AvatarType.url,
        url: 'https://cdn.layrz.com/resources/layo/layo2.png',
      ),
      version: '1.0.0',
      body: widget.body,
      enableAbout: true,
      onNavigatorPush: context.go,
      onNavigatorPop: context.pop,
      onThemeSwitchTap: () {
        if (Theme.of(context).brightness == Brightness.light) {
          SetTheme(ThemeMode.dark);
        } else {
          SetTheme(ThemeMode.light);
        }
      },
    );
  }
}
