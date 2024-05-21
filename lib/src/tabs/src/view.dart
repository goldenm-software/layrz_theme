part of '../tabs.dart';

class ThemedTabView extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DefaultTabController(
        length: tabs.length,
        animationDuration: animationDuration,
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                tabBarTheme: Theme.of(context).tabBarTheme.copyWith(tabAlignment: TabAlignment.start),
              ),
              child: TabBar(
                isScrollable: true,
                tabs: tabs,
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: physics,
                children: tabs.map((e) => e.child).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
