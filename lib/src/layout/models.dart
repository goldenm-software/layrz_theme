part of layout;

abstract class ThemedNavigatorItem {
  final Widget? label;
  final String? labelText;

  /// [ThemedNavigatorItem] is a helper class to handle the items of the view.
  ThemedNavigatorItem({
    /// [label] is the label of the view.
    /// Prevent use [label] and [labelText] at the same time.
    this.label,

    /// [labelText] is the label of the view.
    /// Prevent use [label] and [labelText] at the same time.
    this.labelText,
  });

  /// [topBarItemPadding] is the padding applied of the element when is rendered using [toAppBarItem].
  static EdgeInsets get topBarItemPadding => const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10);

  /// [sidebarItemPadding] is the padding applied of the element when is rendered using [toSidebarItem].
  static EdgeInsets get sidebarItemPadding => const EdgeInsets.symmetric(vertical: 5);

  /// [drawerItemPadding] is the padding applied of the element when is rendered using [toDrawerItem].
  static EdgeInsets get drawerItemPadding => const EdgeInsets.symmetric(vertical: 5);

  /// [toAppBarItem] is the widget to be displayed in the appbar.
  Widget toAppBarItem({
    required BuildContext context,
    required Color backgroundColor,
    int dotCount = 5,
    required ThemedNavigatorPushFunction onNavigatorPush,
    String? currentPath,
  }) {
    return Padding(
      padding: topBarItemPadding,
      child: label ?? Text(labelText ?? ''),
    );
  }

  /// [toSidebarItem] is the widget to be displayed in the drawer.
  Widget toSidebarItem({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 5,
    required ThemedNavigatorPushFunction onNavigatorPush,
    String? currentPath,
  }) {
    return Padding(
      padding: sidebarItemPadding,
      child: label ?? Text(labelText ?? ''),
    );
  }

  /// [toDrawerItem] is the widget to be displayed in the drawer.
  Widget toDrawerItem({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 5,
    VoidCallback? callback,
    bool fromScaffold = false,
    required ThemedNavigatorPushFunction onNavigatorPush,
    required VoidCallback onNavigatorPop,
    String? currentPath,
  }) {
    return Padding(
      padding: sidebarItemPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label ??
              Text(
                labelText ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: validateColor(color: backgroundColor),
                    ),
              )
        ],
      ),
    );
  }
}

class ThemedNavigatorPage extends ThemedNavigatorItem {
  final IconData? icon;
  final String path;
  final List<ThemedNavigatorItem> children;

  /// [ThemedNavigatorPage] is a helper class to handle the view and their children.
  ThemedNavigatorPage({
    super.label,
    super.labelText,

    /// [icon] is the icon of the view.
    this.icon,

    /// [path] is the path of the view.
    required this.path,

    /// [children] is the children of the view. by default will be empty.
    this.children = const [],
  }) : assert(label != null || labelText != null);

  /// [toAppBarItem] is the widget to be displayed in the appbar.
  @override
  Widget toAppBarItem({
    required BuildContext context,
    required Color backgroundColor,
    int dotCount = 5,
    required ThemedNavigatorPushFunction onNavigatorPush,
    String? currentPath,
  }) {
    String localPath = currentPath ?? ModalRoute.of(context)?.settings.name ?? '';
    bool highlight = localPath.startsWith(path);

    return ThemedNavigatorAction(
      labelText: labelText,
      label: label,
      icon: icon,
      onTap: () {
        final subpages = children.whereType<ThemedNavigatorPage>();
        if (subpages.isNotEmpty) {
          onNavigatorPush.call(subpages.first.path);
        } else {
          onNavigatorPush.call(path);
        }
      },
      highlight: highlight,
    ).toAppBarItem(
      context: context,
      backgroundColor: backgroundColor,
      onNavigatorPush: onNavigatorPush,
    );
  }

  /// [toSidebarItem] is the widget to be displayed in the drawer.
  @override
  Widget toSidebarItem({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 5,
    required ThemedNavigatorPushFunction onNavigatorPush,
    String? currentPath,
  }) {
    String localPath = currentPath ?? ModalRoute.of(context)?.settings.name ?? '';
    bool highlight = localPath.startsWith(path);

    return ThemedNavigatorAction(
      labelText: labelText,
      label: label,
      icon: icon,
      onTap: () {
        final subpages = children.whereType<ThemedNavigatorPage>();
        if (subpages.isNotEmpty) {
          onNavigatorPush.call(subpages.first.path);
        } else {
          onNavigatorPush.call(path);
        }
      },
      highlight: highlight,
    ).toSidebarItem(
      context: context,
      backgroundColor: backgroundColor,
      width: width,
      height: height,
      onNavigatorPush: onNavigatorPush,
    );
  }

  /// [toDrawerItem] is the widget to be displayed in the drawer.
  @override
  Widget toDrawerItem({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 40,
    VoidCallback? callback,
    bool fromScaffold = false,
    required ThemedNavigatorPushFunction onNavigatorPush,
    required VoidCallback onNavigatorPop,
    String? currentPath,
  }) {
    String localPath = currentPath ?? ModalRoute.of(context)?.settings.name ?? '';
    bool highlight = localPath.startsWith(path);
    bool isExpanded = highlight;

    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ThemedNavigatorAction(
              labelText: labelText,
              label: label,
              icon: icon,
              onTap:
                  children.isEmpty ? () => onNavigatorPush.call(path) : () => setState(() => isExpanded = !isExpanded),
              highlight: highlight,
              forceOnTap: true,
            ).toDrawerItem(
              context: context,
              backgroundColor: backgroundColor,
              width: width,
              height: height,
              callback: callback,
              onNavigatorPush: onNavigatorPush,
              onNavigatorPop: onNavigatorPop,
              suffixIcon: children.isEmpty
                  ? null
                  : isExpanded
                      ? MdiIcons.chevronDown
                      : MdiIcons.chevronUp,
            ),
            if (isExpanded) ...[
              for (final child in children)
                child.toDrawerItem(
                  context: context,
                  backgroundColor: backgroundColor,
                  width: width,
                  height: height,
                  dotCount: dotCount,
                  callback: callback,
                  onNavigatorPush: onNavigatorPush,
                  onNavigatorPop: onNavigatorPop,
                ),
            ],
          ],
        );
      },
    );
  }
}

class ThemedNavigatorAction extends ThemedNavigatorItem {
  final IconData? icon;
  final VoidCallback onTap;
  final bool highlight;
  final bool forceOnTap;

  /// [ThemedNavigatorAction] is a helper class to handle the actions of the view.
  ThemedNavigatorAction({
    super.label,
    super.labelText,

    /// [icon] is the icon of the view.
    this.icon,

    /// [path] is the path of the view.
    required this.onTap,

    /// [highlight] indicates if the action is highlighted.
    this.highlight = false,

    /// [forceOnTap] indicates if the action should be forced to be tapped.
    this.forceOnTap = false,
  }) : assert(label != null || labelText != null);

  /// [toAppBarItem] is the widget to be displayed in the appbar.
  @override
  Widget toAppBarItem({
    required BuildContext context,
    required Color backgroundColor,
    int dotCount = 5,
    required ThemedNavigatorPushFunction onNavigatorPush,
    String? currentPath,
  }) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color activeColor = isDark ? Colors.white : Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: highlight ? activeColor.withOpacity(0.2) : backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: (highlight && !forceOnTap) ? null : onTap,
            child: super.toAppBarItem(
              context: context,
              backgroundColor: backgroundColor,
              onNavigatorPush: onNavigatorPush,
            ),
          ),
        ),
      ),
    );
  }

  /// [toSidebarItem] is the widget to be displayed in the appbar.
  @override
  Widget toSidebarItem({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 5,
    required ThemedNavigatorPushFunction onNavigatorPush,
    String? currentPath,
  }) {
    String text = labelText ?? '';

    if (label is Text) {
      text = (label as Text).data ?? '';
    }

    return Padding(
      padding: ThemedNavigatorItem.sidebarItemPadding,
      child: Tooltip(
        message: text,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: highlight ? validateColor(color: backgroundColor) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: (highlight && !forceOnTap) ? null : onTap,
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Center(
                  child: Icon(
                    icon ?? MdiIcons.help,
                    size: 16,
                    color: highlight ? backgroundColor : validateColor(color: backgroundColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [toDrawerItem] is the widget to be displayed in the appbar.
  @override
  Widget toDrawerItem({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 5,
    IconData? suffixIcon,
    VoidCallback? callback,
    bool fromScaffold = false,
    required ThemedNavigatorPushFunction onNavigatorPush,
    required VoidCallback onNavigatorPop,
    String? currentPath,
  }) {
    return Padding(
      padding: ThemedNavigatorItem.drawerItemPadding,
      child: Container(
        decoration: BoxDecoration(
          color: highlight ? validateColor(color: backgroundColor) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: (highlight && !forceOnTap)
                ? null
                : () {
                    callback?.call();
                    if (fromScaffold) onNavigatorPop.call();
                    onTap.call();
                  },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon ?? MdiIcons.help,
                      size: 16,
                      color: highlight ? backgroundColor : validateColor(color: backgroundColor),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: label ??
                        Text(
                          labelText ?? '',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: highlight ? backgroundColor : validateColor(color: backgroundColor),
                              ),
                        ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 10),
                    Icon(
                      suffixIcon,
                      size: 16,
                      color: highlight ? backgroundColor : validateColor(color: backgroundColor),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ThemedNavigatorSeparator extends ThemedNavigatorItem {
  final ThemedSeparatorType type;

  /// [ThemedNavigatorSeparator] is a visual separator of the items in a [ThemedAppBar.items] or [ThemedDrawer.items].
  ThemedNavigatorSeparator({
    /// [type] is the type of the separator.
    this.type = ThemedSeparatorType.line,
  });

  /// [toAppBarItem] is the widget to be displayed in the appbar.
  @override
  Widget toAppBarItem({
    required BuildContext context,
    required Color backgroundColor,
    int dotCount = 5,
    required ThemedNavigatorPushFunction onNavigatorPush,
    String? currentPath,
  }) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (type == ThemedSeparatorType.line) {
      return Padding(
        padding: ThemedNavigatorItem.topBarItemPadding,
        child: const VerticalDivider(),
      );
    }

    return Padding(
      padding: ThemedNavigatorItem.topBarItemPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dotCount, (_) {
          return Container(
            width: 2,
            height: 2,
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }

  /// [toSidebarItem] is the widget to be displayed in the drawer.
  @override
  Widget toSidebarItem({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 5,
    required ThemedNavigatorPushFunction onNavigatorPush,
    String? currentPath,
  }) {
    if (type == ThemedSeparatorType.line) {
      return Padding(
        padding: ThemedNavigatorItem.sidebarItemPadding,
        child: const Divider(),
      );
    }

    return Padding(
      padding: ThemedNavigatorItem.sidebarItemPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dotCount, (_) {
          return Container(
            width: 2,
            height: 2,
            decoration: BoxDecoration(
              color: validateColor(color: backgroundColor).withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }

  /// [toSidebarItem] is the widget to be displayed in the drawer.
  @override
  Widget toDrawerItem({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 40,
    VoidCallback? callback,
    bool fromScaffold = false,
    required ThemedNavigatorPushFunction onNavigatorPush,
    required VoidCallback onNavigatorPop,
    String? currentPath,
  }) {
    if (type == ThemedSeparatorType.line) {
      return Padding(
        padding: ThemedNavigatorItem.sidebarItemPadding,
        child: const Divider(),
      );
    }

    return Padding(
      padding: ThemedNavigatorItem.sidebarItemPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(dotCount, (_) {
          return Container(
            width: 2,
            height: 2,
            decoration: BoxDecoration(
              color: validateColor(color: backgroundColor).withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}

enum ThemedSeparatorType {
  line,
  dots,
}

class ThemedNavigatorLabel extends ThemedNavigatorItem {
  final TextStyle? labelStyle;

  /// [ThemedNavigatorLabel] is a visual separator of the items in a [ThemedAppBar.items] or [ThemedDrawer.items].
  ThemedNavigatorLabel({
    super.label,
    super.labelText,

    /// [labelStyle] is the style of the label. Only applies when [labelText] is not null.
    this.labelStyle,
  }) : assert(label != null || labelText != null);

  /// [toDrawerItem] is the widget to be displayed in the drawer.
  @override
  Widget toDrawerItem({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 5,
    VoidCallback? callback,
    bool fromScaffold = false,
    required ThemedNavigatorPushFunction onNavigatorPush,
    required VoidCallback onNavigatorPop,
    String? currentPath,
  }) {
    return Padding(
      padding: ThemedNavigatorItem.drawerItemPadding.add(const EdgeInsets.all(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label ??
              Text(
                labelText ?? '',
                style: labelStyle?.copyWith(
                  color: validateColor(color: backgroundColor).withOpacity(0.5),
                ),
              )
        ],
      ),
    );
  }

  /// [toAppBarItem] is the widget to be displayed in the appbar.
  @override
  Widget toAppBarItem({
    required BuildContext context,
    required Color backgroundColor,
    int dotCount = 5,
    required ThemedNavigatorPushFunction onNavigatorPush,
    String? currentPath,
  }) {
    return Padding(
      padding: ThemedNavigatorItem.topBarItemPadding,
      child: label ??
          Text(
            labelText ?? '',
            style: labelStyle?.copyWith(
              color: validateColor(color: backgroundColor).withOpacity(0.5),
            ),
          ),
    );
  }
}

class ThemedNotificationItem {
  final String title;
  final String content;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? color;

  /// [ThemedNotificationItem] is a helper class to handle the notifications of the view.
  const ThemedNotificationItem({
    /// [title] is the title of the notification.
    required this.title,

    /// [content] is the content of the notification.
    required this.content,

    /// [icon] is the icon of the notification.
    this.icon,

    /// [onTap] is the action to be executed when the notification is tapped.
    this.onTap,

    /// [color] is the color of the notification.
    this.color,
  });
}
