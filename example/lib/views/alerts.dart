import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/store/store.dart';
import 'package:layrz_icons/layrz_icons.dart';

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
            "Alerts!",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
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
