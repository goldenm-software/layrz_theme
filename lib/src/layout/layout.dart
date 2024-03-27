library layout;

import 'dart:async';
import 'dart:io';

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

const double kLogoWidth = 2000;
const double kLogoHeight = 500;
const kLogoAspectRatio = kLogoWidth / kLogoHeight;

class ThemedLayout extends StatefulWidget {
  /// [style] is the style of the layout. Defaults to [ThemedLayoutStyle.modern].
  final ThemedLayoutStyle style;

  /// [body] is the body of the layout. It is the main content of the application.
  final Widget body;

  /// [scaffoldKey] is the key of the scaffold. It is used to open the drawer.
  /// Defaults to [GlobalKey<ScaffoldState>()].
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// [items] is the list of buttons to be displayed in the drawer.
  final List<ThemedNavigatorItem> items;

  /// [homePath] is the path of the home page.
  final String homePath;

  /// [disableLeading] is a boolean that prevents the back button from being
  final bool disableLeading;

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

  /// [buttons] is the list of buttons to be displayed in the drawer.
  /// displayed.
  /// [onSettingsTap] is the callback to be executed when the settings button
  final VoidCallback? onSettingsTap;

  /// [onProfileTap] is the callback to be executed when the profile button
  final VoidCallback? onProfileTap;

  /// [onLogoutTap] is the callback to be executed when the logout button
  final VoidCallback? onLogoutTap;

  /// [onThemeSwitchTap] is the callback to be executed when the theme switch button
  final VoidCallback? onThemeSwitchTap;

  /// [additionalActions] is the list of additional actions to be displayed in the app bar.
  /// By default is `[]`.
  final List<ThemedNavigatorItem> additionalActions;

  /// Its important to note that the additional actions are displayed in the app bar only if
  /// [enableAlternativeUserMenu] is `true`.
  /// [backgroundColor] is the background color of the app bar.
  /// Overrides the default background color from `Theme.of(context).scaffoldBackgroundColor`.
  final Color? backgroundColor;

  /// [persistentItems] is the list of persistent items to be displayed in the taskbar.
  /// By default is `[]`.
  final List<ThemedNavigatorItem> persistentItems;

  /// [notifications] is the list of notifications to be displayed in the taskbar or sidebar.
  /// By default is `[]`.
  final List<ThemedNotificationItem> notifications;

  /// [mobileBreakpoint] is the breakpoint for mobile devices.
  /// By default is `kMediumGrid`.
  final double mobileBreakpoint;

  /// [padding] is the padding of the layout.
  /// By default is `EdgeInsets.all(10)`.
  final EdgeInsets padding;

  /// [disableSafeArea] is a boolean that disables the safe area.
  /// By default is `false`.
  final bool disableSafeArea;

  /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
  /// By default is `Navigator.of(context).pushNamed`
  final ThemedNavigatorPushFunction? onNavigatorPush;

  /// [onNavigatorPop] is the callback to be executed when the back button is tapped.
  /// By default is `Navigator.of(context).pop`
  final ThemdNavigatorPopFunction? onNavigatorPop;

  /// [isBackEnabled] is the flag to enable the back button.
  /// By default is `true`.
  final bool isBackEnabled;

  /// [currentPath] is the current path of the navigator. Overrides the default path detection.
  /// By default, we get the current path from `ModalRoute.of(context)?.settings.name`.
  final String? currentPath;

  /// [enableNotifications] is a boolean that enables the notifications button.
  final bool enableNotifications;

  /// [ThemedLayout] is the layout of the application. It is the parent of all
  const ThemedLayout({
    super.key,
    this.style = ThemedLayoutStyle.modern,
    required this.body,
    this.scaffoldKey,
    this.items = const [],
    this.homePath = '/home',
    this.disableLeading = false,
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
    this.persistentItems = const [],
    this.notifications = const [],
    this.mobileBreakpoint = kMediumGrid,
    this.padding = const EdgeInsets.all(10),
    this.disableSafeArea = false,
    this.onNavigatorPush,
    this.onNavigatorPop,
    this.isBackEnabled = true,
    this.currentPath,
    this.enableNotifications = true,
  });

  @override
  State<ThemedLayout> createState() => _ThemedLayoutState();
}

class _ThemedLayoutState extends State<ThemedLayout> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  VoidCallback? get _onThemeSwitchTap {
    if (widget.onThemeSwitchTap == null) return null;

    return () {
      widget.onThemeSwitchTap!.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        overrideAppBarStyle(isDark: isDark);
      });
    };
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = widget.scaffoldKey ?? GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return _buildLayout();
  }

  Widget _buildLayout() {
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
          onThemeSwitchTap: _onThemeSwitchTap,
          additionalActions: widget.additionalActions,
          mobileBreakpoint: widget.mobileBreakpoint,
          onNavigatorPush: widget.onNavigatorPush,
          onNavigatorPop: widget.onNavigatorPop,
          currentPath: widget.currentPath,
          enableNotifications: false,
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
                persistentItems: widget.persistentItems,
                items: childUrls,
              ),
              Expanded(child: child),
            ],
          ),
        );
      case ThemedLayoutStyle.modern:
        return Scaffold(
          key: _scaffoldKey,
          appBar: _generateAppBar(displayNotifications: false),
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
                onThemeSwitchTap: _onThemeSwitchTap,
                onNavigatorPush: widget.onNavigatorPush,
                currentPath: widget.currentPath,
                enableNotifications: widget.enableNotifications,
                onNavigatorPop: widget.onNavigatorPop,
              ),
            ],
          ),
        );
      case ThemedLayoutStyle.sidebar:
        String? pageName;
        IconData? pageIcon;
        bool displayHeader = true;

        String currentPath = widget.currentPath ?? ModalRoute.of(context)?.settings.name ?? '';

        final match = widget.items.whereType<ThemedNavigatorPage>().firstWhereOrNull((page) {
          return currentPath.startsWith(page.path);
        });

        if (match != null) {
          pageName = match.labelText;
          pageIcon = match.icon;
          displayHeader = match.showHeaderInSidebarMode;

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
              displayHeader = match.showHeaderInSidebarMode;

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
                onThemeSwitchTap: _onThemeSwitchTap,
                enableNotifications: widget.enableNotifications,
                notifications: widget.notifications,
              ),
              Expanded(
                child: Column(
                  children: [
                    if (pageName != null && displayHeader) ...[
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

  ThemedAppBar _generateAppBar({bool displayNotifications = true}) {
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
      enableNotifications: displayNotifications && widget.enableNotifications,
      onThemeSwitchTap: _onThemeSwitchTap,
      onNavigatorPush: widget.onNavigatorPush,
      isBackEnabled: widget.isBackEnabled,
      currentPath: widget.currentPath,
      hideAvatar: widget.style == ThemedLayoutStyle.modern,
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

/// [overrideAppBarStyle] overrides the app bar style.
/// This should be used only when the theme changes from light to dark or vice versa.
void overrideAppBarStyle({
  /// [isDark] is a boolean that indicates if the theme is dark.
  required bool isDark,
}) {
  if (kIsWeb) return;
  // isDark = !isDark; // Idk why, but when this algorithm is called, is inverted.

  if (isDark) {
    SystemChrome.setSystemUIOverlayStyle(kDarkSystemUiOverlayStyle);
  } else {
    SystemChrome.setSystemUIOverlayStyle(kLightSystemUiOverlayStyle);
  }
}
