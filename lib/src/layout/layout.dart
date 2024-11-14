library layout;

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Layout parts
part 'src/appbar/desktop.dart';
part 'src/appbar/mobile.dart';

part 'src/bars/dual.dart';
part 'src/bars/side.dart';
part 'src/bars/mini.dart';
part 'src/bars/bottom.dart';

part 'src/models.dart';

// Parts
part 'src/parts/notification.dart';
part 'src/parts/avatar.dart';

typedef ThemedNavigatorPushFunction = void Function(String path);
typedef ThemdNavigatorPopFunction = VoidCallback;

const double kLogoWidth = 2800;
const double kLogoHeight = 500;
const kLogoAspectRatio = kLogoWidth / kLogoHeight;
const double kBottomBarHeight = 50;

/// [ThemedLayoutStyle] is an enum that represents the layout style.
/// The layout style can be dual, sidebar or mini.
enum ThemedLayoutStyle {
  /// [ThemedLayoutStyle.dual] is a layout style that has a sidebar with tooltips to display the actions
  /// and a main app bar.
  dual,

  /// [ThemedLayoutStyle.sidebar] is a layout style that has a classic sidebar with icons to display the actions.
  sidebar,

  /// [ThemedLayoutStyle.mini] is similar to a [ThemedLayoutStyle.sidebar], but the sidebar is smaller and
  /// designed to grant more space to the main content.
  mini,
}

/// [ThemedMobileLayoutStyle] is an enum that represents the layout style.
/// The layout style can be dual, sidebar or mini.
enum ThemedMobileLayoutStyle {
  /// [ThemedMobileLayoutStyle.appBar] is the traditional AppBar layout.
  appBar,

  /// [ThemedMobileLayoutStyle.bottomBar] is a new conceptual idea for navigational layout, nesting the elements
  /// in two or more levels in the bottom part of the screen.
  bottomBar,
}

/// [overrideAppBarStyle] overrides the app bar style.
/// This should be used only when the theme changes from light to dark or vice versa.
void overrideAppBarStyle({
  /// [isDark] is a boolean that indicates if the theme is dark.
  required bool isDark,
}) {
  if (ThemedPlatform.isWeb) return;

  if (isDark) {
    SystemChrome.setSystemUIOverlayStyle(kDarkSystemUiOverlayStyle);
  } else {
    SystemChrome.setSystemUIOverlayStyle(kLightSystemUiOverlayStyle);
  }
}

/// [overrideAppBarStyleWithColor] overrides the app bar style with a custom color.
/// Works exactly the same as [overrideAppBarStyle], but with a custom color.
/// This should be used only when the theme changes from light to dark or vice versa.
///
/// If you want to consider the [isDark] parameter, use [overrideAppBarStyle] instead.
void overrideAppBarStyleWithColor({
  /// [color] is the color to be used in the app bar.
  required Color color,
}) {
  Brightness brightness = useBlack(color: color) ? Brightness.dark : Brightness.light;

  SystemChrome.setSystemUIOverlayStyle(kDarkSystemUiOverlayStyle.copyWith(
    statusBarColor: color,
    systemNavigationBarColor: color,
    systemNavigationBarDividerColor: color,
    statusBarIconBrightness: brightness,
    statusBarBrightness: brightness,
  ));
}

class ThemedLayout extends StatefulWidget {
  /// [style] is the style of the layout. Defaults to [ThemedLayoutStyle.modern].
  final ThemedLayoutStyle style;

  /// [mobileStyle] is the style of the mobile layout. Defaults to [ThemedMobileLayoutStyle.bottomBar].
  final ThemedMobileLayoutStyle mobileStyle;

  /// [body] is the body of the layout. It is the main content of the application.
  final Widget body;

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
  final EdgeInsetsGeometry padding;

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

  /// [avatarRadius] is the radius of the avatar.
  /// By default is `5`.
  final double avatarRadius;

  /// [ThemedLayout] is the layout of the application. It is the parent of all
  const ThemedLayout({
    super.key,
    this.style = ThemedLayoutStyle.mini,
    this.mobileStyle = ThemedMobileLayoutStyle.bottomBar,
    required this.body,
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
    this.avatarRadius = 5,
  });

  @override
  State<ThemedLayout> createState() => _ThemedLayoutState();
}

class _ThemedLayoutState extends State<ThemedLayout> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth <= widget.mobileBreakpoint) {
          return _buildMobileLayout(constraints: constraints);
        }
        switch (widget.style) {
          case ThemedLayoutStyle.mini:
            return _buildMiniLayout(constraints: constraints);
          case ThemedLayoutStyle.sidebar:
            return _buildSidebarLayout(constraints: constraints);
          case ThemedLayoutStyle.dual:
            return _buildDualLayout(constraints: constraints);
        }
      },
    );
  }

  Widget _buildMobileLayout({required BoxConstraints constraints}) {
    Widget child;

    if (widget.disableSafeArea) {
      child = Padding(
        padding: widget.padding,
        child: widget.body,
      );
    } else {
      child = SafeArea(
        child: Padding(
          padding: widget.padding,
          child: widget.body,
        ),
      );
    }

    if (widget.mobileStyle == ThemedMobileLayoutStyle.appBar) {
      return Scaffold(
        appBar: _buildAppBar(isMobile: true),
        body: child,
        drawer: ThemedSidebar(
          fromScaffold: true,
          hideAvatar: true,
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
          enableNotifications: false,
        ),
      );
    }

    return Scaffold(
      body: child,
      appBar: ThemedMobileAppBar(
        isBackEnabled: widget.isBackEnabled,
        items: widget.persistentItems,
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
        onNavigatorPush: widget.onNavigatorPush,
        onNavigatorPop: widget.onNavigatorPop,
        currentPath: widget.currentPath,
        enableNotifications: widget.enableNotifications,
        notifications: widget.notifications,
        avatarRadius: widget.avatarRadius,
      ),
      bottomNavigationBar: ThemedBottomBar(
        items: widget.items,
        additionalActions: widget.additionalActions,
        mobileBreakpoint: widget.mobileBreakpoint,
        onNavigatorPush: widget.onNavigatorPush,
        onNavigatorPop: widget.onNavigatorPop,
        currentPath: widget.currentPath,
      ),
    );
  }

  Widget _buildMiniLayout({required BoxConstraints constraints}) {
    Widget child = Container(
      padding: widget.padding,
      height: constraints.maxHeight,
      child: widget.body,
    );

    if (!widget.disableSafeArea) {
      child = SafeArea(child: child);
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThemedMiniBar(
            items: widget.items,
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
            onThemeSwitchTap: widget.onThemeSwitchTap,
            additionalActions: widget.additionalActions,
            mobileBreakpoint: widget.mobileBreakpoint,
            onNavigatorPush: widget.onNavigatorPush,
            onNavigatorPop: widget.onNavigatorPop,
            currentPath: widget.currentPath,
            enableNotifications: widget.enableNotifications,
            notifications: widget.notifications,
            avatarRadius: widget.avatarRadius,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildSidebarLayout({required BoxConstraints constraints}) {
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

    Widget child;

    if (widget.disableSafeArea) {
      child = Padding(
        padding: widget.padding,
        child: widget.body,
      );
    } else {
      child = SafeArea(
        child: Padding(
          padding: widget.padding,
          child: widget.body,
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          ThemedSidebar(
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
            enableNotifications: widget.enableNotifications,
            notifications: widget.notifications,
            avatarRadius: widget.avatarRadius,
          ),
          Expanded(
            child: SafeArea(
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
                  Expanded(
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDualLayout({required BoxConstraints constraints}) {
    Widget child;

    if (widget.disableSafeArea) {
      child = Padding(
        padding: widget.padding,
        child: widget.body,
      );
    } else {
      child = SafeArea(
        child: Padding(
          padding: widget.padding,
          child: widget.body,
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(isMobile: false),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThemedDualBar(
            onNavigatorPush: widget.onNavigatorPush,
            currentPath: widget.currentPath,
            persistentItems: widget.persistentItems,
            items: widget.items,
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar({bool isMobile = false}) {
    return ThemedAppBar(
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
      enableNotifications: widget.enableNotifications,
      onThemeSwitchTap: widget.onThemeSwitchTap,
      onNavigatorPush: widget.onNavigatorPush,
      isBackEnabled: widget.isBackEnabled,
      currentPath: widget.currentPath,
      isMobile: isMobile,
      avatarRadius: widget.avatarRadius,
    );
  }
}
