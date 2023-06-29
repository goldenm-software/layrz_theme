part of layrz_theme;

typedef CredentialOnChanged = void Function(Map<String, dynamic>);

class ThemedDynamicCredentialsInput extends StatefulWidget {
  final Map<String, dynamic> value;
  final List<CredentialField> fields;
  final CredentialOnChanged? onChanged;
  final Map<String, dynamic> errors;
  final String translatePrefix;
  final bool isEditing;
  final String? layrzGeneratedToken;
  final String? nested;
  final void Function(CredentialFieldAction)? actionCallback;
  final bool isLoading;

  const ThemedDynamicCredentialsInput({
    super.key,
    required this.value,
    required this.fields,
    this.onChanged,
    this.errors = const {},
    this.translatePrefix = '',
    this.isEditing = true,
    this.layrzGeneratedToken,
    this.nested,
    this.actionCallback,
    this.isLoading = false,
  });

  @override
  State<ThemedDynamicCredentialsInput> createState() => _ThemedDynamicCredentialsInputState();
}

class _ThemedDynamicCredentialsInputState extends State<ThemedDynamicCredentialsInput> {
  late Map<String, dynamic> credentials;
  List<CredentialField> get fields => widget.fields;
  bool get isEditing => widget.isEditing;
  bool get isLoading => widget.isLoading;
  String get translatePrefix => widget.translatePrefix;

  @override
  void initState() {
    super.initState();
    credentials = widget.value;
  }

  @override
  void didUpdateWidget(ThemedDynamicCredentialsInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      credentials = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveRow(
      children: fields.map((field) {
        Sizes sm = Sizes.col12;

        Widget? content;

        if (showField(field)) {
          switch (field.type) {
            case CredentialFieldType.string:
            case CredentialFieldType.soapUrl:
            case CredentialFieldType.restUrl:
            case CredentialFieldType.ftp:
            case CredentialFieldType.dir:
              content = ThemedTextInput(
                disabled: !isEditing,
                labelText: t('$translatePrefix.${field.field}.title'),
                value: credentials[field.field] ?? '',
                errors: ThemedOrm.getErrors(
                    key: widget.nested != null
                        ? 'credentials.${widget.nested}.${field.field}'
                        : 'credentials.${field.field}'),
                onChanged: (value) {
                  credentials[field.field] = value;
                  setState(() {});
                  widget.onChanged?.call(credentials);
                },
              );
              break;
            case CredentialFieldType.integer:
            case CredentialFieldType.float:
              content = ThemedTextInput(
                disabled: !isEditing,
                keyboardType: TextInputType.numberWithOptions(decimal: field.type == CredentialFieldType.float),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(field.type == CredentialFieldType.integer
                      ? RegExp(r'^\d+$')
                      : field.type == CredentialFieldType.float
                          ? RegExp(r'^\d+\.?\d{0,2}$')
                          : RegExp(r'^\d+$')),
                ],
                labelText: t('$translatePrefix.${field.field}.title'),
                value: credentials[field.field] == null ? "0" : "${credentials[field.field]}",
                errors: ThemedOrm.getErrors(
                    key: widget.nested != null
                        ? 'credentials.${widget.nested}.${field.field}'
                        : 'credentials.${field.field}'),
                onChanged: (value) {
                  if (field.type == CredentialFieldType.integer) {
                    credentials[field.field] = int.tryParse(value) ?? 0;
                  } else if (field.type == CredentialFieldType.float) {
                    credentials[field.field] = double.tryParse(value) ?? 0;
                  } else {
                    credentials[field.field] = value;
                  }
                  setState(() {});
                  widget.onChanged?.call(credentials);
                },
              );
              break;
            case CredentialFieldType.choices:
              content = ThemedSelectInput<String>(
                items: field.choices!
                    .map(
                      (choice) => ThemedSelectItem<String>(
                        value: choice,
                        label: t('$translatePrefix.${field.field}.$choice'),
                      ),
                    )
                    .toList(),
                disabled: !isEditing,
                labelText: t('$translatePrefix.${field.field}.title'),
                value: credentials[field.field],
                errors: ThemedOrm.getErrors(
                    key: widget.nested != null
                        ? 'credentials.${widget.nested}.${field.field}'
                        : 'credentials.${field.field}'),
                onChanged: (value) {
                  credentials[field.field] = value?.value;
                  setState(() {});
                  widget.onChanged?.call(credentials);
                },
              );
              break;
            case CredentialFieldType.layrzApiToken:
              content = ThemedTextInput(
                readonly: true,
                labelText: widget.nested != null
                    ? t('$translatePrefix.${widget.nested}.${field.field}.title')
                    : t('$translatePrefix.${field.field}.title'),
                value: widget.layrzGeneratedToken ?? t('builder.authorization.tokenNew'),
                suffixIcon: widget.layrzGeneratedToken != null ? MdiIcons.clipboardOutline : null,
                onSuffixTap: widget.layrzGeneratedToken != null
                    ? () {
                        Clipboard.setData(ClipboardData(text: widget.layrzGeneratedToken!));
                        showThemedSnackbar(ThemedSnackbar(
                          message: t('builder.authorization.tokenCopied'),
                          context: context,
                          icon: MdiIcons.clipboardCheckOutline,
                        ));
                      }
                    : null,
                errors: ThemedOrm.getErrors(
                    key: widget.nested != null
                        ? 'credentials.${widget.nested}.${field.field}'
                        : 'credentials.${field.field}'),
              );
              break;
            case CredentialFieldType.nestedField:
              content = ThemedDynamicCredentialsInput(
                value: credentials[field.field] ?? {},
                fields: field.requiredFields ?? [],
                onChanged: (value) {
                  credentials[field.field] = value;
                  setState(() {});
                  widget.onChanged?.call(credentials);
                },
                errors: widget.errors,
                nested: field.field,
                translatePrefix: '$translatePrefix.${field.field}',
                isEditing: isEditing,
              );
              break;
            case CredentialFieldType.wialonToken:
              content = ThemedTextInput(
                labelText: t('$translatePrefix.${field.field}.title'),
                readonly: true,
                value: credentials[field.field],
                errors: ThemedOrm.getErrors(
                    key: widget.nested != null
                        ? 'credentials.${widget.nested}.${field.field}'
                        : 'credentials.${field.field}'),
                suffixIcon: isLoading ? MdiIcons.lockOutline : MdiIcons.autorenew,
                onSuffixTap: () => widget.actionCallback?.call(CredentialFieldAction.wialonOAuth),
              );
              break;
            default:
              content = Center(child: Text(t('dynamic.credentials.unknown')));
              break;
          }
        }

        return ResponsiveCol(
          xs: Sizes.col12,
          sm: sm,
          child: content != null
              ? field.type == CredentialFieldType.nestedField
                  ? content
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: content,
                    )
              : const SizedBox(),
        );
      }).toList(),
    );
  }

  String t(String key) {
    return LayrzAppLocalizations.of(context)?.t(key) ?? 'Tranlation missing: $key';
  }

  bool showField(CredentialField field) {
    if (field.onlyChoices != null) {
      return field.onlyChoices!.contains(credentials[field.onlyField!]);
    }

    return true;
  }
}
