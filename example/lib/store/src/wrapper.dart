part of store;

class Layout extends StatefulWidget {
  final Widget body;

  const Layout({super.key, required this.body});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  AppStore get store => VxState.store as AppStore;
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
      style: ThemedLayoutStyle.mini,
      mobileStyle: ThemedMobileLayoutStyle.bottomBar,
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
          icon: MdiIcons.homeVariant,
          // showHeaderInSidebarMode: false,
        ),
        ThemedNavigatorPage(
          labelText: 'Theme generation',
          path: '/theme',
          icon: MdiIcons.themeLightDark,
          showHeaderInSidebarMode: false,
        ),
        ThemedNavigatorPage(
          labelText: 'Inputs',
          path: '/inputs',
          icon: MdiIcons.text,
          children: [
            ThemedNavigatorPage(
              labelText: 'Text fields',
              path: '/inputs/text',
              icon: MdiIcons.text,
            ),
            ThemedNavigatorPage(
              labelText: 'Buttons',
              path: '/inputs/buttons',
              icon: MdiIcons.buttonCursor,
            ),
            ThemedNavigatorPage(
              labelText: 'Checkboxes',
              path: '/inputs/checkboxes',
              icon: MdiIcons.checkboxBlank,
            ),
            ThemedNavigatorPage(
              labelText: 'Radio buttons',
              path: '/inputs/radiobuttons',
              icon: MdiIcons.radioboxMarked,
            ),
            ThemedNavigatorPage(
              labelText: 'Selectors',
              path: '/inputs/selectors',
              icon: MdiIcons.listBox,
              children: [
                ThemedNavigatorPage(
                  labelText: 'General selectors',
                  path: '/inputs/selectors/general',
                  icon: MdiIcons.calendarClock,
                ),
                ThemedNavigatorPage(
                  labelText: 'Date & Time selectors',
                  path: '/inputs/selectors/datetime',
                  icon: MdiIcons.calendarClock,
                ),
              ],
            ),
            ThemedNavigatorPage(
              labelText: 'Calendar',
              path: '/inputs/calendar',
              icon: MdiIcons.calendar,
            ),
          ],
        ),
        ThemedNavigatorPage(
          labelText: 'Layo',
          path: '/layo',
          icon: MdiIcons.robotOutline,
        ),
        ThemedNavigatorPage(
          labelText: 'Avatars',
          path: '/avatars',
          icon: MdiIcons.accountCircleOutline,
          useDefaultRedirect: false,
          children: [
            ThemedNavigatorPage(
              labelText: 'Static avatars',
              path: '/avatars/static',
              icon: MdiIcons.accountCircle,
            ),
            ThemedNavigatorPage(
              labelText: 'Dynamic avatars',
              path: '/avatars/dynamic',
              icon: MdiIcons.accountCircleOutline,
            ),
          ],
        ),
      ],
      persistentItems: [
        ThemedNavigatorAction(
          labelText: 'onTap action',
          icon: MdiIcons.calendar,
          onTap: () {
            debugPrint('onTap action');
          },
        ),
        ThemedNavigatorAction(
          labelText: "GitHub repository",
          icon: MdiIcons.github,
          onTap: () => launchUrlString(
            'https://github.com/goldenm-software/layrz_theme',
            mode: LaunchMode.externalApplication,
          ),
        ),
        ThemedNavigatorAction(
          labelText: "Our discord",
          icon: MdiIcons.messageBadgeOutline,
          onTap: () => launchUrlString(
            'https://discord.gg/tv56VVDYqf',
            mode: LaunchMode.externalApplication,
          ),
        ),
      ],
      additionalActions: [
        ThemedNavigatorPage(
          labelText: 'Layo',
          path: '/layo',
          icon: MdiIcons.robotOutline,
        ),
        ThemedNavigatorLabel(labelText: 'Test'),
        ThemedNavigatorSeparator(),
        ThemedNavigatorLabel(labelText: 'Test'),
        ThemedNavigatorSeparator(type: ThemedSeparatorType.dots),
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
