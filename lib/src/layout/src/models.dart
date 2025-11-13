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
  static EdgeInsets get topBarItemPadding => const .symmetric(vertical: 2.5, horizontal: 10);

  /// [sidebarItemPadding] is the padding applied of the element when is rendered using [toSidebarItem].
  static EdgeInsets get sidebarItemPadding => const .symmetric(vertical: 5);

  /// [drawerItemPadding] is the padding applied of the element when is rendered using [toDrawerItem].
  static EdgeInsets get drawerItemPadding => const .symmetric(vertical: 5);

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

  /// [enableBreadcumb] indicates if the header should be displayed in sidebar mode.
  /// By default is true.
  ///
  /// This bool does not apply when is in other Layout styles, or has children items.
  ///
  /// Before fully removal, we'll apply an or operator between enableBreadcumb and showHeaderInSidebarMode
  /// to keep the backward compatibility.
  final bool enableBreadcumb;

  /// [ThemedNavigatorPage] is a helper class to handle the view and their children.
  ThemedNavigatorPage({
    super.label,
    super.labelText,
    this.icon,
    required this.path,
    this.children = const [],
    this.useDefaultRedirect = true,
    this.enableBreadcumb = true,
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

class ThemedNavigatorWidget extends ThemedNavigatorItem {
  /// [widget] is the widget to be displayed in the view.
  final Widget widget;

  /// [onTap] is the action to be executed when the item is tapped.
  final VoidCallback? onTap;

  /// [ThemedNavigatorWidget] is a helper class to handle the widgets of the view.
  ThemedNavigatorWidget({
    super.label,
    super.labelText,
    this.onTap,
    required this.widget,
  }) : assert(label != null || labelText != null);
}

class ThemedNavigatorSeparator extends ThemedNavigatorItem {
  /// [type] is the type of the separator.
  final ThemedSeparatorType type;

  /// [ThemedNavigatorSeparator] is a visual separator of the items in a [ThemedAppBar.items] or [ThemedSidebar.items].
  ThemedNavigatorSeparator({this.type = .line});
}

class ThemedNavigatorLabel extends ThemedNavigatorItem {
  /// [labelStyle] is the style of the label. Only applies when [labelText] is not null.
  final TextStyle? labelStyle;

  /// [ThemedNavigatorLabel] is a visual separator of the items in a [ThemedAppBar.items] or [ThemedSidebar.items].
  ThemedNavigatorLabel({
    super.label,
    super.labelText,
    this.labelStyle,
  }) : assert(label != null || labelText != null);
}

class ThemedNotificationItem {
  /// [key] is the key of the notification.
  final String? key;

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

  /// [at] is the time of the notification.
  final DateTime? at;

  /// [ThemedNotificationItem] is a helper class to handle the notifications of the view.
  const ThemedNotificationItem({
    this.key,
    required this.title,
    required this.content,
    this.icon,
    this.onTap,
    this.color,
    this.at,
  });

  /// [copyWith] creates a new instance of [ThemedNotificationItem] with the given parameters.
  ThemedNotificationItem copyWith({
    String? key,
    String? title,
    String? content,
    IconData? icon,
    VoidCallback? onTap,
    Color? color,
    DateTime? at,
  }) {
    return ThemedNotificationItem(
      key: key ?? this.key,
      title: title ?? this.title,
      content: content ?? this.content,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
      color: color ?? this.color,
      at: at ?? this.at,
    );
  }
}

enum ThemedSeparatorType {
  line,
  dots,
}
