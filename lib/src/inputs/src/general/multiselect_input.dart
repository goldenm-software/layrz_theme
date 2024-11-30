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

  /// [autoclose] is a flag that indicates if the dropdown should be closed when the user selects an item.
  final bool autoclose;

  /// [isRequired] is a flag that indicates if the input is required.
  final bool isRequired;

  /// [padding] is the padding of the input.
  final EdgeInsets? padding;

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

  /// [dialogConstraints] is the constraints of the dialog.
  final BoxConstraints dialogConstraints;

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
    this.autoselectFirst = false,
    this.filter,
    this.enableSearch = true,
    this.disabled = false,
    this.errors = const [],
    this.hideDetails = false,
    this.hideTitle = false,
    this.autoclose = false,
    this.isRequired = false,
    this.padding,
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
    this.dialogConstraints = const BoxConstraints(maxWidth: 500, maxHeight: 500),
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
      suffixIcon: LayrzIcons.solarOutlineAltArrowDown,
      disabled: widget.disabled,
      dense: widget.dense,
      errors: widget.errors,
      padding: widget.padding,
      hideDetails: widget.hideDetails,
      value: selected.isEmpty ? t('layrz.select.empty') : selected.map((e) => e.label).join(', '),
      focusNode: _focusNode,
      readonly: true,
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
        // Predict scroll position based on `_ThemedSelectItem.height` and the position in the list of the
        // selected element

        return PopScope(
          canPop: false,
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  constraints: widget.dialogConstraints,
                  decoration: generateContainerElevation(
                    context: context,
                    elevation: 5,
                    radius: 10,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double availableHeight = constraints.maxHeight - (60 * 2);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!widget.hideTitle) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10).add(const EdgeInsets.only(
                                top: 14,
                                left: 5,
                              )),
                              child: Row(
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
                                        padding: EdgeInsets.zero,
                                        labelText: t('layrz.select.search'),
                                        onChanged: (value) => setState(() => searchText = value),
                                        prefixIcon: LayrzIcons.solarOutlineMagnifier,
                                        suffixIcon: searchText.isNotEmpty ? LayrzIcons.solarOutlineCloseSquare : null,
                                        onSuffixTap:
                                            searchText.isNotEmpty ? () => setState(() => searchText = "") : null,
                                        hideDetails: true,
                                        dense: true,
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
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ] else ...[
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: availableHeight),
                              child: ListView.builder(
                                itemCount: items.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(10),
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
                          ],
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10).add(const EdgeInsets.only(bottom: 14)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ThemedButton.cancel(
                                  isMobile: isMobile,
                                  labelText: t('actions.cancel'),
                                  onTap: () => Navigator.of(context).pop(null),
                                ),
                                ThemedButton(
                                  style: isMobile ? ThemedButtonStyle.fab : ThemedButtonStyle.text,
                                  icon: temp.length == items.length
                                      ? LayrzIcons.solarOutlineCheckSquare
                                      : LayrzIcons.solarBoldMinusSquare,
                                  labelText:
                                      t('layrz.select.${temp.length == items.length ? 'unselect' : 'select'}All'),
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
                                ThemedButton.save(
                                  isMobile: isMobile,
                                  labelText: t('actions.save'),
                                  onTap: () => Navigator.of(context).pop(temp),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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
