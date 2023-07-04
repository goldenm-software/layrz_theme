import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';

class CardsView extends StatefulWidget {
  final String name;
  final VoidCallback toggleTheme;
  const CardsView({
    super.key,
    this.name = 'Generic View',
    required this.toggleTheme,
  });

  @override
  State<CardsView> createState() => _CardsViewState();
}

class _CardsViewState extends State<CardsView> {
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
            ...List.generate(6, (i) {
              return Padding(
                padding: const EdgeInsets.all(30),
                child: Container(
                  decoration: generateContainerElevation(context: context, elevation: i),
                  height: 50,
                  width: 100,
                  child: Center(
                    child: Text("Elevation $i"),
                  ),
                ),
              );
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
