part of '../../inputs.dart';

class ThemedSelectInput<T> extends StatefulWidget {
  /// [labelText] is the label of the input. Avoid using this if you are using [label] instead.
  final String? labelText;

  /// [label] is the label of the input. Avoid using this if you are using [labelText] instead.
  final Widget? label;

  /// [items] is the list of items to be selected.
  final List<ThemedSelectItem<T>> items;

  /// [onChanged] is the callback when the input value changes.
  final IconData? prefixIcon;

  /// [prefixIcon] is the icon to be displayed at the start of the input.
  final String? prefixText;

  /// [prefixText] is the text to be displayed at the start of the input.
  final VoidCallback? onPrefixTap;

  /// [onPrefixTap] is the callback when the prefix is tapped.
  final void Function(ThemedSelectItem<T>?)? onChanged;

  /// [value] is the value of the input.
  final T? value;

  /// [filter] is the callback to filter the items.
  final bool Function(String, ThemedSelectItem<T>)? filter;

  /// [enableSearch] is the flag to enable the search input.
  final bool enableSearch;

  /// [disabled] is the flag to disable the input.
  final bool disabled;

  /// [errors] is the list of errors to be displayed.
  final List<String> errors;

  /// [hideDetails] is the flag to hide the details of the input.
  final bool hideDetails;

  /// [hideTitle] is the flag to hide the title of the input.
  /// Important, when this property is true, automatically the search field is disabled.
  final bool hideTitle;

  /// [autoclose] is the flag to close the input when an item is selected.
  final bool autoclose;

  /// [isRequired] is the flag to mark the input as required.
  final bool isRequired;

  /// [dense] is the flag to make the input dense.
  final bool dense;

  /// [emptyListText] is the text to be displayed when the list is empty.
  final EdgeInsets? padding;

  /// [searchKeyboardType] is the keyboard type of the search input.
  final TextInputType searchKeyboardType;

  /// [translations] is the translations of the input. By default we use [LayrzAppLocalizations] for translations,
  /// but you can submit your own translations using this property. Consider when [LayrzAppLocalizations] is present,
  /// is the default value of this property.
  /// Required translations:
  /// - `actions.cancel` (Cancel)
  /// - `actions.save` (Save)
  /// - `layrz.select.search` (Search in the list)
  /// - `layrz.select.empty` (No item found)
  final Map<String, String> translations;

  /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
  final bool overridesLayrzTranslations;

  /// [hideButtons] is the flag to hide the buttons of the input.
  final bool hideButtons;

  /// [customChild] is the custom widget to be displayed.
  /// Replaces the [ThemedTextInput] widget.
  final Widget? customChild;

  /// [hoverColor] is the hover color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color hoverColor;

  /// [focusColor] is the focus color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color focusColor;

  /// [splashColor] is the splash color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color splashColor;

  /// [highlightColor] is the highlight color of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `Colors.transparent`.
  final Color highlightColor;

  /// [borderRadius] is the border radius of the input. Only will affect when [customChild] is submitted.
  /// By default, it will use `BorderRadius.circular(10)`.
  final BorderRadius borderRadius;

  /// [canUnselect] is the flag to allow unselecting an item.
  final bool canUnselect;

  /// [returnNullOnClose] is the flag to return null when the dialog is closed and isn't selected something and/or
  /// have a value.
  final bool returnNullOnClose;

  /// [autoSelectFirst] is the flag to auto select the first item of the list. Only will apply
  /// when [value] is null and it's the first render of the object (when the [initState] is called).
  final bool autoSelectFirst;

  /// [dialogContraints] is the constraints of the dialog.
  final BoxConstraints dialogContraints;

  /// [itemExtent] is the extend of the item, used on the lists of the dual list input.
  final double itemExtent;

  /// [ThemedSelectInput] is the input for selecting an item from a list.
  const ThemedSelectInput({
    super.key,
    this.labelText,
    this.label,
    required this.items,
    this.onChanged,
    this.prefixIcon,
    this.prefixText,
    this.onPrefixTap,
    this.value,
    this.filter,
    this.enableSearch = true,
    this.disabled = false,
    this.errors = const [],
    this.hideDetails = false,
    this.hideTitle = false,
    this.autoclose = true,
    this.isRequired = false,
    this.dense = false,
    this.padding,
    this.searchKeyboardType = TextInputType.text,
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'layrz.select.search': 'Search in the list',
      'layrz.select.empty': 'No item found',
    },
    this.overridesLayrzTranslations = false,
    this.hideButtons = false,
    this.customChild,
    this.hoverColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.canUnselect = false,
    this.returnNullOnClose = false,
    this.autoSelectFirst = false,
    this.dialogContraints = const BoxConstraints(maxWidth: 500, maxHeight: 500),
    this.itemExtent = 50,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedSelectInput<T>> createState() => _ThemedSelectInputState<T>();
}

class _ThemedSelectInputState<T> extends State<ThemedSelectInput<T>> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String searchText = "";
  ThemedSelectItem<T>? selected;

  List<ThemedSelectItem<T>> get items => widget.items.where((item) {
    if (searchText.isEmpty) {
      return true;
    }

    return item.label.toLowerCase().contains(searchText.toLowerCase());
  }).toList();

  @override
  void initState() {
    super.initState();
    _handleUpdate(force: true, newValue: widget.value);
  }

  @override
  void didUpdateWidget(ThemedSelectInput<T> oldWidget) {
    if (oldWidget.value != widget.value) {
      _handleDidUpdateWidget();
    }
    super.didUpdateWidget(oldWidget);
  }

  String get displayedValue => selected?.label ?? t('layrz.select.empty');

  /// Handle external updates to the widget
  /// if the selected value state is changed by another widget
  /// @LuisReyes98 says:
  /// IT IS FORBIDDEN FOR THIS METHOD TO CALL `widget.onChanged`
  /// BECAUSE IT WILL CAUSE A LOOP 👁️👁️
  void _handleDidUpdateWidget() {
    if (widget.items.isNotEmpty) {
      ThemedSelectItem<T>? value = widget.items.firstWhereOrNull(
        (item) => item.value == widget.value,
      );
      selected = value;
      // if (mounted) _controller.text = displayedValue;
      setState(() {}); // Force rebuild
    }
  }

  void _handleUpdate({bool force = false, T? newValue, T? previousValue}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (previousValue == newValue && !force) {
        return;
      }

      if (widget.items.isNotEmpty) {
        ThemedSelectItem<T>? value = widget.items.firstWhereOrNull(
          (item) => item.value == widget.value,
        );
        setState(() => selected = value);

        if (widget.autoSelectFirst && selected == null) {
          setState(() => selected = widget.items.first);
        }

        if (mounted) _controller.text = displayedValue;

        widget.onChanged?.call(selected);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customChild != null) {
      return InkWell(
        onTap: widget.disabled ? null : _showPicker,
        child: widget.customChild,
      );
    }

    return ThemedTextInput(
      onTap: widget.disabled ? null : _showPicker,
      label: widget.label,
      labelText: widget.labelText,
      prefixIcon: widget.prefixIcon,
      prefixText: widget.prefixText,
      onPrefixTap: widget.onPrefixTap,
      suffixIcon: LayrzIcons.solarOutlineAltArrowDown,
      disabled: widget.disabled,
      dense: widget.dense,
      errors: widget.errors,
      padding: widget.padding,
      hideDetails: widget.hideDetails,
      value: displayedValue,
      focusNode: _focusNode,
      readonly: true,
    );
  }

  Future<void> _showPicker() async {
    SelectInputResult? result = await showDialog(
      context: context,
      builder: (context) {
        return DialogSelectInput(
          dialogConstraints: widget.dialogContraints,
          labelText: widget.labelText,
          hideTitle: widget.hideTitle,
          enableSearch: widget.enableSearch,
          searchKeyboardType: widget.searchKeyboardType,
          items: widget.items,
          itemExtent: widget.itemExtent,
          canUnselect: widget.canUnselect,
          returnNullOnClose: widget.returnNullOnClose,
          hideButtons: widget.hideButtons,
          translations: widget.translations,
          overridesLayrzTranslations: widget.overridesLayrzTranslations,
          autoclose: widget.autoclose,
          value: selected,
        );
      },
    );

    _focusNode.unfocus();

    /// If the result is null, User Tap outSide
    if (result == null) {
      if (widget.returnNullOnClose) {
        widget.onChanged?.call(null);
      } else {
        widget.onChanged?.call(selected);
      }
    } else {
      if (result.isRemoved) {
        /// widget.canUnselect return a value but with isRemoved flag == true
        widget.onChanged?.call(null);
      } else {
        /// Final result its all ok or normal
        widget.onChanged?.call(result.result as ThemedSelectItem<T>?);
      }
    }
  }

  String t(String key, [Map<String, dynamic> args = const {}]) {
    late String result;
    try {
      result = LayrzAppLocalizations.maybeOf(context)?.t(key, args) ?? widget.translations[key] ?? key;
    } catch (_) {
      result = widget.translations[key] ?? key;
    }

    if (widget.overridesLayrzTranslations) {
      result = widget.translations[key] ?? key;
    }

    if (args.isNotEmpty) {
      args.forEach((key, value) {
        result = result.replaceAll('{$key}', value.toString());
      });
    }

    return result;
  }
}

class DialogSelectInput<T> extends StatefulWidget {
  final BoxConstraints dialogConstraints;
  final String? labelText;
  final bool hideTitle;
  final bool enableSearch;
  final TextInputType searchKeyboardType;
  final List<ThemedSelectItem<T>> items;
  final double itemExtent;
  final bool canUnselect;
  final bool returnNullOnClose;
  final bool hideButtons;
  final Map<String, String> translations;
  final bool overridesLayrzTranslations;
  final bool autoclose;
  final ThemedSelectItem<T>? value;

  const DialogSelectInput({
    super.key,
    required this.dialogConstraints,
    required this.labelText,
    required this.hideTitle,
    required this.enableSearch,
    required this.searchKeyboardType,
    required this.items,
    required this.itemExtent,
    required this.canUnselect,
    required this.returnNullOnClose,
    required this.hideButtons,
    required this.translations,
    required this.overridesLayrzTranslations,
    required this.autoclose,
    required this.value,
  });

  @override
  State<DialogSelectInput> createState() => _DialogSelectInputState();
}

class _DialogSelectInputState extends State<DialogSelectInput> {
  ThemedSelectItem? selectedItem;
  String searchText = "";
  List<ThemedSelectItem> get items => widget.items.where((item) {
    if (searchText.isEmpty) return true;
    return item.label.toLowerCase().contains(searchText.toLowerCase());
  }).toList();
  @override
  void initState() {
    selectedItem = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.sizeOf(context).width < kSmallGrid;

    return PopScope(
      canPop: widget.hideButtons || selectedItem != null,
      child: Dialog(
        child: Container(
          constraints: widget.dialogConstraints,
          decoration: generateContainerElevation(
            context: context,
            elevation: 5,
            radius: 10,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title and Search
                  if (!widget.hideTitle) ...[
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 15, top: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          /// Title
                          Expanded(
                            child: Text(
                              widget.labelText ?? '',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),

                          /// Search
                          if (widget.enableSearch) ...[
                            Expanded(
                              child: ThemedSearchInput(
                                value: searchText,
                                onSearch: (value) => setState(() => searchText = value),
                                asField: true,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  if (items.isEmpty) ...[
                    Center(
                      child: Text(
                        t('layrz.select.empty'),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ] else ...[
                    /// Items
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemExtent: widget.itemExtent,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          bool isSelected = selectedItem == items[index];
                          return _ThemedSelectItem(
                            item: items[index],
                            selected: isSelected,
                            canUnselect: widget.canUnselect,
                            onTap: () {
                              items[index].onTap?.call();
                              if (isSelected && widget.canUnselect) {
                                selectedItem = null;
                              } else {
                                selectedItem = items[index];
                              }
                              setState(() {});
                              if (widget.autoclose) {
                                Navigator.of(context).pop(
                                  SelectInputResult(result: selectedItem),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],

                  /// Actions
                  if (!widget.hideButtons) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ).add(const EdgeInsets.only(bottom: 14)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ThemedButton.cancel(
                            isMobile: isMobile,
                            labelText: t('actions.cancel'),
                            onTap: () => Navigator.of(context).pop(
                              SelectInputResult(result: widget.value),
                            ),
                          ),
                          if (widget.canUnselect && selectedItem?.value != null)
                            ThemedButton(
                              style: isMobile ? ThemedButtonStyle.fab : ThemedButtonStyle.text,
                              icon: LayrzIcons.solarBoldMinusSquare,
                              labelText: t('layrz.select.unselect'),
                              color: Colors.orange,
                              onTap: () {
                                Navigator.of(context).pop(
                                  SelectInputResult(result: selectedItem, isRemoved: true),
                                );
                              },
                            ),
                          ThemedButton.save(
                            isMobile: isMobile,
                            labelText: t('actions.save'),
                            onTap: () => Navigator.of(context).pop(
                              SelectInputResult(result: selectedItem),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String t(String key, [Map<String, dynamic> args = const {}]) {
    late String result;
    try {
      result = LayrzAppLocalizations.maybeOf(context)?.t(key, args) ?? widget.translations[key] ?? key;
    } catch (_) {
      result = widget.translations[key] ?? key;
    }

    if (widget.overridesLayrzTranslations) {
      result = widget.translations[key] ?? key;
    }

    if (args.isNotEmpty) {
      args.forEach((key, value) {
        result = result.replaceAll('{$key}', value.toString());
      });
    }

    return result;
  }
}

class SelectInputResult {
  final ThemedSelectItem? result;
  final bool isRemoved;

  SelectInputResult({
    this.result,
    this.isRemoved = false,
  });

  @override
  String toString() {
    return 'FinalResult(result: $result, isRemoved: $isRemoved)';
  }
}
