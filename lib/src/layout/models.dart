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

  /// [horizontalPadding] is the padding applied of the element when is rendered using [toHorizontalWidget].
  static EdgeInsets get horizontalPadding => const EdgeInsets.symmetric(vertical: 2.5, horizontal: 10);

  /// [verticalPadding] is the padding applied of the element when is rendered using [toVerticalWidget].
  static EdgeInsets get verticalPadding => const EdgeInsets.symmetric(vertical: 5);

  /// [toHorizontalWidget] is the widget to be displayed in the appbar.
  Widget toHorizontalWidget({
    required BuildContext context,
    required Color backgroundColor,
    int dotCount = 5,
  }) {
    return Padding(
      padding: horizontalPadding,
      child: label ?? Text(labelText ?? ''),
    );
  }

  /// [toVerticalWidget] is the widget to be displayed in the drawer.
  Widget toVerticalWidget({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 5,
  }) {
    return Padding(
      padding: verticalPadding,
      child: label ?? Text(labelText ?? ''),
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

  /// [toHorizontalWidget] is the widget to be displayed in the appbar.
  @override
  Widget toHorizontalWidget({
    required BuildContext context,
    required Color backgroundColor,
    int dotCount = 5,
  }) {
    String currentPath = ModalRoute.of(context)?.settings.name ?? '';
    bool highlight = currentPath.startsWith(path);

    return ThemedNavigatorAction(
      labelText: labelText,
      label: label,
      icon: icon,
      onTap: () {
        final subpages = children.whereType<ThemedNavigatorPage>();
        if (subpages.isNotEmpty) {
          Navigator.of(context).pushNamed(subpages.first.path);
        } else {
          Navigator.of(context).pushNamed(path);
        }
      },
      highlight: highlight,
    ).toHorizontalWidget(
      context: context,
      backgroundColor: backgroundColor,
    );
  }

  /// [toVerticalWidget] is the widget to be displayed in the drawer.
  @override
  Widget toVerticalWidget({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 5,
  }) {
    String currentPath = ModalRoute.of(context)?.settings.name ?? '';
    bool highlight = currentPath.startsWith(path);

    return ThemedNavigatorAction(
      labelText: labelText,
      label: label,
      icon: icon,
      onTap: () => Navigator.of(context).pushNamed(path),
      highlight: highlight,
    ).toVerticalWidget(
      context: context,
      backgroundColor: backgroundColor,
      width: width,
      height: height,
    );
  }
}

class ThemedNavigatorAction extends ThemedNavigatorItem {
  final IconData? icon;
  final VoidCallback onTap;
  final bool highlight;

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
  }) : assert(label != null || labelText != null);

  /// [toHorizontalWidget] is the widget to be displayed in the appbar.
  @override
  Widget toHorizontalWidget({
    required BuildContext context,
    required Color backgroundColor,
    int dotCount = 5,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: highlight ? Theme.of(context).primaryColor.withOpacity(0.2) : backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: highlight ? null : onTap,
            child: super.toHorizontalWidget(
              context: context,
              backgroundColor: backgroundColor,
            ),
          ),
        ),
      ),
    );
  }

  /// [toVerticalWidget] is the widget to be displayed in the appbar.
  @override
  Widget toVerticalWidget({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 5,
  }) {
    String text = labelText ?? '';

    if (label is Text) {
      text = (label as Text).data ?? '';
    }

    return Padding(
      padding: ThemedNavigatorItem.verticalPadding,
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
              onTap: highlight ? null : onTap,
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Center(
                  child: Icon(
                    icon ?? MdiIcons.help,
                    size: 16,
                    color: highlight ? Theme.of(context).primaryColor : validateColor(color: backgroundColor),
                  ),
                ),
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

  /// [toHorizontalWidget] is the widget to be displayed in the appbar.
  @override
  Widget toHorizontalWidget({
    required BuildContext context,
    required Color backgroundColor,
    int dotCount = 5,
  }) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (type == ThemedSeparatorType.line) {
      return Padding(
        padding: ThemedNavigatorItem.horizontalPadding,
        child: const VerticalDivider(),
      );
    }

    return Padding(
      padding: ThemedNavigatorItem.horizontalPadding,
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

  /// [toVerticalWidget] is the widget to be displayed in the drawer.
  @override
  Widget toVerticalWidget({
    required BuildContext context,
    required Color backgroundColor,
    double? width,
    double? height,
    int dotCount = 5,
  }) {
    if (type == ThemedSeparatorType.line) {
      return Padding(
        padding: ThemedNavigatorItem.verticalPadding,
        child: const Divider(),
      );
    }

    return Padding(
      padding: ThemedNavigatorItem.verticalPadding,
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
  /// [ThemedNavigatorLabel] is a visual separator of the items in a [ThemedAppBar.items] or [ThemedDrawer.items].
  ThemedNavigatorLabel({
    super.label,
    super.labelText,
  }) : assert(label != null || labelText != null);
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
