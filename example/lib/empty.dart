import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';

class EmptyView extends StatefulWidget {
  final String name;

  const EmptyView({
    super.key,
    this.name = 'Generic View',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ThemedButton(
            labelText: "Show snackbar",
            onTap: () {
              showThemedSnackbar(ThemedSnackbar(
                icon: Icons.help,
                context: context,
                message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut sodales nisl et odio ",
              ));
            },
          ),
          Text("Empty view ${widget.name}"),
        ],
      ),
    );
  }
}
