part of inputs;

class ThemedMultiSelectInput<T> extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final List<ThemedSelectItem<T>> items;
  final IconData? prefixIcon;
  final String? prefixText;
  final void Function()? onPrefixTap;
  final void Function(List<ThemedSelectItem<T>>)? onChanged;
  final List<T>? value;
  final bool autoselectFirst;
  final String searchLabel;
  final bool Function(String, ThemedSelectItem<T>)? filter;
  final bool enableSearch;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final bool hideTitle;
  final String saveText;
  final bool autoclose;
  final String emptyText;
  final bool isRequired;
  final String emptyListText;
  final EdgeInsets padding;
  final double heightFactor;
  final double maxHeight;
  final String selectAllLabelText;
  final String unselectAllLabelText;
  final TextInputType searchKeyboardType;
  final Map<String, String> translations;
  final bool overridesLayrzTranslations;
  final bool dense;

  /// [ThemedMultiSelectInput] is a multi select input that allows the user to select multiple items from a list.
  const ThemedMultiSelectInput({
    super.key,

    /// [items] is a list of [ThemedSelectItem] that will be displayed in the dropdown.
    required this.items,

    /// [label] is the label of the input.
    this.label,

    /// [labelText] is the text of the label of the input.
    this.labelText,

    /// [prefixIcon] is the icon that will be displayed at the start of the input.
    this.prefixIcon,

    /// [prefixText] is the text that will be displayed at the start of the input.
    this.prefixText,

    /// [onPrefixTap] is the callback that will be called when the prefix is tapped.
    this.onPrefixTap,

    /// [onChanged] is the callback that will be called when the value of the input changes.
    this.onChanged,

    /// [value] is the value of the input.
    this.value,

    /// [autoselectFirst] is a flag that indicates if the first item of the list should be selected by default.
    this.autoselectFirst = true,

    /// [searchLabel] is the label of the search input.
    @Deprecated('Field unused') this.searchLabel = "Search",

    /// [filter] is the function that will be used to filter the items.
    this.filter,

    /// [enableSearch] is a flag that indicates if the search input should be displayed.
    this.enableSearch = true,

    /// [disabled] is a flag that indicates if the input is disabled.
    this.disabled = false,

    /// [errors] is a list of errors that will be displayed below the input.
    this.errors = const [],

    /// [hideDetails] is a flag that indicates if the details of the input should be hidden.
    this.hideDetails = false,

    /// [hideTitle] is a flag that indicates if the title of the input should be hidden.
    /// Important, when this property is true, automatically the search field is disabled.
    this.hideTitle = false,

    /// [saveText] is the text of the save button.
    @Deprecated('Field unused') this.saveText = "OK",

    /// [autoclose] is a flag that indicates if the dropdown should be closed when the user selects an item.
    this.autoclose = false,

    /// [emptyText] is the text that will be displayed when no items are selected.
    @Deprecated('Field unused') this.emptyText = "No items selected",

    /// [isRequired] is a flag that indicates if the input is required.
    this.isRequired = false,

    /// [emptyListText] is the text that will be displayed when the list of items is empty.
    @Deprecated('Field unused') this.emptyListText = "Without items available to select",

    /// [padding] is the padding of the input.
    this.padding = const EdgeInsets.all(10),

    /// [heightFactor] is the factor that will be used to calculate the height of the dropdown.
    @Deprecated('Field unused') this.heightFactor = 0.7,

    /// [maxHeight] is the maximum height of the dropdown.
    @Deprecated('Field unused') this.maxHeight = 400,

    /// [selectAllLabelText] is the text of the select all button.
    @Deprecated('Field unused') this.selectAllLabelText = "Select all",

    /// [unselectAllLabelText] is the text of the unselect all button.
    @Deprecated('Field unused') this.unselectAllLabelText = "Unselect all",

    /// [searchKeyboardType] is the keyboard type of the search input.
    @Deprecated('Field unused') this.searchKeyboardType = TextInputType.text,

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
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'layrz.select.search': 'Search in the list',
      'layrz.select.empty': 'No item found',
      'layrz.select.selectAll': 'Select all',
      'layrz.select.unselectAll': 'Unselect all',
    },

    /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
    this.overridesLayrzTranslations = false,

    /// [dense] is a flag that indicates if the input is dense.
    this.dense = false,
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

        return Dialog(
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
                                onTap: () {
                                  itm.onTap?.call();

                                  final tempIds = temp.map((e) => e.value).toList();
                                  if (tempIds.contains(itm.value)) {
                                    temp.removeWhere((e) => e.value == itm.value);
                                  } else {
                                    temp.add(itm);
                                  }

                                  setState(() {});

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
        );
      },
    );

    _focusNode.unfocus();
    if (result == null) return;
    setState(() => selected = result);
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
