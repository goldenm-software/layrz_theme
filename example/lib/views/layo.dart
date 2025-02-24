import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/store/store.dart';
import 'package:layrz_icons/layrz_icons.dart';

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
            ListView.separated(
              shrinkWrap: true,
              itemCount: LayoEmotions.values.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final emotion = LayoEmotions.values[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Layo(size: 35, emotion: emotion),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${emotion.name} emotion",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text("Enum value: ${emotion.toString()}"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ThemedButton(
                        style: ThemedButtonStyle.filledTonalFab,
                        tooltipPosition: ThemedTooltipPosition.left,
                        icon: LayrzIcons.mdiContentCopy,
                        labelText: "Copy this emotion as example",
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: "Layo(size: 30, emotion: ${emotion.toString()})"));
                          ThemedSnackbarMessenger.of(context).showSnackbar(ThemedSnackbar(
                            message: "Copied to clipboard",
                            icon: LayrzIcons.mdiClipboardCheckOutline,
                            color: Colors.green,
                          ));
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
