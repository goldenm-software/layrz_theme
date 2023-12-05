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

  /// [ThemedSidebar] is the sidebar of the app in desktop mode, only will work in desktop.
  /// On mobile or tablet devices, this widget could not work as expected.
  const ThemedSidebar({
    super.key,
    this.items = const [],
    this.backgroundColor,
    this.onNavigatorPush,
    this.currentPath,
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

  final ScrollController _scrollController = ScrollController();
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
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.items
                .where((item) {
                  bool c1 = item is ThemedNavigatorPage;
                  bool c2 = item is ThemedNavigatorAction;
                  bool c3 = item is ThemedNavigatorSeparator;

                  return c1 || c2 || c3;
                })
                .map((item) => item.toSidebarItem(
                      context: context,
                      backgroundColor: backgroundColor,
                      width: ThemedNavigatorItem.sidebarSize,
                      height: ThemedNavigatorItem.sidebarSize,
                      onNavigatorPush: onNavigatorPush,
                      currentPath: widget.currentPath,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
