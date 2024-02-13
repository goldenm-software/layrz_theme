part of '../layout.dart';

abstract class ThemedNavigatorItem {
  /// [label] is the label of the view.
  /// Prevent use [label] and [labelText] at the same time.
  final Widget? label;

  /// [labelText] is the label of the view.
  /// Prevent use [label] and [labelText] at the same time.
  final String? labelText;

  /// [ThemedNavigatorItem] is a helper class to handle the items of the view.
  ThemedNavigatorItem({
    this.label,
    this.labelText,
  });

  /// [topBarItemPadding] is the padding applied of the element when is rendered using [toAppBarItem].
  static EdgeInsets get topBarItemPadding => const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10);

  /// [sidebarItemPadding] is the padding applied of the element when is rendered using [toSidebarItem].
  static EdgeInsets get sidebarItemPadding => const EdgeInsets.symmetric(vertical: 5);

  /// [drawerItemPadding] is the padding applied of the element when is rendered using [toDrawerItem].
  static EdgeInsets get drawerItemPadding => const EdgeInsets.symmetric(vertical: 5);

  /// [sidebarSize] is the size of the elements in the sidebar.
  static double get sidebarSize => 35;
}

class ThemedNavigatorPage extends ThemedNavigatorItem {
  /// [icon] is the icon of the view.
  final IconData? icon;

  /// [path] is the path of the view.
  final String path;

  /// [children] is the children of the view. by default will be empty.
  /// Be careful to use more than one level of children, only more than one level of children will work in
  /// layout sidebar mode. Otherwise will only show the first level of children.
  final List<ThemedNavigatorItem> children;

  /// [useDefaultRedirect] indicates if the view should redirect to the first child when is tapped.
  final bool useDefaultRedirect;

  /// [showHeaderInSidebarMode] indicates if the header should be displayed in sidebar mode.
  /// By default is true.
  ///
  /// This bool does not apply when is in other Layout styles, or has children items.
  final bool showHeaderInSidebarMode;

  /// [ThemedNavigatorPage] is a helper class to handle the view and their children.
  ThemedNavigatorPage({
    super.label,
    super.labelText,
    this.icon,
    required this.path,
    this.children = const [],
    this.useDefaultRedirect = true,
    this.showHeaderInSidebarMode = true,
  }) : assert(label != null || labelText != null);

  void Function(ThemedNavigatorPushFunction) get onTap => (onPush) {
        if (useDefaultRedirect) {
          final subpages = children.whereType<ThemedNavigatorPage>();
          if (subpages.isNotEmpty) {
            onPush.call(subpages.first.path);
          } else {
            onPush.call(path);
          }
        } else {
          onPush.call(path);
        }
      };
}

class ThemedNavigatorAction extends ThemedNavigatorItem {
  /// [icon] is the icon of the view.
  final IconData? icon;

  /// [onTap] is the action to be executed when the item is tapped.
  final VoidCallback onTap;

  /// [highlight] indicates if the action is highlighted.
  final bool highlight;

  /// [forceOnTap] indicates if the action should be forced to be tapped.
  final bool forceOnTap;

  /// [ThemedNavigatorAction] is a helper class to handle the actions of the view.
  ThemedNavigatorAction({
    super.label,
    super.labelText,
    this.icon,
    required this.onTap,
    this.highlight = false,
    this.forceOnTap = false,
  }) : assert(label != null || labelText != null);
}

class ThemedNavigatorSeparator extends ThemedNavigatorItem {
  /// [type] is the type of the separator.
  final ThemedSeparatorType type;

  /// [ThemedNavigatorSeparator] is a visual separator of the items in a [ThemedAppBar.items] or [ThemedDrawer.items].
  ThemedNavigatorSeparator({
    this.type = ThemedSeparatorType.line,
  });
}

class ThemedNavigatorLabel extends ThemedNavigatorItem {
  /// [labelStyle] is the style of the label. Only applies when [labelText] is not null.
  final TextStyle? labelStyle;

  /// [ThemedNavigatorLabel] is a visual separator of the items in a [ThemedAppBar.items] or [ThemedDrawer.items].
  ThemedNavigatorLabel({
    super.label,
    super.labelText,
    this.labelStyle,
  }) : assert(label != null || labelText != null);
}

class ThemedNotificationItem {
  /// [title] is the title of the notification.
  final String title;

  /// [content] is the content of the notification.
  final String content;

  /// [icon] is the icon of the notification.
  final IconData? icon;

  /// [onTap] is the action to be executed when the notification is tapped.
  final VoidCallback? onTap;

  /// [color] is the color of the notification.
  final Color? color;

  /// [ThemedNotificationItem] is a helper class to handle the notifications of the view.
  const ThemedNotificationItem({
    required this.title,
    required this.content,
    this.icon,
    this.onTap,
    this.color,
  });
}

enum ThemedSeparatorType {
  line,
  dots,
}
