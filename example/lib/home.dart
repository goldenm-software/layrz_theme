import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';

class HomeView extends StatefulWidget {
  final String name;
  final VoidCallback toggleTheme;
  const HomeView({
    super.key,
    this.name = 'Generic View',
    required this.toggleTheme,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<int> selected = [];
  List<ThemedSelectItem<int>> get choices => [];

  @override
  Widget build(BuildContext context) {
    return Layout(
      toggleTheme: widget.toggleTheme,
      showDrawer: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThemedButton(
              labelText: "Show dialog",
              onTap: () {
                showThemedSnackbar(ThemedSnackbar(
                  icon: Icons.help,
                  context: context,
                  message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut sodales nisl et odio ",
                ));
              },
            ),
            ThemedButton(
              labelText: "Show dialog [title]",
              onTap: () {
                showThemedSnackbar(ThemedSnackbar(
                  icon: Icons.help,
                  context: context,
                  title: 'Title',
                  message: "This is a snackbar",
                ));
              },
            ),
            const SizedBox(height: 10),
            ThemedButton(
              labelText: "Open dialog",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("This is a dialog"),
                            ThemedButton(
                              labelText: "Close dialog",
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
