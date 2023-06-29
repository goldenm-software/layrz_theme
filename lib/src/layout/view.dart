part of layrz_theme;

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
}

class ThemedNavigatorSeparator extends ThemedNavigatorItem {
  final ThemedSeparatorType type;

  /// [ThemedNavigatorSeparator] is a visual separator of the items in a [ThemedAppBar.items] or [ThemedDrawer.items].
  ThemedNavigatorSeparator({
    /// [type] is the type of the separator.
    this.type = ThemedSeparatorType.line,
  });
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
