part of '../../inputs.dart';

class ThemedMultiSelectInput<T> extends StatefulWidget {
  /// [items] is a list of [ThemedSelectItem] that will be displayed in the dropdown.
  final String? labelText;

  /// [label] is the label of the input.
  final Widget? label;

  /// [labelText] is the text of the label of the input.
  final List<ThemedSelectItem<T>> items;

  /// [prefixIcon] is the icon that will be displayed at the start of the input.
  final IconData? prefixIcon;

  /// [prefixText] is the text that will be displayed at the start of the input.
  final String? prefixText;

  /// [onPrefixTap] is the callback that will be called when the prefix is tapped.
  final VoidCallback? onPrefixTap;

  /// [onChanged] is the callback that will be called when the value of the input changes.
  final void Function(List<ThemedSelectItem<T>>)? onChanged;

  /// [value] is the value of the input.
  final List<T>? value;

  /// [autoselectFirst] is a flag that indicates if the first item of the list should be selected by default.
  final bool autoselectFirst;

  /// [searchLabel] is the label of the search input.
  final String searchLabel;

  /// [filter] is the function that will be used to filter the items.
  final bool Function(String, ThemedSelectItem<T>)? filter;

  /// [enableSearch] is a flag that indicates if the search input should be displayed.
  final bool enableSearch;

  /// [disabled] is a flag that indicates if the input is disabled.
  final bool disabled;

  /// [errors] is a list of errors that will be displayed below the input.
  final List<String> errors;

  /// [hideDetails] is a flag that indicates if the details of the input should be hidden.
  final bool hideDetails;

  /// [hideTitle] is a flag that indicates if the title of the input should be hidden.
  /// Important, when this property is true, automatically the search field is disabled.
  final bool hideTitle;

  /// [saveText] is the text of the save button.
  final String saveText;

  /// [autoclose] is a flag that indicates if the dropdown should be closed when the user selects an item.
  final bool autoclose;

  /// [emptyText] is the text that will be displayed when no items are selected.
  final String emptyText;

  /// [isRequired] is a flag that indicates if the input is required.
  final bool isRequired;

  /// [emptyListText] is the text that will be displayed when the list of items is empty.
  final String emptyListText;

  /// [padding] is the padding of the input.
  final EdgeInsets padding;

  /// [heightFactor] is the factor that will be used to calculate the height of the dropdown.
  final double heightFactor;

  /// [maxHeight] is the maximum height of the dropdown.
  final double maxHeight;

  /// [selectAllLabelText] is the text of the select all button.
  final String selectAllLabelText;

  /// [unselectAllLabelText] is the text of the unselect all button.
  final String unselectAllLabelText;

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
  /// - `layrz.select.selectAll` (Select all)
  /// - `layrz.select.unselectAll` (Unselect all)
  final Map<String, String> translations;

  /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
  final bool overridesLayrzTranslations;

  /// [dense] is a flag that indicates if the input is dense.
  final bool dense;

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

  /// [waitUntilClosedToSubmit] is a flag that indicates if the input should wait until the dialog is closed
  /// to submit the value (Call [onChanged]).
  final bool waitUntilClosedToSubmit;

  /// [ThemedMultiSelectInput] is a multi select input that allows the user to select multiple items from a list.
  const ThemedMultiSelectInput({
    super.key,
    required this.items,
    this.label,
    this.labelText,
    this.prefixIcon,
    this.prefixText,
    this.onPrefixTap,
    this.onChanged,
    this.value,
    this.autoselectFirst = true,
    @Deprecated('Field unused') this.searchLabel = "Search",
    this.filter,
    this.enableSearch = true,
    this.disabled = false,
    this.errors = const [],
    this.hideDetails = false,
    this.hideTitle = false,
    @Deprecated('Field unused') this.saveText = "OK",
    this.autoclose = false,
    @Deprecated('Field unused') this.emptyText = "No items selected",
    this.isRequired = false,
    @Deprecated('Field unused') this.emptyListText = "Without items available to select",
    this.padding = const EdgeInsets.all(10),
    @Deprecated('Field unused') this.heightFactor = 0.7,
    @Deprecated('Field unused') this.maxHeight = 400,
    @Deprecated('Field unused') this.selectAllLabelText = "Select all",
    @Deprecated('Field unused') this.unselectAllLabelText = "Unselect all",
    @Deprecated('Field unused') this.searchKeyboardType = TextInputType.text,
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'layrz.select.search': 'Search in the list',
      'layrz.select.empty': 'No item found',
      'layrz.select.selectAll': 'Select all',
      'layrz.select.unselectAll': 'Unselect all',
    },
    this.overridesLayrzTranslations = false,
    this.dense = false,
    this.customChild,
    this.hoverColor = Colors.transparent,
    this.focusColor = Colors.transparent,
    this.splashColor = Colors.transparent,
    this.highlightColor = Colors.transparent,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.waitUntilClosedToSubmit = false,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedMultiSelectInput<T>> createState() => _ThemedMultiSelectInputState<T>();
}

class _ThemedMultiSelectInputState<T> extends State<ThemedMultiSelectInput<T>> with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();

  List<ThemedSelectItem<T>> selected = [];
  final List<T?> customValues = [];
  String searchText = "";

  List<ThemedSelectItem<T>> get items => widget.items.where((item) {
        if (searchText.isEmpty) {
          return true;
        }

        return item.label.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

  @override
  void initState() {
    super.initState();
    _handleUpdate(force: true);
  }

  @override
  void didUpdateWidget(ThemedMultiSelectInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _handleUpdate();
    }
  }

  void _handleUpdate({bool force = false}) {
    if ((widget.value?.isEmpty ?? true) && force) {
      if (widget.autoselectFirst && widget.items.isNotEmpty) {
        selected = [widget.items.first];
        Future.delayed(Duration.zero, () {
          widget.onChanged?.call(selected);
        });
      }
      return;
    }
    Function eq = const ListEquality().equals;
    if (eq(widget.value, selected)) return;

    if (widget.items.isNotEmpty) {
      final values = widget.items.where((item) => (widget.value ?? []).contains(item.value)).toList();
      setState(() {
        selected = values;
      });

      if (force) {
        Future.delayed(Duration.zero, () {
          widget.onChanged?.call(selected);
        });
      }
    }
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
      suffixIcon: MdiIcons.chevronDown,
      disabled: widget.disabled,
      dense: widget.dense,
      errors: widget.errors,
      padding: widget.padding,
      hideDetails: widget.hideDetails,
      value: selected.isEmpty ? t('layrz.select.empty') : selected.map((e) => e.label).join(', '),
      focusNode: _focusNode,
      readonly: true,
      placeholder: widget.searchLabel,
    );
  }

  Future<void> _showPicker() async {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < kSmallGrid;

    List<ThemedSelectItem<T>>? result = await showDialog(
      context: context,
      builder: (context) {
        searchText = "";
        List<ThemedSelectItem<T>> temp = selected;
        ScrollController scrollController = ScrollController();
        // Predict scroll position based on `_ThemedSelectItem.height` and the position in the list of the
        // selected element

        return PopScope(
          canPop: false,
          child: Dialog(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
                  decoration: generateContainerElevation(context: context, elevation: 3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!widget.hideTitle) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.labelText ?? '',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            if (widget.enableSearch) ...[
                              const SizedBox(height: 10),
                              Expanded(
                                child: ThemedTextInput(
                                  labelText: t('layrz.select.search'),
                                  onChanged: (value) => setState(() => searchText = value),
                                  prefixIcon: MdiIcons.magnify,
                                  suffixIcon: searchText.isNotEmpty ? MdiIcons.close : null,
                                  onSuffixTap: searchText.isNotEmpty ? () => setState(() => searchText = "") : null,
                                  hideDetails: true,
                                  dense: true,
                                  keyboardType: widget.searchKeyboardType,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                      const SizedBox(height: 10),
                      if (items.isEmpty) ...[
                        Center(
                          child: Text(
                            t('layrz.select.empty'),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ] else ...[
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 300),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: ListView.builder(
                              itemCount: items.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final itm = items[index];
                                bool isSelected = temp.where((e) {
                                  return itm.value == e.value;
                                }).isNotEmpty;

                                return _ThemedSelectItem<T>(
                                  item: itm,
                                  selected: isSelected,
                                  canUnselect: true,
                                  onTap: () {
                                    itm.onTap?.call();

                                    final tempIds = temp.map((e) => e.value).toList();
                                    if (tempIds.contains(itm.value)) {
                                      temp.removeWhere((e) => e.value == itm.value);
                                    } else {
                                      temp.add(itm);
                                    }

                                    setState(() {});

                                    if (!widget.waitUntilClosedToSubmit) widget.onChanged?.call(temp);

                                    if (widget.autoclose) Navigator.of(context).pop(temp);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ThemedButton(
                            style: isMobile ? ThemedButtonStyle.filledFab : ThemedButtonStyle.filledTonal,
                            icon: MdiIcons.close,
                            labelText: t('actions.cancel'),
                            color: Colors.red,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          ThemedButton(
                            style: isMobile ? ThemedButtonStyle.filledFab : ThemedButtonStyle.filledTonal,
                            icon: temp.length == items.length ? MdiIcons.checkboxMarked : MdiIcons.checkboxBlankOutline,
                            labelText: t('layrz.select.${temp.length == items.length ? 'unselect' : 'select'}All'),
                            color: Colors.orange,
                            onTap: () {
                              if (temp.length == items.length) {
                                temp = [];
                              } else {
                                temp = items;
                              }
                              setState(() {});
                            },
                          ),
                          ThemedButton(
                            style: isMobile ? ThemedButtonStyle.filledFab : ThemedButtonStyle.filledTonal,
                            icon: MdiIcons.check,
                            labelText: t('actions.save'),
                            color: Colors.green,
                            onTap: () => Navigator.of(context).pop(temp),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    _focusNode.unfocus();
    if (result == null) return;
    setState(() => selected = result);
    widget.onChanged?.call(result);
  }

  String t(String key, [Map<String, dynamic> args = const {}]) {
    late String result;
    try {
      result = LayrzAppLocalizations.of(context)?.t(key, args) ?? widget.translations[key] ?? key;
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
