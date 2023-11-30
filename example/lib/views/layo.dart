import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/store/store.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LayoView extends StatefulWidget {
  const LayoView({super.key});

  @override
  State<LayoView> createState() => _LayoViewState();
}

class _LayoViewState extends State<LayoView> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "How to use it?",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "It's simple, use the following code to display a Layo:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            const ThemedCodeSnippet(
              code: "Layo(size: 30, emotion: LayoEmotions.mrLayo)",
            ),
            const SizedBox(height: 10),
            Text(
              "Result:",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            const Layo(
              size: 30,
              emotion: LayoEmotions.mrLayo,
            ),
            const SizedBox(height: 10),
            Text(
              "Layo has multiple emotions, you can use them like this:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 10),
              children: [
                ...LayoEmotions.values.map((emotion) {
                  return [
                    ListTile(
                      leading: Layo(size: 35, emotion: emotion),
                      title: Text("${emotion.name} emotion"),
                      subtitle: Text("Enum value: ${emotion.toString()}"),
                      trailing: ThemedButton(
                        icon: MdiIcons.contentCopy,
                        labelText: "Copy this emotion as example",
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: "Layo(size: 30, emotion: ${emotion.toString()})"));
                          ThemedSnackbarMessenger.of(context).showSnackbar(ThemedSnackbar(
                            message: "Copied to clipboard",
                            icon: MdiIcons.clipboardCheckOutline,
                            color: Colors.green,
                          ));
                        },
                      ),
                    ),
                    const Divider(),
                  ];
                }).expand((element) => element),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
