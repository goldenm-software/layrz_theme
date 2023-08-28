import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(30),
            decoration: generateContainerElevation(context: context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ThemedImage(
                  width: 150,
                  height: 50,
                  path: 'https://cdn.layrz.com/resources/layrz/logo/${isDark ? 'white' : 'normal'}.png',
                ),
                const SizedBox(height: 20),
                Text(
                  "Welcome to Layrz Theme!",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Layrz Theme is a set of tools, widgets and generators to help you to create an "
                  "application easily, fast and with a good quality using the Layrz design standard.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 5,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                Text(
                  "Feel free to check out the different views available on this example to see how "
                  "to use the different components and tools provided by Layrz Theme.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 5,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                const Layo(
                  size: 100,
                  emotion: LayoEmotions.mrLayo,
                ),
                const SizedBox(height: 20),
                ThemedButton(
                  labelText: "Let's go!",
                  icon: MdiIcons.rocketLaunch,
                  onTap: () {
                    context.go('/home');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
