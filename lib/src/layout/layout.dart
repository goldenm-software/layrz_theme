library layout;

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

part 'src/appbar.dart';
part 'src/sidebar.dart';
part 'src/drawer.dart';
part 'src/taskbar.dart';
part 'src/models.dart';

// Parts
part 'src/parts/notification.dart';
part 'src/parts/avatar.dart';

typedef ThemedNavigatorPushFunction = void Function(String path);
typedef ThemdNavigatorPopFunction = VoidCallback;

class ThemedLayout extends StatefulWidget {
  final ThemedLayoutStyle style;
  final Widget body;
  final GlobalKey<ScaffoldState>? scaffoldKey;
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
  final VoidCallback? onThemeSwitchTap;
  final List<ThemedNavigatorItem> additionalActions;
  final Color? backgroundColor;
  final List<ThemedNavigatorItem> persistentItems;
  final List<ThemedNotificationItem> notifications;
  final double mobileBreakpoint;
  final EdgeInsets padding;
  final bool disableSafeArea;
  final ThemedNavigatorPushFunction? onNavigatorPush;
  final ThemdNavigatorPopFunction? onNavigatorPop;
  final bool isBackEnabled;
  final String? currentPath;

  /// [ThemedLayout] is the layout of the application. It is the parent of all
  const ThemedLayout({
    super.key,

    /// [style] is the style of the layout. Defaults to [ThemedLayoutStyle.modern].
    this.style = ThemedLayoutStyle.modern,

    /// [body] is the body of the layout. It is the main content of the application.
    required this.body,

    /// [scaffoldKey] is the key of the scaffold. It is used to open the drawer.
    /// Defaults to [GlobalKey<ScaffoldState>()].
    this.scaffoldKey,

    /// [buttons] is the list of buttons to be displayed in the drawer.
    this.items = const [],

    /// [homePath] is the path of the home page.
    this.homePath = '/home',

    /// [disableLeading] is a boolean that prevents the back button from being
    /// displayed.
    this.disableLeading = false,

    /// [enableAbout] is a boolean that enables the about button.
    this.enableAbout = true,

    /// [onSettingsTap] is the callback to be executed when the settings button
    this.onSettingsTap,

    /// [onProfileTap] is the callback to be executed when the profile button
    this.onProfileTap,

    /// [onLogoutTap] is the callback to be executed when the logout button
    this.onLogoutTap,

    /// [onThemeSwitchTap] is the callback to be executed when the theme switch button
    this.onThemeSwitchTap,

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

    /// [additionalActions] is the list of additional actions to be displayed in the app bar.
    /// By default is `[]`.
    /// Its important to note that the additional actions are displayed in the app bar only if
    /// [enableAlternativeUserMenu] is `true`.
    this.additionalActions = const [],

    /// [backgroundColor] is the background color of the app bar.
    /// Overrides the default background color from `Theme.of(context).scaffoldBackgroundColor`.
    this.backgroundColor,

    /// [persistentItems] is the list of persistent items to be displayed in the taskbar.
    /// By default is `[]`.
    this.persistentItems = const [],

    /// [notifications] is the list of notifications to be displayed in the taskbar or sidebar.
    /// By default is `[]`.
    this.notifications = const [],

    /// [mobileBreakpoint] is the breakpoint for mobile devices.
    /// By default is `kMediumGrid`.
    this.mobileBreakpoint = kMediumGrid,

    /// [padding] is the padding of the layout.
    /// By default is `EdgeInsets.all(10)`.
    this.padding = const EdgeInsets.all(10),

    /// [disableSafeArea] is a boolean that disables the safe area.
    /// By default is `false`.
    this.disableSafeArea = false,

    /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
    /// By default is `Navigator.of(context).pushNamed`
    this.onNavigatorPush,

    /// [onNavigatorPop] is the callback to be executed when the back button is tapped.
    /// By default is `Navigator.of(context).pop`
    this.onNavigatorPop,

    /// [isBackEnabled] is the flag to enable the back button.
    /// By default is `true`.
    this.isBackEnabled = true,

    /// [currentPath] is the current path of the navigator. Overrides the default path detection.
    /// By default, we get the current path from `ModalRoute.of(context)?.settings.name`.
    this.currentPath,
  });

  @override
  State<ThemedLayout> createState() => _ThemedLayoutState();
}

class _ThemedLayoutState extends State<ThemedLayout> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = widget.scaffoldKey ?? GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Widget child = Container(
      width: double.infinity,
      padding: widget.padding,
      child: widget.body,
    );

    if (!widget.disableSafeArea) {
      child = SafeArea(child: child);
    }

    if (width <= widget.mobileBreakpoint) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: _generateAppBar(),
        body: child,
        onDrawerChanged: (isExpanded) {
          Color backgroundColor =
              widget.backgroundColor ?? (isDark ? Colors.grey.shade900 : Theme.of(context).primaryColor);
          overrideAppBarStyle(backgroundColor: backgroundColor, scaffoldKey: _scaffoldKey);
        },
        drawer: ThemedDrawer(
          scaffoldKey: _scaffoldKey,
          fromScaffold: true,
          items: widget.items,
          appTitle: widget.appTitle,
          companyName: widget.companyName,
          logo: widget.logo,
          favicon: widget.favicon,
          version: widget.version,
          userName: widget.userName,
          userDynamicAvatar: widget.userDynamicAvatar,
          enableAbout: widget.enableAbout,
          onSettingsTap: widget.onSettingsTap,
          onProfileTap: widget.onProfileTap,
          onLogoutTap: widget.onLogoutTap,
          onThemeSwitchTap: widget.onThemeSwitchTap,
          additionalActions: widget.additionalActions,
          mobileBreakpoint: widget.mobileBreakpoint,
          onNavigatorPush: widget.onNavigatorPush,
          onNavigatorPop: widget.onNavigatorPop,
          currentPath: widget.currentPath,
        ),
      );
    }

    switch (widget.style) {
      case ThemedLayoutStyle.classic:
        final childUrls = getChildUrls();
        return Scaffold(
          key: _scaffoldKey,
          appBar: _generateAppBar(),
          body: Row(
            children: [
              ThemedSidebar(
                onNavigatorPush: widget.onNavigatorPush,
                currentPath: widget.currentPath,
                items: [
                  ...childUrls,
                  if (widget.persistentItems.isNotEmpty) ...[
                    if (childUrls.isNotEmpty) ThemedNavigatorSeparator(type: ThemedSeparatorType.dots),
                    ...widget.persistentItems,
                  ],
                ],
              ),
              Expanded(child: child),
            ],
          ),
        );
      case ThemedLayoutStyle.modern:
        return Scaffold(
          key: _scaffoldKey,
          appBar: _generateAppBar(),
          body: Column(
            children: [
              Expanded(child: child),
              ThemedTaskbar(
                items: getChildUrls(),
                persistentItems: widget.persistentItems,
                appTitle: widget.appTitle,
                companyName: widget.companyName,
                logo: widget.logo,
                favicon: widget.favicon,
                version: widget.version,
                userName: widget.userName,
                userDynamicAvatar: widget.userDynamicAvatar,
                enableAbout: widget.enableAbout,
                onSettingsTap: widget.onSettingsTap,
                onProfileTap: widget.onProfileTap,
                onLogoutTap: widget.onLogoutTap,
                notifications: widget.notifications,
                additionalActions: widget.additionalActions,
                onThemeSwitchTap: widget.onThemeSwitchTap,
                onNavigatorPush: widget.onNavigatorPush,
                currentPath: widget.currentPath,
              ),
            ],
          ),
        );
      case ThemedLayoutStyle.sidebar:
        String? pageName;
        IconData? pageIcon;

        String currentPath = widget.currentPath ?? ModalRoute.of(context)?.settings.name ?? '';

        final match = widget.items.whereType<ThemedNavigatorPage>().firstWhereOrNull((page) {
          return currentPath.startsWith(page.path);
        });

        if (match != null) {
          pageName = match.labelText;
          pageIcon = match.icon;

          if (match.label is Text) {
            pageName = (match.label as Text).data;
          }

          if (match.children.isNotEmpty) {
            final submatch = match.children.whereType<ThemedNavigatorPage>().firstWhereOrNull((page) {
              return currentPath.startsWith(page.path);
            });

            if (submatch != null) {
              String? subpageName = submatch.labelText;
              pageIcon = submatch.icon;

              if (submatch.label is Text) {
                subpageName = (submatch.label as Text).data;
              }

              if (subpageName != null) {
                pageName = '$pageName - $subpageName';
              }
            }
          }
        }

        return Scaffold(
          key: _scaffoldKey,
          body: Row(
            children: [
              ThemedDrawer(
                scaffoldKey: _scaffoldKey,
                items: [
                  ...widget.items,
                  if (widget.persistentItems.isNotEmpty) ...[
                    ThemedNavigatorSeparator(type: ThemedSeparatorType.dots),
                    ...widget.persistentItems,
                  ],
                ],
                appTitle: widget.appTitle,
                companyName: widget.companyName,
                logo: widget.logo,
                favicon: widget.favicon,
                version: widget.version,
                userName: widget.userName,
                userDynamicAvatar: widget.userDynamicAvatar,
                enableAbout: widget.enableAbout,
                onSettingsTap: widget.onSettingsTap,
                onProfileTap: widget.onProfileTap,
                onLogoutTap: widget.onLogoutTap,
                additionalActions: widget.additionalActions,
                onNavigatorPop: widget.onNavigatorPop,
                onNavigatorPush: widget.onNavigatorPush,
                currentPath: widget.currentPath,
                onThemeSwitchTap: widget.onThemeSwitchTap,
              ),
              Expanded(
                child: Column(
                  children: [
                    if (pageName != null) ...[
                      Container(
                        height: ThemedAppBar.size.height,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (pageIcon != null) ...[
                              Icon(
                                pageIcon,
                                color: isDark ? Colors.white : Theme.of(context).primaryColor,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                            ],
                            Expanded(
                              child: Text(
                                pageName,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Theme.of(context).primaryColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return Scaffold(
          key: _scaffoldKey,
          appBar: _generateAppBar(),
          body: child,
        );
    }
  }

  ThemedAppBar _generateAppBar() {
    return ThemedAppBar(
      scaffoldKey: _scaffoldKey,
      items: widget.items,
      homePath: widget.homePath,
      disableLeading: widget.disableLeading,
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
      notifications: widget.notifications,
      mobileBreakpoint: widget.mobileBreakpoint,
      forceNotificationIcon: widget.style == ThemedLayoutStyle.classic,
      onThemeSwitchTap: widget.onThemeSwitchTap,
      onNavigatorPush: widget.onNavigatorPush,
      isBackEnabled: widget.isBackEnabled,
      currentPath: widget.currentPath,
    );
  }

  List<ThemedNavigatorItem> getChildUrls() {
    String path = widget.currentPath ?? ModalRoute.of(context)?.settings.name ?? '';
    final parent = widget.items.whereType<ThemedNavigatorPage>().where((parents) => path.startsWith(parents.path));

    if (parent.isEmpty) {
      return [];
    }

    return parent.first.children;
  }
}

enum ThemedLayoutStyle {
  /// [ThemedLayoutStyle.modern] is the modern style of the layout.
  /// Uses the `ThemedAppBar` and `ThemedTaskbar`.
  modern,

  /// [ThemedLayoutStyle.classic] is the classic style of the layout.
  /// Uses the `ThemedAppBar` and `ThemedSidebar.contracted()`.
  classic,

  /// [ThemedLayoutStyle.sidebar] is the sidebar style of the layout.
  /// Uses the `ThemedAppBar` and `ThemedSidebar.expanded()`.
  sidebar,
}

void overrideAppBarStyle({
  required GlobalKey<ScaffoldState> scaffoldKey,
  required Color backgroundColor,
  bool mounted = true,
}) {
  if (!mounted) return;
  if (kIsWeb) return;

  BuildContext? context = scaffoldKey.currentContext;
  if (context == null) return;

  bool isOpen = scaffoldKey.currentState?.isDrawerOpen ?? false;
  SystemUiOverlayStyle style = Theme.of(context).appBarTheme.systemOverlayStyle!;

  if (isOpen) {
    Brightness brightness = useBlack(color: backgroundColor) ? Brightness.dark : Brightness.light;

    if (Platform.isIOS) {
      brightness = brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    }

    style = style.copyWith(
      statusBarIconBrightness: brightness,
      statusBarBrightness: brightness,
      systemNavigationBarIconBrightness: brightness,
    );
  }

  SystemChrome.setSystemUIOverlayStyle(style);
}
