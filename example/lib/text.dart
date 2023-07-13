import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';

class TextView extends StatefulWidget {
  final String name;

  const TextView({
    super.key,
    this.name = 'Generic View',
  });

  @override
  State<TextView> createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  List<int> selected = [];
  List<ThemedSelectItem<int>> get choices => [];

  @override
  Widget build(BuildContext context) {
    return Layout(
      showDrawer: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("displayLarge", style: Theme.of(context).textTheme.displayLarge),
              Text("displayMedium", style: Theme.of(context).textTheme.displayMedium),
              Text("displaySmall", style: Theme.of(context).textTheme.displaySmall),
              Text("headlineMedium", style: Theme.of(context).textTheme.headlineMedium),
              Text("headlineSmall", style: Theme.of(context).textTheme.headlineSmall),
              Text("titleLarge", style: Theme.of(context).textTheme.titleLarge),
              Text("titleMedium", style: Theme.of(context).textTheme.titleMedium),
              Text("titleSmall", style: Theme.of(context).textTheme.titleSmall),
              Text("bodyLarge", style: Theme.of(context).textTheme.bodyLarge),
              Text("bodyMedium", style: Theme.of(context).textTheme.bodyMedium),
              Text("bodySmall", style: Theme.of(context).textTheme.bodySmall),
              Text("labelLarge", style: Theme.of(context).textTheme.labelLarge),
              Text("labelMedium", style: Theme.of(context).textTheme.labelMedium),
              Text("labelSmall", style: Theme.of(context).textTheme.labelSmall),
              Text("Lorem ipsum dolor sit amet " * 100, style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
