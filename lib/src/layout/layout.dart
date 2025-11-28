library;

import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_icons/layrz_icons.dart';

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
  Brightness brightness = useBlack(color: color) ? .dark : .light;

  SystemChrome.setSystemUIOverlayStyle(
    kDarkSystemUiOverlayStyle.copyWith(
      statusBarColor: color,
      systemNavigationBarColor: color,
      systemNavigationBarDividerColor: color,
      statusBarIconBrightness: brightness,
      statusBarBrightness: brightness,
    ),
  );
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

  /// [enableBreadcrumb] is a boolean that disables the breadcrumb.
  /// By default is `true`, also you can disable it individually in each page, read more about this
  /// on the [ThemedNavigatorPage] documentation.
  final bool enableBreadcumb;

  /// [breadcumbPadding] is the padding of the breadcrumb.
  /// By default is `EdgeInsets.only(left: 10, top: 10, right: 10)`.
  final EdgeInsetsGeometry breadcumbPadding;

  /// [ThemedLayout] is the layout of the application. It is the parent of all
  const ThemedLayout({
    super.key,
    this.style = .mini,
    this.mobileStyle = .bottomBar,
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
    this.padding = const .all(10),
    this.disableSafeArea = false,
    this.onNavigatorPush,
    this.onNavigatorPop,
    this.isBackEnabled = true,
    this.currentPath,
    this.enableNotifications = true,
    this.avatarRadius = 5,
    this.enableBreadcumb = true,
    this.breadcumbPadding = const .only(left: 10, top: 10, right: 10),
  });

  @override
  State<ThemedLayout> createState() => _ThemedLayoutState();
}

class _ThemedLayoutState extends State<ThemedLayout> {
  bool get isDark => Theme.of(context).brightness == .dark;
  EdgeInsetsGeometry get breadcumbPadding => widget.breadcumbPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= widget.mobileBreakpoint) {
          return _buildMobileLayout(constraints: constraints);
        }
        switch (widget.style) {
          case .mini:
            return _buildMiniLayout(constraints: constraints);
          case .sidebar:
            return _buildSidebarLayout(constraints: constraints);
          case .dual:
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

    if (widget.mobileStyle == .appBar) {
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
    final match = _getMatch();

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
        crossAxisAlignment: .start,
        mainAxisAlignment: .start,
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
          Expanded(
            // child: const SizedBox(),
            child: Column(
              children: [
                if (widget.enableBreadcumb) _composeHeader(match: match),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarLayout({required BoxConstraints constraints}) {
    final match = _getMatch();

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
                ThemedNavigatorSeparator(type: .dots),
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
                  if (widget.enableBreadcumb) _composeHeader(match: match),
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
    final match = _getMatch();
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
        crossAxisAlignment: .start,
        mainAxisAlignment: .start,
        children: [
          ThemedDualBar(
            onNavigatorPush: widget.onNavigatorPush,
            currentPath: widget.currentPath,
            persistentItems: widget.persistentItems,
            items: widget.items,
          ),
          Expanded(
            child: Column(
              children: [
                if (widget.enableBreadcumb) _composeHeader(match: match),
                Expanded(child: child),
              ],
            ),
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

  Widget _composeHeader({required ThemedRouteMatch? match}) {
    return SizedBox(
      width: double.infinity,
      child: match == null || !match.displayHeader
          ? const SizedBox.shrink()
          : Container(
              padding: breadcumbPadding,
              child: RichText(text: match.name),
            ),
    );
  }

  ThemedRouteMatch? _getMatch() {
    Color color = isDark ? Colors.white : Theme.of(context).primaryColor;
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: .bold, color: color);

    List<InlineSpan> pageName = [];
    bool displayHeader = true;

    String currentPath = widget.currentPath ?? ModalRoute.of(context)?.settings.name ?? '';

    final match = widget.items.whereType<ThemedNavigatorPage>().firstWhereOrNull((page) {
      return currentPath.startsWith(page.path);
    });

    if (match != null) {
      if (match.icon != null) {
        pageName.add(
          WidgetSpan(
            child: Icon(
              match.icon,
              color: color,
              size: 18,
            ),
          ),
        );
      }

      // ignore: deprecated_member_use_from_same_package
      displayHeader = match.enableBreadcumb;

      if (match.labelText != null) {
        pageName.add(TextSpan(text: match.labelText));
      } else if (match.label is Text) {
        pageName.add(TextSpan(text: (match.label as Text).data));
      } else {
        pageName.add(TextSpan(text: currentPath));
      }

      if (match.children.isNotEmpty) {
        final submatch = match.children.whereType<ThemedNavigatorPage>().firstWhereOrNull((page) {
          return currentPath.startsWith(page.path);
        });

        if (submatch != null) {
          // ignore: deprecated_member_use_from_same_package
          displayHeader = submatch.enableBreadcumb;
          pageName.add(
            WidgetSpan(
              child: Icon(
                LayrzIcons.solarOutlineAltArrowRight,
                color: color,
                size: 18,
              ),
            ),
          );

          if (submatch.icon != null) {
            pageName.add(
              WidgetSpan(
                child: Icon(
                  submatch.icon,
                  color: color,
                  size: 18,
                ),
              ),
            );
          }

          if (submatch.labelText != null) {
            pageName.add(TextSpan(text: submatch.labelText));
          } else if (submatch.label is Text) {
            pageName.add(TextSpan(text: (submatch.label as Text).data));
          } else {
            pageName.add(TextSpan(text: currentPath));
          }
        }
      }
    }

    if (pageName.isNotEmpty) {
      List<InlineSpan> content = [];
      for (int i = 0; i < pageName.length; i++) {
        content.add(pageName[i]);
        if (i < pageName.length - 1) {
          content.add(const WidgetSpan(child: SizedBox(width: 5)));
        }
      }
      return ThemedRouteMatch(
        name: TextSpan(
          children: content,
          style: style,
        ),
        path: currentPath,
        displayHeader: displayHeader,
      );
    }

    return null;
  }
}

class ThemedRouteMatch {
  final String path;
  final InlineSpan name;
  final bool displayHeader;

  ThemedRouteMatch({
    required this.path,
    required this.name,
    this.displayHeader = true,
  });
}
