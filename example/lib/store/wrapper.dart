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
          icon: LayrzIcons.solarOutlineHomeAngle,
          // showHeaderInSidebarMode: false,
        ),
        ThemedNavigatorPage(
          labelText: 'Colorblind modes',
          path: '/colorblind',
          icon: LayrzIcons.solarOutlinePalette,
        ),
        ThemedNavigatorPage(
          labelText: 'Theme generation',
          path: '/theme',
          icon: LayrzIcons.solarOutlineMoonFog,
          enableBreadcumb: false,
        ),
        ThemedNavigatorPage(
          labelText: 'Inputs',
          path: '/inputs',
          icon: LayrzIcons.solarOutlineTextFieldFocus,
          children: [
            ThemedNavigatorPage(
              labelText: 'Text fields',
              path: '/inputs/text',
              icon: LayrzIcons.solarOutlineTextFieldFocus,
            ),
            ThemedNavigatorPage(
              labelText: 'Buttons',
              path: '/inputs/buttons',
              icon: LayrzIcons.solarOutlineCursorSquare,
            ),
            ThemedNavigatorPage(
              labelText: 'Checkboxes',
              path: '/inputs/checkboxes',
              icon: LayrzIcons.solarOutlineCheckSquare,
            ),
            ThemedNavigatorPage(
              labelText: 'Radio buttons',
              path: '/inputs/radiobuttons',
              icon: LayrzIcons.solarOutlinePinCircle,
            ),
            ThemedNavigatorPage(
              labelText: 'Chips',
              path: '/inputs/chips',
              icon: LayrzIcons.solarOutlineTag,
            ),
            ThemedNavigatorPage(
              labelText: 'Selectors',
              path: '/inputs/selectors',
              icon: LayrzIcons.solarOutlineChecklistMinimalistic,
              children: [
                ThemedNavigatorPage(
                  labelText: 'General selectors',
                  path: '/inputs/selectors/general',
                  icon: LayrzIcons.solarOutlinePostsCarouselVertical,
                ),
                ThemedNavigatorPage(
                  labelText: 'Date & Time selectors',
                  path: '/inputs/selectors/datetime',
                  icon: LayrzIcons.solarOutlineCalendarSearch,
                ),
              ],
            ),
            ThemedNavigatorPage(
              labelText: 'Calendar',
              path: '/inputs/calendar',
              icon: LayrzIcons.solarOutlineCalendar,
            ),
          ],
        ),
        ThemedNavigatorPage(
          labelText: 'Layo',
          path: '/layo',
          icon: LayrzIcons.solarOutlineFaceScanSquare,
        ),
        ThemedNavigatorPage(
          labelText: 'Avatars',
          path: '/avatars',
          icon: LayrzIcons.solarOutlineUser,
          useDefaultRedirect: false,
          children: [
            ThemedNavigatorPage(
              labelText: 'Static avatars',
              path: '/avatars/static',
              icon: LayrzIcons.solarOutlineUserId,
            ),
            ThemedNavigatorPage(
              labelText: 'Dynamic avatars',
              path: '/avatars/dynamic',
              icon: LayrzIcons.solarOutlineUserPlus,
            ),
          ],
        ),
        ThemedNavigatorPage(
          labelText: 'Table',
          path: '/table',
          useDefaultRedirect: false,
          icon: LayrzIcons.solarOutlineSliderMinimalisticHorizontal,
          children: [
            ThemedNavigatorPage(
              labelText: 'Basic table',
              path: '/table/basic',
              icon: LayrzIcons.solarOutlineSliderMinimalisticHorizontal,
            ),
            ThemedNavigatorPage(
              labelText: 'Infinite table',
              path: '/table/infinite',
              icon: LayrzIcons.solarOutlineDocumentsMinimalistic,
            ),
          ],
        ),
        ThemedNavigatorPage(
          labelText: 'Snackbars',
          path: '/snackbar/basic',
          icon: LayrzIcons.solarOutlineTagHorizontal,
        ),
        ThemedNavigatorPage(
          labelText: 'Alerts and Chips',
          path: '/alerts',
          icon: LayrzIcons.solarOutlineDanger,
        ),
      ],
      persistentItems: [
        ThemedNavigatorAction(
          labelText: "GitHub repository",
          icon: LayrzIcons.mdiGithub,
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
