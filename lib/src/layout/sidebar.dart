part of layrz_theme;

class ThemedSidebar extends StatefulWidget {
  final List<ThemedNavigatorItem> items;

  const ThemedSidebar({
    super.key,

    /// [items] is the list of buttons to be displayed in the drawer.
    this.items = const [],
  });

  @override
  State<ThemedSidebar> createState() => _ThemedSidebarState();
}

class _ThemedSidebarState extends State<ThemedSidebar> {
  final ScrollController _scrollController = ScrollController();

  bool get isMobile => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
  bool get isMacOS => !kIsWeb && Platform.isMacOS;
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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color drawerColor = isDark ? Colors.grey.shade900 : Theme.of(context).primaryColor;
    return Container(
      width: 65,
      height: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: generateContainerElevation(
        context: context,
        radius: 0,
        color: drawerColor,
      ).copyWith(
        color: drawerColor,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: widget.items.map((page) {
              return ThemedSidebarItem(
                item: page,
                children: (page is ThemedNavigatorPage) ? page.children : [],
                drawerColor: drawerColor,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class ThemedSidebarItem extends StatefulWidget {
  final ThemedNavigatorItem item;
  final List<ThemedNavigatorItem> children;
  final int depth;
  final Color drawerColor;

  const ThemedSidebarItem({
    super.key,
    required this.item,
    this.children = const [],
    this.depth = 0,
    required this.drawerColor,
  });

  @override
  State<ThemedSidebarItem> createState() => _ThemedSidebarItemState();
}

class _ThemedSidebarItemState extends State<ThemedSidebarItem> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  bool _isHover = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item is ThemedNavigatorSeparator) {
      ThemedNavigatorSeparator separator = widget.item as ThemedNavigatorSeparator;
      if (separator.type == ThemedSeparatorType.line) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Divider(color: validateColor(color: widget.drawerColor).withOpacity(0.2)),
        );
      }

      if (separator.type == ThemedSeparatorType.dots) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(10, (_) {
              return Container(
                width: 2,
                height: 2,
                decoration: BoxDecoration(
                  color: validateColor(color: widget.drawerColor).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        );
      }
    }

    String currentPath = ModalRoute.of(context)?.settings.name ?? '';

    bool isActive = false;

    if (widget.item is ThemedNavigatorPage) {
      isActive = currentPath.startsWith((widget.item as ThemedNavigatorPage).path);
    } else if (widget.item is ThemedNavigatorAction) {
      isActive = (widget.item as ThemedNavigatorAction).highlight;
    }

    Color contentColor = isActive
        ? isDark
            ? Colors.grey.shade900
            : Theme.of(context).primaryColor
        : validateColor(color: Theme.of(context).primaryColor);

    VoidCallback? onTap;

    if (widget.item is ThemedNavigatorPage) {
      onTap = () {
        Navigator.of(context).pushNamed((widget.item as ThemedNavigatorPage).path);
      };
    } else if (widget.item is ThemedNavigatorAction) {
      onTap = (widget.item as ThemedNavigatorAction).onTap;
    }

    IconData? icon;

    if (widget.item is ThemedNavigatorPage) {
      icon = (widget.item as ThemedNavigatorPage).icon;
    } else if (widget.item is ThemedNavigatorAction) {
      icon = (widget.item as ThemedNavigatorAction).icon;
    }

    EdgeInsets offsetDepth = EdgeInsets.zero;

    Widget content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 3).add(offsetDepth),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onHover: (value) => setState(() => _isHover = value),
        onTap: onTap,
        child: AnimatedContainer(
          duration: kHoverDuration,
          padding: const EdgeInsets.all(10),
          decoration: generateContainerElevation(
            context: context,
            elevation: 0,
            radius: 5,
            color: isActive
                ? Colors.white
                : _isHover
                    ? Colors.white.withOpacity(0.4)
                    : isDark
                        ? Colors.grey.shade900
                        : Theme.of(context).primaryColor,
          ).copyWith(
            color: isActive
                ? Colors.white
                : isDark
                    ? Colors.grey.shade900
                    : Theme.of(context).primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon ?? MdiIcons.help,
                color: contentColor,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );

    String message = "";

    if (widget.item.labelText == null) {
      if (widget.item.label is Text) {
        message = (widget.item.label as Text).data ?? "";
      } else {
        message = "${widget.item.label}";
      }
    } else {
      message = widget.item.labelText!;
    }

    return Tooltip(
      message: message,
      child: content,
    );
  }
}
