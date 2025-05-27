import 'package:flutter/material.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/store/store.dart';

class AlertsView extends StatefulWidget {
  const AlertsView({super.key});

  @override
  State<AlertsView> createState() => _AlertsViewState();
}

class _AlertsViewState extends State<AlertsView> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Chips and alerts!",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          ThemedChip(
            content: 'This is a chip, displays the content with the provided color, and the background is the same'
                'color with a 10% opacity.',
            color: Colors.blue,
          ),
          const SizedBox(height: 10),
          ThemedChip(
            content: 'You can change the color, and the text style.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          ThemedChip(
            content: 'Or, change the padding if you want!',
            color: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: ThemedAlertType.values.length,
              itemBuilder: (context, index) {
                final alertType = ThemedAlertType.values[index];
                return Row(
                  children: [
                    ThemedAlertIcon(
                      type: alertType,
                      size: 40,
                      iconSize: 30,
                    ),
                    const SizedBox(width: 10),
                    for (final style in ThemedAlertStyle.values) ...[
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          child: ThemedAlert(
                            type: alertType,
                            style: style,
                            title: "${alertType.name} - ${style.name}",
                            description: "This is a ${alertType.name} alert with the style ${style.name}.",
                          ),
                        ),
                      ),
                    ]
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
