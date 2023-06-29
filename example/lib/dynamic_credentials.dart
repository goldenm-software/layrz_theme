import 'package:flutter/material.dart';
import 'package:layrz_models/layrz_models.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:layrz_theme_example/layout.dart';

class DynamicCredentialsView extends StatefulWidget {
  final String name;
  final VoidCallback toggleTheme;
  const DynamicCredentialsView({
    super.key,
    this.name = 'Generic View',
    required this.toggleTheme,
  });

  @override
  State<DynamicCredentialsView> createState() => _DynamicCredentialsViewState();
}

class _DynamicCredentialsViewState extends State<DynamicCredentialsView> {
  Map<String, dynamic> credentials = {};
  List<CredentialField> get fields =>
      [
        {
          "field": "host",
          "type": "STRING",
          "onlyChoices": ["LOCAL"],
          "onlyField": "wialonServer",
          "maxLength": 255,
          "minLength": 5,
          "maxValue": null,
          "minValue": null,
          "choices": null,
          "requiredFields": null
        },
        {
          "field": "port",
          "type": "STRING",
          "onlyChoices": ["LOCAL"],
          "onlyField": "wialonServer",
          "maxLength": 8,
          "minLength": 4,
          "maxValue": null,
          "minValue": null,
          "choices": null,
          "requiredFields": null
        },
        {
          "field": "prefix",
          "type": "STRING",
          "onlyChoices": null,
          "onlyField": null,
          "maxLength": 10,
          "minLength": 0,
          "maxValue": null,
          "minValue": null,
          "choices": null,
          "requiredFields": null
        },
        {
          "field": "experiment",
          "type": "NESTED",
          "onlyChoices": null,
          "onlyField": null,
          "maxLength": null,
          "minLength": null,
          "maxValue": null,
          "minValue": null,
          "choices": null,
          "requiredFields": [
            {
              "field": "name",
              "type": "STRING",
              "onlyChoices": null,
              "onlyField": null,
              "maxLength": 255,
              "minLength": 5,
              "maxValue": null,
              "minValue": null,
              "choices": null
            },
            {
              "field": "ident",
              "type": "STRING",
              "onlyChoices": null,
              "onlyField": null,
              "maxLength": 255,
              "minLength": 5,
              "maxValue": null,
              "minValue": null,
              "choices": null
            }
          ]
        },
        {
          "field": "wialonServer",
          "type": "CHOICES",
          "onlyChoices": null,
          "onlyField": null,
          "maxLength": null,
          "minLength": null,
          "maxValue": null,
          "minValue": null,
          "choices": ["HOSTING_NL", "HOSTING_US", "LOCAL"],
          "requiredFields": null
        }
      ].map((raw) => CredentialField.fromJson(raw)).toList() +
      [
        const CredentialField(
          field: 'integer',
          type: CredentialFieldType.integer,
        ),
        const CredentialField(
          field: 'float',
          type: CredentialFieldType.float,
        ),
        const CredentialField(
          field: 'token',
          type: CredentialFieldType.layrzApiToken,
        ),
      ];

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
            ThemedDynamicCredentialsInput(
              value: credentials,
              fields: fields,
              layrzGeneratedToken: 'asdasda',
              onChanged: (value) {
                debugPrint(value.toString());
                setState(() {
                  credentials = value;
                });
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
