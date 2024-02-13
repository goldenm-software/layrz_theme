part of '../layout.dart';

class ThemedSidebar extends StatefulWidget {
  /// [items] is the list of buttons to be displayed in the drawer.
  final List<ThemedNavigatorItem> items;

  /// [backgroundColor] is the background color of the sidebar.
  /// If null, it will be the primary color of the theme.
  final Color? backgroundColor;

  /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
  /// By default is `Navigator.of(context).pushNamed`
  final ThemedNavigatorPushFunction? onNavigatorPush;

  /// [currentPath] is the current path of the navigator. Overrides the default path detection.
  /// By default, we get the current path from `ModalRoute.of(context)?.settings.name`.
  final String? currentPath;

  /// [persistentItems] is the list of buttons to be displayed in the drawer.
  final List<ThemedNavigatorItem> persistentItems;

  /// [ThemedSidebar] is the sidebar of the app in desktop mode, only will work in desktop.
  /// On mobile or tablet devices, this widget could not work as expected.
  const ThemedSidebar({
    super.key,
    this.items = const [],
    this.backgroundColor,
    this.onNavigatorPush,
    this.currentPath,
    this.persistentItems = const [],
  });

  @override
  State<ThemedSidebar> createState() => _ThemedSidebarState();

  static double get width => 60;
}

class _ThemedSidebarState extends State<ThemedSidebar> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get backgroundColor =>
      widget.backgroundColor ?? (isDark ? Colors.grey.shade900 : Theme.of(context).primaryColor);

  ThemedNavigatorPushFunction get onNavigatorPush =>
      widget.onNavigatorPush ?? (path) => Navigator.of(context).pushNamed(path);
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ThemedSidebar.width,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 10,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return _buildItem(widget.items[index]);
                },
              ),
            ),
            if (widget.persistentItems.isNotEmpty) ...[
              _buildItem(ThemedNavigatorSeparator()),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.persistentItems.length,
                itemBuilder: (context, index) {
                  return _buildItem(widget.persistentItems[index]);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItem(ThemedNavigatorItem item) {
    if (item is ThemedNavigatorPage) {
      if (item.children.isNotEmpty) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: item.children.length,
          itemBuilder: (context, index) {
            final child = item.children[index];
            return _buildItem(child);
          },
        );
      }

      bool highlight = (widget.currentPath ?? '').startsWith(item.path);

      Color backgroundColor = highlight ? validateColor(color: Theme.of(context).primaryColor) : Colors.transparent;

      return ThemedTooltip(
        position: ThemedTooltipPosition.right,
        message: item.labelText ?? item.label?.toString() ?? '',
        child: Container(
          margin: const EdgeInsets.all(5),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: backgroundColor,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => item.onTap(onNavigatorPush),
              hoverColor: validateColor(color: backgroundColor).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  item.icon ?? MdiIcons.help,
                  size: 15,
                  color: validateColor(color: backgroundColor),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (item is ThemedNavigatorAction) {
      return ThemedTooltip(
        position: ThemedTooltipPosition.right,
        message: item.labelText ?? item.label?.toString() ?? '',
        child: Container(
          margin: const EdgeInsets.all(5),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: backgroundColor,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item.onTap,
              hoverColor: validateColor(color: backgroundColor).withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  item.icon ?? MdiIcons.help,
                  size: 15,
                  color: validateColor(color: backgroundColor),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (item is ThemedNavigatorSeparator) {
      Color dividerColor = validateColor(color: backgroundColor).withOpacity(0.2);
      if (item.type == ThemedSeparatorType.line) {
        return Divider(
          indent: 5,
          endIndent: 5,
          color: dividerColor,
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (_) {
            return Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: dividerColor,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      );
    }

    return const SizedBox();
  }
}
