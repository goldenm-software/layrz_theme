import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/empty.dart';
import 'package:layrz_theme_example/store.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Layout extends StatefulWidget {
  final bool showDrawer;
  final Widget body;

  const Layout({
    super.key,
    required this.showDrawer,
    required this.body,
  });

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  bool get showDrawer => widget.showDrawer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ThemedLayoutStyle _layoutStyle = ThemedLayoutStyle.modern;

  @override
  void initState() {
    super.initState();
    setThemedSnackbarScaffoldKey(_scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    List<ThemedNavigatorItem> persistentItems = [
      ThemedNavigatorAction(
        labelText: ThemedLayoutStyle.modern.toString().split('.').last,
        highlight: _layoutStyle == ThemedLayoutStyle.modern,
        icon: MdiIcons.viewGrid,
        onTap: () {
          setState(() {
            _layoutStyle = ThemedLayoutStyle.modern;
          });
        },
      ),
      ThemedNavigatorAction(
        labelText: ThemedLayoutStyle.classic.toString().split('.').last,
        highlight: _layoutStyle == ThemedLayoutStyle.classic,
        icon: MdiIcons.viewDashboard,
        onTap: () {
          setState(() {
            _layoutStyle = ThemedLayoutStyle.classic;
          });
        },
      ),
      ThemedNavigatorAction(
        labelText: ThemedLayoutStyle.sidebar.toString().split('.').last,
        highlight: _layoutStyle == ThemedLayoutStyle.sidebar,
        icon: MdiIcons.viewSplitHorizontal,
        onTap: () {
          setState(() {
            _layoutStyle = ThemedLayoutStyle.sidebar;
          });
        },
      )
    ];
    List<ThemedNavigatorItem> items = [
      ThemedNavigatorPage(
        labelText: 'Home',
        path: '/home',
        icon: MdiIcons.home,
      ),
      ThemedNavigatorPage(
        labelText: 'Nested',
        path: '/nested',
        useDefaultRedirect: false,
        children: List.generate(5, (i) {
          return ThemedNavigatorPage(
            labelText: "Subpage $i",
            path: '/nested/test$i',
          );
        }),
      ),
      ThemedNavigatorSeparator(type: ThemedSeparatorType.dots),
      ThemedNavigatorPage(
        labelText: 'Layo',
        path: '/layo',
      ),
      ThemedNavigatorSeparator(type: ThemedSeparatorType.dots),
      ThemedNavigatorPage(
        labelText: 'Table',
        path: '/table',
      ),
      ThemedNavigatorPage(
        labelText: 'Text',
        path: '/text',
      ),
      ThemedNavigatorPage(
        labelText: 'Cards',
        path: '/cards',
      ),
      ThemedNavigatorPage(
        labelText: 'Inputs',
        path: '/inputs',
      ),
      ThemedNavigatorPage(
        labelText: 'Dynamic credentials',
        path: '/dynamic_credentials',
      ),
      ThemedNavigatorPage(
        labelText: 'Tab bar',
        path: '/tabBar',
      ),
      ThemedNavigatorPage(
        labelText: 'Buttons',
        path: '/buttons',
      ),
      ThemedNavigatorPage(
        labelText: 'Avatars',
        path: '/avatars',
      ),
      ThemedNavigatorPage(
        labelText: 'Empty',
        path: '/empty',
      ),
      ThemedNavigatorAction(
        labelText: 'Empty [Native]',
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const EmptyView(name: 'Empty [Native]');
            },
            settings: const RouteSettings(name: '/test_empty_native'),
          ));
        },
      ),
      ThemedNavigatorSeparator(),
      ThemedNavigatorPage(
        labelText: 'Login Example',
        path: '/login_example',
      ),
      ThemedNavigatorAction(
        labelText: 'Action',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Action tapped'),
            ),
          );
        },
      ),
      ThemedNavigatorLabel(
        labelText: 'Label',
      ),
    ];

    const logo = AppThemedAsset(
      normal: 'https://cdn.layrz.com/resources/layrz/logo/dev-normal.png',
      white: 'https://cdn.layrz.com/resources/layrz/logo/dev-white.png',
    );

    const favicon = AppThemedAsset(
      normal: 'https://cdn.layrz.com/resources/layrz/favicon/normal.png',
      white: 'https://cdn.layrz.com/resources/layrz/favicon/white.png',
    );

    const appTitle = "Text environment";

    var notifications = [
      ThemedNotificationItem(
        title: "With icon",
        content: "Lorem ipsum dolor sit amet",
        icon: MdiIcons.help,
        onTap: () {
          debugPrint('Notification tapped');
        },
      ),
      ThemedNotificationItem(
        title: "With color",
        content: "Lorem ipsum dolor sit amet",
        color: Colors.red,
        onTap: () {
          debugPrint('Notification tapped');
        },
      ),
      ThemedNotificationItem(
        title: "With onTap",
        content: "Lorem ipsum dolor sit amet",
        onTap: () {
          debugPrint('Notification tapped');
        },
      ),
      const ThemedNotificationItem(
        title: "Plain",
        content: "Lorem ipsum dolor sit amet",
      ),
    ];

    debugPrint('layout: $_layoutStyle');

    return ThemedLayout(
      isBackEnabled: false,
      // style: ThemedLayoutStyle.classic,
      persistentItems: persistentItems,
      style: _layoutStyle,
      scaffoldKey: _scaffoldKey,
      logo: logo,
      favicon: favicon,
      appTitle: appTitle,
      items: items,
      userDynamicAvatar: const Avatar(
        type: AvatarType.url,
        url: 'https://cdn.layrz.com/%EA%BE%B8%EB%9D%BC.jpg',
      ),
      version: '2023.1.1',
      body: widget.body,
      enableAbout: true,
      onLogoutTap: () {
        debugPrint('Logout tapped');
      },
      onProfileTap: () {
        debugPrint('Profile tapped');
      },
      onSettingsTap: () {
        debugPrint('Settings tapped');
      },
      additionalActions: [
        ThemedNavigatorAction(
          icon: MdiIcons.testTube,
          labelText: "Test",
          onTap: () {
            debugPrint('Test tapped');
          },
        ),
      ],
      onNavigatorPush: context.go,
      onNavigatorPop: context.pop,
      notifications: notifications,
      onThemeSwitchTap: () => ToggleTheme(),
    );
  }
}
