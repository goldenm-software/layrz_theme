import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ButtonsView extends StatefulWidget {
  final String name;
  final VoidCallback toggleTheme;
  const ButtonsView({
    super.key,
    this.name = 'Generic View',
    required this.toggleTheme,
  });

  @override
  State<ButtonsView> createState() => _ButtonsViewState();
}

class _ButtonsViewState extends State<ButtonsView> {
  List<int> selected = [];
  List<ThemedSelectItem<int>> get choices => [];
  bool isCooldown = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Layout(
      showDrawer: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            ThemedButton(
              labelText: "Toggle theme",
              onTap: widget.toggleTheme,
            ),
            const SizedBox(height: 10),
            ThemedButton(
              labelText: "Start cooldown",
              onTap: () {
                setState(() {
                  isCooldown = true;
                });
              },
            ),
            ThemedButton(
              labelText: "Toggle loading",
              onTap: () {
                setState(() {
                  isLoading = !isLoading;
                });
              },
            ),
            const SizedBox(height: 10),
            ThemedActionsButtons(
              actions: [
                ThemedActionButton(
                  labelText: "Action 1",
                  icon: MdiIcons.homeVariant,
                  onPressed: () {
                    debugPrint("Action 1 tapped");
                  },
                ),
                ThemedActionButton(
                  labelText: "Action 2 asdasdasdasdasd",
                  icon: MdiIcons.homeVariant,
                  onPressed: () {
                    debugPrint("Action 2 tapped");
                  },
                ),
                ThemedActionButton(
                  labelText: "Action 3",
                  icon: MdiIcons.homeVariant,
                  onPressed: () {
                    debugPrint("Action 3 tapped");
                  },
                ),
              ],
            ),
            ...[
              ThemedButtonStyle.filledTonal,
              ThemedButtonStyle.filled,
              ThemedButtonStyle.elevated,
              ThemedButtonStyle.outlined,
              ThemedButtonStyle.text,
              ThemedButtonStyle.fab,
              ThemedButtonStyle.outlinedFab,
            ].map((style) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ThemedButton(
                  labelText: "Button $style",
                  style: style,
                  isCooldown: isCooldown,
                  isLoading: isLoading,
                  onCooldownFinish: () => setState(() => isCooldown = false),
                  // width: 300,
                  // isDisabled: true,
                  icon: MdiIcons.homeVariant,
                  onTap: () {
                    debugPrint("Button $style tapped");
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
