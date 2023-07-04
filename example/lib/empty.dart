import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';

class EmptyView extends StatefulWidget {
  final String name;
  final VoidCallback toggleTheme;
  const EmptyView({
    super.key,
    this.name = 'Generic View',
    required this.toggleTheme,
  });

  @override
  State<EmptyView> createState() => _EmptyViewState();
}

class _EmptyViewState extends State<EmptyView> {
  List<int> selected = [];
  List<ThemedSelectItem<int>> get choices => [];

  @override
  Widget build(BuildContext context) {
    return Layout(
      showDrawer: true,
      toggleTheme: widget.toggleTheme,
      body: Center(
        child: Text("Empty view ${widget.name}"),
      ),
    );
  }
}
