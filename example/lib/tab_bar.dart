import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';

class TabView extends StatefulWidget {
  final String name;
  final VoidCallback toggleTheme;
  const TabView({
    super.key,
    this.name = 'Generic View',
    required this.toggleTheme,
  });

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  List<int> selected = [];
  List<ThemedSelectItem<int>> get choices => [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      showDrawer: true,
      toggleTheme: widget.toggleTheme,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Tab 1"),
              Tab(text: "Tab 2"),
              Tab(text: "Tab 3"),
            ],
          ),
        ],
      ),
    );
  }
}
