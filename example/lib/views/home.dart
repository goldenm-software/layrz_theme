import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/store/store.dart';
import 'package:layrz_icons/layrz_icons.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get color => Theme.of(context).primaryColor;
  double get iconSize => 45;
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Components available:",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: 10),
                children: [
                  ListTile(
                    leading: ThemedAvatar(
                      icon: LayrzIcons.mdiThemeLightDark,
                      color: color,
                      size: iconSize,
                    ),
                    title: Text(
                      "Theme generation",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "First of all, to use Layrz Theme, you need to generate a theme using the "
                      "the Layrz Theme generator. This generator will create a theme based on the "
                      "Layrz design standard. Exists two different generators, one for light theme "
                      "and another one for dark theme.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 5,
                    ),
                    trailing: ThemedButton(
                      labelText: "Go!",
                      icon: LayrzIcons.mdiRocketLaunch,
                      color: Colors.green,
                      onTap: () => context.go('/theme'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: ThemedAvatar(
                      icon: LayrzIcons.mdiText,
                      color: color,
                      size: iconSize,
                    ),
                    title: Text(
                      "Inputs",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Layrz Theme provides a variety of inputs to use in your application. Each of them "
                      "has a different purpose and design, but all of them are customizable.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 5,
                    ),
                    trailing: ThemedButton(
                      labelText: "Go!",
                      icon: LayrzIcons.mdiRocketLaunch,
                      color: Colors.green,
                      onTap: () => context.go('/inputs'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: ThemedAvatar(
                      icon: LayrzIcons.mdiTable,
                      color: color,
                      size: iconSize,
                    ),
                    title: Text(
                      "Tables",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "For us, tables are the core element on all of our scaffolds, so we provide a table "
                      "optimized to handle hundreds of rows and columns. Of course you can customize it "
                      "to fit your needs.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 5,
                    ),
                    trailing: ThemedButton(
                      labelText: "Go!",
                      icon: LayrzIcons.mdiRocketLaunch,
                      color: Colors.green,
                      onTap: () => context.go('/table'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: ThemedAvatar(
                      icon: LayrzIcons.mdiAccountCircleOutline,
                      color: color,
                      size: iconSize,
                    ),
                    title: Text(
                      "Avatars",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Layrz Theme provides a variety of avatars to use in your application. You can use a static "
                      "avatar or a dynamic avatar. Also, you can customize the avatar to use your own image.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 5,
                    ),
                    trailing: ThemedButton(
                      labelText: "Go!",
                      icon: LayrzIcons.mdiRocketLaunch,
                      color: Colors.green,
                      onTap: () => context.go('/utilities/widgets'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Layo(
                      size: iconSize,
                      emotion: LayoEmotions.mrLayo,
                    ),
                    title: Text(
                      "Layo!",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Layo is our mascot, and he is a very important part of our team. In some part of our apps, "
                      "we use it to show some messages to the user. You can use it too!",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 5,
                    ),
                    trailing: ThemedButton(
                      labelText: "Go!",
                      icon: LayrzIcons.mdiRocketLaunch,
                      color: Colors.green,
                      onTap: () => context.go('/layo'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
