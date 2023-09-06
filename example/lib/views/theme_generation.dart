import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/store/store.dart';

class ThemeGenerationView extends StatefulWidget {
  const ThemeGenerationView({super.key});

  @override
  State<ThemeGenerationView> createState() => _ThemeGenerationViewState();
}

class _ThemeGenerationViewState extends State<ThemeGenerationView> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Why?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "Layrz theme changes many default properties of the Material Design theme, "
              "like the primary color, the accent color, the text theme, etc. "
              "This is because we want to make the development of apps faster and easier, "
              "so you don't have to change the default properties of the Material Design theme "
              "every time you start a new project.",
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            Text(
              "How to use it?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "To configure the light theme, you only need to add this property to your MaterialApp:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const ThemedCodeSnippet(
              code: """MaterialApp(
  // ...
  theme: generateLightTheme(), // <--
  // ...
)""",
            ),
            const SizedBox(height: 10),
            Text(
              "To configure the dark theme, you only need to add this property to your MaterialApp:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const ThemedCodeSnippet(
              code: """MaterialApp(
  // ...
  theme: generateLightTheme(),
  darkTheme: generateDarkTheme(), // <--
  // ...
)""",
            ),
            const SizedBox(height: 10),
            Text(
              "By default, those generators uses the primary color of Layrz (0xFF${kPrimaryColor.toHex().substring(1, 7)})",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Text(
              "But, you can change it using the argument mainColor of the generators, like the following example:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const ThemedCodeSnippet(
              code: "generateLightTheme(mainColor: Colors.purple)",
            ),
            const SizedBox(height: 10),
            Text(
              "Also, you can use the default themes of Flutter using the property theme of the generators, "
              "like the following example:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const ThemedCodeSnippet(
              code: "generateLightTheme(theme: \"RED\")",
            ),
            const SizedBox(height: 10),
            Text(
              "This strings come from the enum AppTheme from the package layrz_models",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
