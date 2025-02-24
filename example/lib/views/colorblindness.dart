import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/store/store.dart';
import 'package:vxstate/vxstate.dart';

const kCode = '''
return ColorFiltered(
  colorFilter: ColorblindMode.deuteranopia.filter(1),
  child: MaterialApp.router(
    title: 'Layrz Theme Example',
    themeMode: store.themeMode,
    theme: generateLightTheme(titleFont: font, bodyFont: font),
    darkTheme: generateDarkTheme(titleFont: font, bodyFont: font),
    debugShowCheckedModeBanner: false,
    routerConfig: router,
    builder: (context, child) {
      return ThemedSnackbarMessenger(
        child: child ?? const SizedBox(),
      );
    },
  ),
);
''';

class ColorblindnessView extends StatefulWidget {
  const ColorblindnessView({super.key});

  @override
  State<ColorblindnessView> createState() => _ColorblindnessViewState();
}

class _ColorblindnessViewState extends State<ColorblindnessView> {
  AppStore get store => VxState.store as AppStore;

  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Colorblind modes",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "Layrz has supported 6 colorblind modes, you can use them like this:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            const ThemedCodeSnippet(
              code: kCode,
              maxLines: 1000,
            ),
            const SizedBox(height: 10),
            Text(
              "You can test it out on this app by",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            ThemedSelectInput(
              labelText: 'Select a colorblind mode',
              value: store.colorblindMode,
              items: ColorblindMode.values.map((e) {
                return ThemedSelectItem(
                  label: e.label,
                  value: e,
                );
              }).toList(),
              onChanged: (value) => SetColorblindMode(value?.value ?? ColorblindMode.normal),
            ),
            const SizedBox(height: 10),
            Text("Strength: ${(store.colorblindStrength * 100).toInt()}%"),
            Slider(
              value: store.colorblindStrength,
              min: 0,
              max: 1,
              divisions: 100,
              onChanged: (value) => SetColorblindStrength(value),
            ),
            Center(
              child: Image.asset('assets/color_palette.png', width: 600),
            ),
          ],
        ),
      ),
    );
  }
}

extension BlindName on ColorblindMode {
  String get label {
    switch (this) {
      case ColorblindMode.normal:
        return 'Normal (No Colorblindness)';
      case ColorblindMode.protanopia:
        return 'Protanopia (Red-Blind)';
      case ColorblindMode.protanomaly:
        return 'Protanomaly (Red-Weak)';
      case ColorblindMode.deuteranopia:
        return 'Deuteranopia (Green-Blind)';
      case ColorblindMode.deuteranomaly:
        return 'Deuteranomaly (Green-Weak)';
      case ColorblindMode.tritanopia:
        return 'Tritanopia (Blue-Blind)';
      case ColorblindMode.tritanomaly:
        return 'Tritanomaly (Blue-Weak)';
    }
  }
}
