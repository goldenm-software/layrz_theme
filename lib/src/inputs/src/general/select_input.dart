part of inputs;

class ThemedSelectInput<T> extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final List<ThemedSelectItem<T>> items;
  final IconData? prefixIcon;
  final String? prefixText;
  final VoidCallback? onPrefixTap;
  final void Function(ThemedSelectItem<T>?)? onChanged;
  final T? value;
  final String searchLabel;
  final bool Function(String, ThemedSelectItem<T>)? filter;
  final bool enableSearch;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final bool hideTitle;
  final String saveText;
  final bool autoclose;
  final bool isRequired;
  final bool dense;
  final String emptyListText;
  final String emptyText;
  final EdgeInsets padding;
  final EdgeInsets overlayPadding;
  final double heightFactor;
  final double maxHeight;
  final TextInputType searchKeyboardType;
  final Map<String, String> translations;
  final bool overridesLayrzTranslations;
  final bool hideButtons;

  /// [ThemedSelectInput] is the input for selecting an item from a list.
  const ThemedSelectInput({
    super.key,

    /// [labelText] is the label of the input. Avoid using this if you are using [label] instead.
    this.labelText,

    /// [label] is the label of the input. Avoid using this if you are using [labelText] instead.
    this.label,

    /// [items] is the list of items to be selected.
    required this.items,

    /// [onChanged] is the callback when the input value changes.
    this.onChanged,

    /// [prefixIcon] is the icon to be displayed at the start of the input.
    this.prefixIcon,

    /// [prefixText] is the text to be displayed at the start of the input.
    this.prefixText,

    /// [onPrefixTap] is the callback when the prefix is tapped.
    this.onPrefixTap,

    /// [value] is the value of the input.
    this.value,

    /// [searchLabel] is the label of the search input.
    @Deprecated("Field unused") this.searchLabel = "Search",

    /// [filter] is the callback to filter the items.
    this.filter,

    /// [enableSearch] is the flag to enable the search input.
    this.enableSearch = true,

    /// [disabled] is the flag to disable the input.
    this.disabled = false,

    /// [errors] is the list of errors to be displayed.
    this.errors = const [],

    /// [hideDetails] is the flag to hide the details of the input.
    this.hideDetails = false,

    /// [hideTitle] is the flag to hide the title of the input.
    /// Important, when this property is true, automatically the search field is disabled.
    this.hideTitle = false,

    /// [saveText] is the text of the save button.
    @Deprecated("Field unused") this.saveText = "OK",

    /// [autoclose] is the flag to close the input when an item is selected.
    this.autoclose = true,

    /// [isRequired] is the flag to mark the input as required.
    this.isRequired = false,

    /// [dense] is the flag to make the input dense.
    this.dense = false,

    /// [emptyListText] is the text to be displayed when the list is empty.
    this.padding = const EdgeInsets.all(10),

    /// [emptyListText] is the text to be displayed when the list is empty.
    @Deprecated("Field unused") this.overlayPadding = const EdgeInsets.all(20),

    /// [emptyListText] is the text to be displayed when the list is empty.
    @Deprecated("Field unused") this.emptyText = "No item selected",

    /// [emptyListText] is the text to be displayed when the list is empty.
    @Deprecated("Field unused") this.emptyListText = "Without items available to select",

    /// [heightFactor] is the factor of the height of the input.
    @Deprecated("Field unused") this.heightFactor = 0.7,

    /// [maxHeight] is the maximum height of the input.
    @Deprecated("Field unused") this.maxHeight = 300,

    /// [searchKeyboardType] is the keyboard type of the search input.
    this.searchKeyboardType = TextInputType.text,

    /// [translations] is the translations of the input. By default we use [LayrzAppLocalizations] for translations,
    /// but you can submit your own translations using this property. Consider when [LayrzAppLocalizations] is present,
    /// is the default value of this property.
    /// Required translations:
    /// - `actions.cancel` (Cancel)
    /// - `actions.save` (Save)
    /// - `layrz.select.search` (Search in the list)
    /// - `layrz.select.empty` (No item found)
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'layrz.select.search': 'Search in the list',
      'layrz.select.empty': 'No item found',
    },

    /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
    this.overridesLayrzTranslations = false,

    /// [hideButtons] is the flag to hide the buttons of the input.
    this.hideButtons = false,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedSelectInput<T>> createState() => _ThemedSelectInputState<T>();
}

class _ThemedSelectInputState<T> extends State<ThemedSelectInput<T>> with SingleTickerProviderStateMixin {
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
    _handleUpdate(force: true);
  }

  @override
  void didUpdateWidget(ThemedSelectInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _handleUpdate();
    }
  }

  void _handleUpdate({bool force = false}) {
    if (selected?.value == widget.value && !force) return;

    if (widget.items.isNotEmpty) {
      try {
        ThemedSelectItem<T>? value = widget.items.firstWhereOrNull((item) => item.value == widget.value);
        if (value != null) {
          setState(() => selected = value);
        }

        Future.delayed(Duration.zero, () {
          widget.onChanged?.call(selected);
        });
      } on StateError catch (_) {
        setState(() => selected = null);
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
      value: selected?.label ?? t('layrz.select.empty'),
      focusNode: _focusNode,
      readonly: true,
      placeholder: widget.searchLabel,
    );
  }

  Future<void> _showPicker() async {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < kSmallGrid;

    ThemedSelectItem<T>? result = await showDialog(
      context: context,
      builder: (context) {
        searchText = "";
        ThemedSelectItem<T>? temp = selected;
        ScrollController scrollController = ScrollController();
        // Predict scroll position based on `_ThemedSelectItem.height` and the position in the list of the
        // selected element
        if (temp != null) {
          int index = items.map((e) => e.value).toList().indexOf(temp.value);

          if (index != -1) {
            double height = _ThemedSelectItem.height;
            double offset = index * height;
            scrollController = ScrollController(initialScrollOffset: offset);
          }
        }

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
                              return _ThemedSelectItem<T>(
                                item: items[index],
                                selected: temp?.value == items[index].value,
                                onTap: () {
                                  items[index].onTap?.call();
                                  setState(() => temp = items[index]);
                                  Navigator.of(context).pop(temp);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    if (!widget.hideButtons) ...[
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
                            icon: MdiIcons.check,
                            labelText: t('actions.save'),
                            color: Colors.green,
                            onTap: () => Navigator.of(context).pop(temp),
                          ),
                        ],
                      ),
                    ],
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
