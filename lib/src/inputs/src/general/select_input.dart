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

  /// [searchLabel] is the label of the search input.
  final String searchLabel;

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

  /// [saveText] is the text of the save button.
  final String saveText;

  /// [autoclose] is the flag to close the input when an item is selected.
  final bool autoclose;

  /// [isRequired] is the flag to mark the input as required.
  final bool isRequired;

  /// [dense] is the flag to make the input dense.
  final bool dense;

  /// [emptyListText] is the text to be displayed when the list is empty.
  final String emptyListText;

  /// [emptyListText] is the text to be displayed when the list is empty.
  final String emptyText;

  /// [emptyListText] is the text to be displayed when the list is empty.
  final EdgeInsets? padding;

  /// [emptyListText] is the text to be displayed when the list is empty.
  final EdgeInsets overlayPadding;

  /// [heightFactor] is the factor of the height of the input.
  final double heightFactor;

  /// [maxHeight] is the maximum height of the input.
  final double maxHeight;

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
  final BoxConstraints? dialogContraints;

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
    @Deprecated("Field unused") this.searchLabel = "Search",
    this.filter,
    this.enableSearch = true,
    this.disabled = false,
    this.errors = const [],
    this.hideDetails = false,
    this.hideTitle = false,
    @Deprecated("Field unused") this.saveText = "OK",
    this.autoclose = true,
    this.isRequired = false,
    this.dense = false,
    this.padding,
    @Deprecated("Field unused") this.overlayPadding = const EdgeInsets.all(20),
    @Deprecated("Field unused") this.emptyText = "No item selected",
    @Deprecated("Field unused") this.emptyListText = "Without items available to select",
    @Deprecated("Field unused") this.heightFactor = 0.7,
    @Deprecated("Field unused") this.maxHeight = 300,
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
    _handleUpdate(force: true, autoselect: widget.autoSelectFirst);
  }

  @override
  void didUpdateWidget(ThemedSelectInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _handleUpdate();
    }
  }

  void _handleUpdate({bool force = false, bool autoselect = false}) {
    if (selected?.value == widget.value && !force) return;

    if (widget.items.isNotEmpty) {
      try {
        ThemedSelectItem<T>? value = widget.items.firstWhereOrNull((item) => item.value == widget.value);
        setState(() => selected = value);
      } on StateError catch (_) {
        setState(() => selected = null);
      }

      if (autoselect && selected == null) {
        setState(() => selected = widget.items.first);
      }

      Future.delayed(Duration.zero, () {
        widget.onChanged?.call(selected);
      });
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

        return PopScope(
          canPop: widget.hideButtons || temp != null,
          child: Dialog(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  constraints: widget.dialogContraints,
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
                                  canUnselect: widget.canUnselect,
                                  onTap: () {
                                    items[index].onTap?.call();
                                    if (temp?.value == items[index].value && widget.canUnselect) {
                                      setState(() => temp = null);
                                      Navigator.of(context).pop(null);
                                    } else {
                                      setState(() => temp = items[index]);
                                      Navigator.of(context).pop(temp);
                                    }
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
                              onTap: () => Navigator.of(context).pop(null),
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
          ),
        );
      },
    );

    _focusNode.unfocus();
    if (widget.returnNullOnClose && result == null) {
      widget.onChanged?.call(null);
      setState(() => selected = result);
    } else if (result != null) {
      widget.onChanged?.call(result);
      setState(() => selected = result);
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
