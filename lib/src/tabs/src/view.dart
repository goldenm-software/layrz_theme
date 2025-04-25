part of '../tabs.dart';

class ThemedTabView extends StatefulWidget {
  /// [tabs] is the list of tabs to display
  final List<ThemedTab> tabs;

  /// [padding] is the padding of the tab bar view
  final EdgeInsetsGeometry padding;

  /// [crossAxisAlignment] is the cross axis alignment of the tab bar view
  final CrossAxisAlignment crossAxisAlignment;

  /// [mainAxisAlignment] is the main axis alignment of the tab bar view
  final MainAxisAlignment mainAxisAlignment;

  /// [animationDuration] is the duration of the animation
  final Duration animationDuration;

  /// [physics] is the physics of the tab bar view
  final ScrollPhysics? physics;

  /// [separatorPadding] is the padding of the separator between the tab and the tab view
  final EdgeInsetsGeometry separatorPadding;

  /// [showArrows] is the show arrows of the tab bar view
  final bool showArrows;

  /// [ThemedTabView] is a tab for the [TabBar] widget
  ///
  /// Be careful!
  /// This widget should be in a defined size, otherwise, you will get an overflow.
  const ThemedTabView({
    super.key,
    required this.tabs,
    this.padding = const EdgeInsets.all(10),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.animationDuration = const Duration(milliseconds: 250),
    this.physics,
    this.separatorPadding = const EdgeInsets.only(top: 10),
    this.showArrows = false,
  });

  @override
  State<ThemedTabView> createState() => _ThemedTabViewState();
}

class _ThemedTabViewState extends State<ThemedTabView> with TickerProviderStateMixin {
  late TabController _tabController;
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get color => isDark ? Colors.white : Colors.black;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      animationDuration: widget.animationDuration,
    );
  }

  @override
  void didUpdateWidget(covariant ThemedTabView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tabs.length != widget.tabs.length || oldWidget.animationDuration != widget.animationDuration) {
      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        animationDuration: widget.animationDuration,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: widget.crossAxisAlignment,
        mainAxisAlignment: widget.mainAxisAlignment,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              tabBarTheme: Theme.of(context).tabBarTheme.copyWith(tabAlignment: TabAlignment.start),
            ),
            child: Row(
              children: [
                if (widget.showArrows) ...[
                  ThemedButton(
                    style: ThemedButtonStyle.filledTonalFab,
                    labelText: '',
                    tooltipEnabled: false,
                    height: 40,
                    fontSize: 30,
                    color: color,
                    icon: LayrzIcons.solarOutlineAltArrowLeft,
                    isDisabled: _tabController.index == 0,
                    onTap: () {
                      if (_tabController.index == 0) return;
                      _tabController.animateTo(_tabController.index - 1);
                      setState(() {});
                    },
                  ),
                ],
                Expanded(
                  child: TabBar(
                    isScrollable: true,
                    tabs: widget.tabs,
                    controller: _tabController,
                  ),
                ),
                if (widget.showArrows) ...[
                  ThemedButton(
                    style: ThemedButtonStyle.filledTonalFab,
                    labelText: '',
                    tooltipEnabled: false,
                    height: 40,
                    fontSize: 30,
                    color: color,
                    icon: LayrzIcons.solarOutlineAltArrowRight,
                    isDisabled: _tabController.index == widget.tabs.length - 1,
                    onTap: () {
                      if (_tabController.index == widget.tabs.length - 1) return;
                      _tabController.animateTo(_tabController.index + 1);
                      setState(() {});
                    },
                  ),
                ],
              ],
            ),
          ),
          Padding(padding: widget.separatorPadding),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: widget.physics,
              children: widget.tabs.map((e) => e.child).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
