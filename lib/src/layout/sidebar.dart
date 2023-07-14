part of layout;

class ThemedSidebar extends StatefulWidget {
  final List<ThemedNavigatorItem> items;
  final bool contracted;
  final Color? backgroundColor;
  final ThemedNavigatorPushFunction? onNavigatorPush;

  const ThemedSidebar({
    super.key,

    /// [items] is the list of buttons to be displayed in the drawer.
    this.items = const [],

    /// [contracted] is a boolean that enables the contracted sidebar.
    this.contracted = false,

    /// [backgroundColor] is the background color of the sidebar.
    /// If null, it will be the primary color of the theme.
    this.backgroundColor,

    /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
    /// By default is `Navigator.of(context).pushNamed`
    this.onNavigatorPush,
  });

  @override
  State<ThemedSidebar> createState() => _ThemedSidebarState();

  static ThemedSidebar asContracted({
    /// [items] is the list of buttons to be displayed in the drawer.
    List<ThemedNavigatorItem> items = const [],

    /// [onNavigatorPush] is the callback to be executed when a navigator item is tapped.
    /// By default is `Navigator.of(context).pushNamed`
    ThemedNavigatorPushFunction? onNavigatorPush,
  }) {
    return ThemedSidebar(
      items: items,
      contracted: true,
      onNavigatorPush: onNavigatorPush,
    );
  }
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
      width: 50,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      color: backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                      width: 30,
                      height: 30,
                      onNavigatorPush: onNavigatorPush,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
