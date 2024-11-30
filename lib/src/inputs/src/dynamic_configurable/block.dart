part of '../../inputs.dart';

typedef ThemedDynamicFieldConfigurationBlockOnChanged = void Function(CredentialFieldInput);

class ThemedDynamicConfigurableBlock extends StatefulWidget {
  /// [object] is the object to configure
  final CredentialFieldInput object;

  /// [index] is the index of the object
  final int index;

  /// [translationPrefix] is the translation prefix to use
  final String translationPrefix;

  /// [otherFields] is the list of other fields
  final List<String> otherFields;

  /// [onRemove] is the function to call when the object is removed
  final VoidCallback onRemove;

  /// [onChanged] is the function to call when the object is changed
  final ThemedDynamicFieldConfigurationBlockOnChanged onChanged;

  /// [enabledTypes] is the list of enabled types
  final List<CredentialFieldType> enabledTypes;

  /// [inputFormatters] refers to the validation of the name of the field
  ///
  /// By default, the field only will allow letters, numbers, underscores, and dots
  final List<TextInputFormatter>? inputFormatters;

  /// [errorsKey] is the prefix or base key of all errors processed in your backend service
  ///
  /// By default is `requiredFields`, so, the result error should be `requiredFields.0.field`
  ///
  /// If you're using Python as your backend service, our library `layrz-forms` returns the errors in the
  /// correct format that Layrz with `context.setErrors` or `ThemedOrm.setErrors` will handle automatically.
  /// Otherwise, you should check the return of your backend service and set the errors manually.
  final String errorsKey;

  /// [isExpanded] is the flag to check if the block is expanded
  final bool isExpanded;

  /// [enabledActions] is the list of enabled actions
  final List<CredentialFieldAction> enabledActions;

  /// [ThemedDynamicConfigurableBlock] is the block to configure a dynamic field
  ///
  /// Usage:
  /// ```dart
  /// ThemedDynamicFieldConfigurationBlock(
  ///  object: object,
  ///  index: index,
  ///  translationPrefix: translationPrefix,
  ///  onRemove: () {
  ///    // pass
  ///  },
  ///  onChanged: (object) {
  ///    // pass
  ///  },
  /// )
  /// ```
  ///
  /// Also, the system only works with Layrz translations, you need to use the translation keys defined below:
  /// ```json
  /// {
  ///   "protocols.requiredFields.remove": "Remove field",
  ///   "protocols.requiredFields.field": "Name",
  ///   "protocols.requiredFields.type": "Type",
  ///   "protocols.requiredFields.sections.validators": "Field validation",
  ///   "protocols.requiredFields.minLength": "Minimum length",
  ///   "protocols.requiredFields.maxLength": "Maximum length",
  ///   "protocols.requiredFields.onlyField": "Display onle when the selected field is present",
  ///   "protocols.requiredFields.onlyChoices": "Display this choices only when the declared field is present",
  ///   "protocols.requiredFields.choices": "Choices",
  ///   "protocols.requiredFields.minValue": "Minimum value",
  ///   "protocols.requiredFields.maxValue": "Maximum value",
  ///   "protocols.requiredFields.add": "Add field",
  ///   "protocols.requiredFields.types.CHOICES": "Choices",
  ///   "protocols.requiredFields.types.SOAPURL": "SOAP Service URL",
  ///   "protocols.requiredFields.types.RESTURL": "REST Service URL",
  ///   "protocols.requiredFields.types.STRING": "String",
  ///   "protocols.requiredFields.types.STRING_LIST": "String List",
  ///   "protocols.requiredFields.types.INTEGER": "Integer",
  ///   "protocols.requiredFields.types.FLOAT": "Float or double precision",
  ///   "protocols.requiredFields.types.FTP": "FTP Server",
  ///   "protocols.requiredFields.types.DIRECTORY": "FTP Directory",
  ///   "protocols.requiredFields.types.LAYRZAPITOKEN": "Layrz Token (Asigned after creation)",
  ///   "protocols.requiredFields.types.LAYRZFTPHOST": "Layrz FTP Host (Asigned after creation)",
  ///   "protocols.requiredFields.types.LAYRZFTPPORT": "Layrz FTP Port (Asigned after creation)",
  ///   "protocols.requiredFields.types.LAYRZFTPUSER": "Layrz FTP User (Asigned after creation)",
  ///   "protocols.requiredFields.types.LAYRZFTPPASSWORD": "Layrz FTP Password (Asigned after creation)",
  ///   "protocols.requiredFields.types.NESTED": "Nexted credentials",
  ///   "protocols.requiredFields.types.WIALONTOKEN": "Wialon Hosting or Wialon Local Token (Generated)",
  ///   "protocols.requiredFields.types.BASE64": "Base64 Encoded file or string",
  ///   "protocols.requiredFields.types.LAYRZ_ITEM_ID": "Layrz Item ID (Asigned after creation)",
  ///   "protocols.requiredFields.types.LAYRZ_WEBHOOK_ENDPOINT": "Layrz Webhook Endpoint (Asigned after creation)",
  /// }
  /// ```
  const ThemedDynamicConfigurableBlock({
    super.key,
    required this.object,
    required this.index,
    required this.translationPrefix,
    this.otherFields = const [],
    required this.onRemove,
    required this.onChanged,
    this.enabledTypes = CredentialFieldType.values,
    this.inputFormatters,
    this.errorsKey = 'requiredFields',
    this.isExpanded = false,
    this.enabledActions = CredentialFieldAction.values,
  });

  @override
  State<ThemedDynamicConfigurableBlock> createState() => _ThemedDynamicConfigurableBlockState();
}

class _ThemedDynamicConfigurableBlockState extends State<ThemedDynamicConfigurableBlock>
    with SingleTickerProviderStateMixin {
  late CredentialFieldInput object;
  LayrzAppLocalizations get i18n => LayrzAppLocalizations.of(context);
  late AnimationController _controller;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    object = widget.object;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.isExpanded ? 1 : 0,
    );

    _isExpanded = widget.isExpanded;
  }

  @override
  void didUpdateWidget(ThemedDynamicConfigurableBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    object = widget.object;

    if (oldWidget.isExpanded != widget.isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.isExpanded && !_isExpanded) {
          _controller.forward();
          _isExpanded = true;
        } else if (!widget.isExpanded && _isExpanded) {
          _controller.reverse();
          _isExpanded = false;
        }

        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveCol(
      xs: Sizes.col12,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: _isExpanded ? Radius.zero : const Radius.circular(10),
                  bottomRight: _isExpanded ? Radius.zero : const Radius.circular(10),
                ),
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;

                    if (_isExpanded) {
                      _controller.forward();
                    } else {
                      _controller.reverse();
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      RotationTransition(
                        turns: Tween<double>(begin: 0, end: 0.5).animate(_controller),
                        child: Icon(
                          LayrzIcons.solarOutlineAltArrowDown,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "#${widget.index + 1}",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 20,
                            ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          object.field.isEmpty ? 'N/A' : object.field,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      ThemedButton(
                        labelText: i18n.t('requiredFields.remove'),
                        color: Colors.red,
                        icon: LayrzIcons.solarOutlineTrashBinMinimalistic2,
                        style: ThemedButtonStyle.filledTonalFab,
                        onTap: () => widget.onRemove.call(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizeTransition(
              sizeFactor: CurveTween(curve: Curves.easeInOut).animate(_controller),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ResponsiveRow(
                    children: [
                      ResponsiveCol(
                        xs: Sizes.col12,
                        sm: Sizes.col6,
                        md: Sizes.col4,
                        child: ThemedTextInput(
                          labelText: i18n.t('requiredFields.field'),
                          value: object.field,
                          inputFormatters: widget.inputFormatters ??
                              [
                                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_.]')),
                              ],
                          suffixIcon: LayrzIcons.solarOutlineCopy,
                          onSuffixTap: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: '${widget.translationPrefix}.${object.field}',
                              ),
                            );
                            ThemedSnackbarMessenger.maybeOf(context)?.showSnackbar(ThemedSnackbar(
                              message: i18n.t('helpers.copyToClipboard.post'),
                              color: Colors.blue,
                              icon: LayrzIcons.solarOutlineClipboardCheck,
                            ));
                          },
                          errors: context.getErrors(key: '${widget.errorsKey}.${widget.index}.field'),
                          onChanged: (value) {
                            setState(() => object.field = value);
                            widget.onChanged.call(object);
                          },
                        ),
                      ),
                      ResponsiveCol(
                        xs: Sizes.col12,
                        sm: Sizes.col6,
                        md: widget.enabledActions.isNotEmpty ? Sizes.col4 : Sizes.col8,
                        child: ThemedSelectInput<CredentialFieldType>(
                          items: widget.enabledTypes
                              .map((field) => ThemedSelectItem(
                                    value: field,
                                    label: i18n.t('requiredFields.types.${field.toJson()}'),
                                  ))
                              .toList(),
                          labelText: i18n.t('requiredFields.type'),
                          value: object.type,
                          errors: context.getErrors(key: '${widget.errorsKey}.${widget.index}.type'),
                          onChanged: (value) {
                            setState(() {
                              object.type = value?.value ?? CredentialFieldType.string;

                              if (value?.value == CredentialFieldType.string) {
                                object.maxLength = 255;
                                object.minLength = 1;
                                object.maxValue = null;
                                object.minValue = null;
                                object.choices = [];
                                object.onlyChoices = [];
                                object.onlyField = null;
                              } else if ([CredentialFieldType.integer, CredentialFieldType.float]
                                  .contains(value?.value)) {
                                object.maxLength = null;
                                object.minLength = null;
                                object.maxValue = 1;
                                object.minValue = 0;
                                object.choices = [];
                                object.onlyChoices = [];
                                object.onlyField = null;
                              } else if (value?.value == CredentialFieldType.choices) {
                                object.maxLength = null;
                                object.minLength = null;
                                object.maxValue = null;
                                object.minValue = null;
                                object.choices = [];
                                object.onlyChoices = [];
                                object.onlyField = '';
                              }
                            });
                            widget.onChanged.call(object);
                          },
                        ),
                      ),
                      if (widget.enabledActions.isNotEmpty) ...[
                        ResponsiveCol(
                          xs: Sizes.col12,
                          md: Sizes.col4,
                          child: ThemedSelectInput<CredentialFieldAction>(
                            items: widget.enabledActions
                                .map((field) => ThemedSelectItem(
                                      value: field,
                                      label: i18n.t('requiredFields.actions.${field.toJson()}'),
                                    ))
                                .toList(),
                            labelText: i18n.t('requiredFields.action'),
                            value: object.action,
                            errors: context.getErrors(key: '${widget.errorsKey}.${widget.index}.action'),
                            onChanged: (value) {
                              setState(() {
                                object.action = value?.value ?? CredentialFieldAction.none;
                              });
                              widget.onChanged.call(object);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  if ([
                    CredentialFieldType.string,
                    CredentialFieldType.choices,
                    CredentialFieldType.integer,
                    CredentialFieldType.float,
                    CredentialFieldType.nestedField,
                  ].contains(object.type)) ...[
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        i18n.t('requiredFields.sections.validators'),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ResponsiveRow(
                      children: [
                        if (object.type == CredentialFieldType.string) ...[
                          ResponsiveCol(
                            xs: Sizes.col12,
                            sm: Sizes.col6,
                            child: ThemedNumberInput(
                              labelText: i18n.t('requiredFields.minLength'),
                              value: object.minLength,
                              errors: context.getErrors(key: '${widget.errorsKey}.${widget.index}.minLength'),
                              onChanged: (value) {
                                setState(() => object.minLength = value?.toInt());
                                widget.onChanged.call(object);
                              },
                            ),
                          ),
                          ResponsiveCol(
                            xs: Sizes.col12,
                            sm: Sizes.col6,
                            child: ThemedNumberInput(
                              labelText: i18n.t('requiredFields.maxLength'),
                              value: object.maxLength,
                              errors: context.getErrors(key: '${widget.errorsKey}.${widget.index}.maxLength'),
                              onChanged: (value) {
                                setState(() => object.maxLength = value?.toInt());
                                widget.onChanged.call(object);
                              },
                            ),
                          ),
                        ] else if (object.type == CredentialFieldType.choices) ...[
                          if (widget.otherFields.isNotEmpty) ...[
                            ResponsiveCol(
                              xs: Sizes.col12,
                              child: ThemedSelectInput(
                                items: widget.otherFields
                                    .map((field) => ThemedSelectItem(
                                          value: field,
                                          label: field,
                                        ))
                                    .toList(),
                                labelText: i18n.t('requiredFields.onlyField'),
                                value: object.onlyField,
                                errors: context.getErrors(key: '${widget.errorsKey}.${widget.index}.onlyField'),
                                onChanged: (value) {
                                  setState(() => object.onlyField = value?.value);
                                  widget.onChanged.call(object);
                                },
                              ),
                            ),
                          ],
                          ResponsiveCol(
                            xs: Sizes.col12,
                            sm: Sizes.col6,
                            child: ThemedMultiSelectInput<String>(
                              items: object.choices
                                  .map((choice) => ThemedSelectItem(
                                        value: choice,
                                        label: choice,
                                      ))
                                  .toList(),
                              labelText: i18n.t('requiredFields.onlyChoices'),
                              value: object.onlyChoices,
                              errors: context.getErrors(key: '${widget.errorsKey}.${widget.index}.onlyChoices'),
                              onChanged: (items) {
                                List<String> choices = items.map((item) => item.value).whereNotNull().toList();
                                setState(() => object.onlyChoices = choices);
                                widget.onChanged.call(object);
                              },
                            ),
                          ),
                          ResponsiveCol(
                            xs: Sizes.col12,
                            sm: Sizes.col6,
                            child: ThemedTextInput(
                              labelText: i18n.t('requiredFields.choices'),
                              readonly: true,
                              value: object.choices.join(', '),
                              errors: context.getErrors(key: '${widget.errorsKey}.${widget.index}.choices'),
                              suffixIcon: LayrzIcons.solarOutlinePenNewSquare,
                              onSuffixTap: () async {
                                List<String>? choices = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ThemedDynamicConfigurableDialog(choices: object.choices);
                                  },
                                );

                                if (choices != null) {
                                  setState(() => object.choices = choices);
                                  widget.onChanged.call(object);
                                }
                              },
                            ),
                          ),
                        ] else if ([CredentialFieldType.integer, CredentialFieldType.float].contains(object.type)) ...[
                          ResponsiveCol(
                            xs: Sizes.col12,
                            sm: Sizes.col6,
                            child: ThemedNumberInput(
                              labelText: i18n.t('requiredFields.minValue'),
                              value: object.minValue,
                              errors: context.getErrors(key: '${widget.errorsKey}.${widget.index}.minValue'),
                              onChanged: (value) {
                                setState(() => object.minValue = value?.toDouble());
                                widget.onChanged.call(object);
                              },
                            ),
                          ),
                          ResponsiveCol(
                            xs: Sizes.col12,
                            sm: Sizes.col6,
                            child: ThemedNumberInput(
                              labelText: i18n.t('requiredFields.maxValue'),
                              value: object.maxValue,
                              errors: context.getErrors(key: '${widget.errorsKey}.${widget.index}.maxValue'),
                              onChanged: (value) {
                                setState(() => object.maxValue = value?.toDouble());
                                widget.onChanged.call(object);
                              },
                            ),
                          ),
                        ] else if (object.type == CredentialFieldType.nestedField) ...[
                          ResponsiveCol(
                            xs: Sizes.col12,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ThemedButton(
                                    labelText: i18n.t('requiredFields.add'),
                                    color: Colors.green,
                                    style: ThemedButtonStyle.filledTonal,
                                    onTap: () {
                                      if (object.requiredFields.isEmpty) {
                                        object.requiredFields = [CredentialFieldInput()];
                                      } else {
                                        object.requiredFields.add(CredentialFieldInput());
                                      }

                                      setState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ...object.requiredFields.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  CredentialFieldInput field = entry.value;

                                  return ThemedDynamicConfigurableBlock(
                                    object: field,
                                    index: index,
                                    translationPrefix: '${widget.translationPrefix}.${object.field}',
                                    onRemove: () => setState(() => object.requiredFields.removeAt(index)),
                                    errorsKey: '${widget.errorsKey}.${widget.index}',
                                    enabledActions: widget.enabledActions,
                                    enabledTypes: widget.enabledTypes,
                                    onChanged: (child) {
                                      object.requiredFields[index] = child;
                                      widget.onChanged.call(object);
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
