import 'package:flutter/material.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';

class Layout extends StatefulWidget {
  final bool showDrawer;
  final Widget body;
  const Layout({
    Key? key,
    required this.showDrawer,
    required this.body,
  }) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  bool get showDrawer => widget.showDrawer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<ThemedNavigatorItem> items = [
      ThemedNavigatorPage(
        labelText: 'Home',
        path: '/home',
        children: [
          ...List.generate(2, (i) {
            return ThemedNavigatorPage(
              labelText: "Test $i",
              icon: Icons.add,
              path: '/home/test$i',
            );
          }),
        ],
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
      ThemedNavigatorPage(
        labelText: 'Login Example',
        path: '/login_example',
      ),
      ThemedNavigatorAction(
        highlight: true,
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

    Widget drawer = ThemedDrawer(
      logo: logo,
      favicon: favicon,
      appTitle: appTitle,
      items: items,
      userAvatar: 'https://cdn.layrz.com/%EA%BE%B8%EB%9D%BC.jpg',
      isDesktop: false,
      version: '2023.1.1',
    );

    PreferredSizeWidget appBar = ThemedAppBar(
      logo: logo,
      favicon: favicon,
      scaffoldKey: _scaffoldKey,
      appTitle: appTitle,
      items: items,
      enableAlternativeUserMenu: true,
      userAvatar: const Avatar(
        type: AvatarType.url,
        url: 'https://cdn.layrz.com/%EA%BE%B8%EB%9D%BC.jpg',
      ),
      isDesktop: false,
      version: '2023.1.1',
    );

    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: Column(
        children: [
          // ThemedSidebar(items: items),
          Expanded(
            child: widget.body,
          ),
          ThemedTaskbar(
            logo: logo,
            favicon: favicon,
            appTitle: appTitle,
            userAvatar: 'https://cdn.layrz.com/%EA%BE%B8%EB%9D%BC.jpg',
            items: [
              ThemedNavigatorLabel(labelText: "Test label " * 5),
            ],
          ),
        ],
      ),
    );
  }
}
