import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/store/store.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
                    leading: drawAvatar(context: context, icon: MdiIcons.themeLightDark, color: color, size: iconSize),
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
                      icon: MdiIcons.rocketLaunch,
                      color: Colors.green,
                      onTap: () => context.go('/theme'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: drawAvatar(context: context, icon: MdiIcons.viewGrid, color: color, size: iconSize),
                    title: Text(
                      "Layout",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Contains 5 different widgets, each one is a part of the layout of the application. "
                      "Also, contains a main widget to use all the widgets together and change the deisgn "
                      "using a simple property.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 5,
                    ),
                    trailing: ThemedButton(
                      labelText: "Go!",
                      icon: MdiIcons.rocketLaunch,
                      color: Colors.green,
                      onTap: () => context.go('/layout'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: drawAvatar(context: context, icon: MdiIcons.text, color: color, size: iconSize),
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
                      icon: MdiIcons.rocketLaunch,
                      color: Colors.green,
                      onTap: () => context.go('/inputs'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: drawAvatar(context: context, icon: MdiIcons.table, color: color, size: iconSize),
                    title: Text(
                      "Scaffold",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "For us, scaffold refers to tables and details view to handle the CRUD operations.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 5,
                    ),
                    trailing: ThemedButton(
                      labelText: "Go!",
                      icon: MdiIcons.rocketLaunch,
                      color: Colors.green,
                      onTap: () => context.go('/scaffold'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: drawAvatar(context: context, icon: MdiIcons.codeBraces, color: color, size: iconSize),
                    title: Text(
                      "Utility functions",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "To simplify and/or override some properties of the default widgets, Layrz Theme "
                      "provides some functions to generate the widgets with the default properties "
                      "already set.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 5,
                    ),
                    trailing: ThemedButton(
                      labelText: "Go!",
                      icon: MdiIcons.rocketLaunch,
                      color: Colors.green,
                      onTap: () => context.go('/utilities/functions'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: drawAvatar(context: context, icon: MdiIcons.toolbox, color: color, size: iconSize),
                    title: Text(
                      "Utility widgets",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Some widgets, like image handling, are not 'easy' to handle multiple paths and/or formats, "
                      "so, to simplify this process, Layrz Theme provides some widgets to handle this.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 5,
                    ),
                    trailing: ThemedButton(
                      labelText: "Go!",
                      icon: MdiIcons.rocketLaunch,
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
                      icon: MdiIcons.rocketLaunch,
                      color: Colors.green,
                      onTap: () => context.go('/layo'),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Layo(
                      size: iconSize,
                      emotion: LayoEmotions.mrLayo,
                    ),
                    title: Text(
                      "And more! You can navigate using the dual navigation (or sidebar if you changed the design) "
                      "to see all the components available on this example.",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "And, enjoy your travel with Layrz Theme! Happy coding!",
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 5,
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
