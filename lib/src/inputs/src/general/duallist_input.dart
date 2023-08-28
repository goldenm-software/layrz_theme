part of inputs;

class ThemedDualListInput<T> extends StatefulWidget {
  /// [labelText] is the label text of the dual list input. Avoid submit [label] and [labelText] at the same time.
  final String? labelText;

  /// [label] is the label widget of the dual list input. Avoid submit [label] and [labelText] at the same time.
  final Widget? label;

  /// [items] is the list of items of the dual list input.
  final List<ThemedSelectItem<T>> items;

  /// [onChanged] is the callback function when the dual list input is changed.
  final void Function(List<ThemedSelectItem<T>>)? onChanged;

  /// [value] is the value of the dual list input.
  final List<T>? value;

  /// [disabled] is the disabled state of the dual list input.
  final bool disabled;

  /// [errors] is the list of errors of the dual list input.
  final List<String> errors;

  /// [availableText] is the text of the available list.
  final String availableText;

  /// [selectedText] is the text of the selected list.
  final String selectedText;

  /// [searchText] is the text of the search input.
  final String searchText;

  /// [translations] is the translations of the input. By default we use [LayrzAppLocalizations] for translations,
  /// but you can submit your own translations using this property. Consider when [LayrzAppLocalizations] is present,
  /// is the default value of this property.
  /// Required translations:
  /// - `actions.cancel` (Cancel)
  /// - `actions.save` (Save)
  /// - `layrz.duallist.search` (Search in {name})
  /// - `layrz.duallist.toggleToSelected` (Toggle all to selected)
  /// - `layrz.duallist.toggleToAvailable` (Toggle all to available)
  final Map<String, String> translations;

  /// [overridesLayrzTranslations] is the flag to override the default translations of Layrz.
  final bool overridesLayrzTranslations;

  /// [height] is the height of the dual list input.
  /// In mobile mode, the height is multiplied by [mobileScaleFactor].
  final double height;

  /// [availableListName] is the name of the available list.
  final String availableListName;

  /// [selectedListName] is the name of the selected list.
  final String selectedListName;

  /// [mobileScaleFactor] is the scale factor of the height in mobile mode.
  final double mobileScaleFactor;

  /// [ThemedDualListInput] is a dual list input.
  const ThemedDualListInput({
    super.key,
    this.labelText,
    this.label,
    required this.items,
    this.onChanged,
    this.value,
    this.disabled = false,
    this.errors = const [],
    @Deprecated("Field unused") this.availableText = "Available",
    @Deprecated("Field unused") this.selectedText = "Selected",
    @Deprecated("Field unused") this.searchText = "Search",
    this.translations = const {
      'actions.cancel': 'Cancel',
      'actions.save': 'Save',
      'layrz.duallist.search': 'Search in {name}',
      'layrz.duallist.toggleToSelected': 'Toggle all to selected',
      'layrz.duallist.toggleToAvailable': 'Toggle all to available',
    },
    this.overridesLayrzTranslations = false,
    this.height = 400,
    this.availableListName = "Available",
    this.selectedListName = "Selected",
    this.mobileScaleFactor = 2,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedDualListInput<T>> createState() => _ThemedDualListInputState<T>();
}

class _ThemedDualListInputState<T> extends State<ThemedDualListInput<T>> {
  bool get someHasIcon => widget.items.any((element) => element.icon != null);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  List<ThemedSelectItem<T>> available = [];
  List<ThemedSelectItem<T>> selected = [];

  List<ThemedSelectItem<T>> selectedFiltered = [];
  List<ThemedSelectItem<T>> availableFiltered = [];

  String searchAvailable = "";
  String searchSelected = "";

  @override
  void initState() {
    super.initState();
    _handleUpdate();
  }

  @override
  void didUpdateWidget(ThemedDualListInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _handleUpdate();
  }

  void _handleUpdate() {
    Function eq = const ListEquality().equals;
    available = List<ThemedSelectItem<T>>.from(widget.items);
    selected = [];

    if (!eq(selected, widget.value)) {
      for (T item in widget.value ?? []) {
        final index = available.indexWhere((element) => element.value == item);
        if (index != -1) {
          selected.add(available.removeAt(index));
        }
      }
    }

    searchAvailable = "";
    searchSelected = "";
    availableFiltered = getAvailableFiltered();
    selectedFiltered = getSelectedFiltered();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        IconData allToSelected = MdiIcons.chevronDoubleRight;
        IconData allToAvailable = MdiIcons.chevronDoubleLeft;
        bool displayVertical = false;
        Color buttonsColors = isDark ? Colors.white : Theme.of(context).primaryColor;

        if (constraints.maxWidth <= kExtraSmallGrid) {
          allToSelected = MdiIcons.chevronDoubleDown;
          allToAvailable = MdiIcons.chevronDoubleUp;
          displayVertical = true;
        }

        List<Widget> actions = [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 30,
              height: 30,
              decoration: generateContainerElevation(
                context: context,
                elevation: 2,
                color: buttonsColors,
              ),
              clipBehavior: Clip.antiAlias,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => toggleAllToSelected(),
                  child: Icon(allToSelected, color: validateColor(color: buttonsColors)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 30,
              height: 30,
              decoration: generateContainerElevation(
                context: context,
                elevation: 2,
                color: buttonsColors,
              ),
              clipBehavior: Clip.antiAlias,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => toggleAllToAvailable(),
                  child: Icon(allToAvailable, color: validateColor(color: buttonsColors)),
                ),
              ),
            ),
          ),
        ];

        Widget availableWidget = Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: generateContainerElevation(context: context, elevation: 2),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.availableListName} (${available.length})",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ThemedSearchInput(
                      labelText: t('layrz.duallist.search', {'name': widget.availableListName}),
                      value: searchAvailable,
                      onSearch: (value) {
                        searchAvailable = value;
                        availableFiltered = getAvailableFiltered();
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableFiltered.length,
                    itemBuilder: (context, index) {
                      final item = availableFiltered[index];

                      return _ThemedSelectItem<T>(
                        showCheckbox: false,
                        item: item,
                        onTap: () {
                          item.onTap?.call();

                          final availableGlobal = available.indexOf(item);

                          selected.add(available[availableGlobal]);
                          available.removeAt(availableGlobal);
                          available.sort((a, b) => a.label.compareTo(b.label));
                          selected.sort((a, b) => a.label.compareTo(b.label));
                          widget.onChanged?.call(selected);
                          availableFiltered = getAvailableFiltered();
                          selectedFiltered = getSelectedFiltered();
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );

        Widget selectedWidget = Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: generateContainerElevation(context: context, elevation: 2),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.selectedListName} (${selected.length})",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    ThemedSearchInput(
                      labelText: t('layrz.duallist.search', {'name': widget.selectedListName}),
                      value: searchAvailable,
                      onSearch: (value) {
                        searchAvailable = value;
                        availableFiltered = getAvailableFiltered();
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedFiltered.length,
                    itemBuilder: (context, index) {
                      final item = selectedFiltered[index];

                      return _ThemedSelectItem<T>(
                        showCheckbox: false,
                        item: item,
                        onTap: () {
                          item.onTap?.call();

                          final selectedGlobal = selected.indexOf(item);

                          available.add(selected[selectedGlobal]);
                          selected.removeAt(selectedGlobal);
                          available.sort((a, b) => a.label.compareTo(b.label));
                          selected.sort((a, b) => a.label.compareTo(b.label));
                          widget.onChanged?.call(selected);
                          availableFiltered = getAvailableFiltered();
                          selectedFiltered = getSelectedFiltered();
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );

        return SizedBox(
          height: widget.height * (displayVertical ? widget.mobileScaleFactor : 1),
          child: displayVertical
              ? Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: widget.label ?? Text(widget.labelText ?? ''),
                        ),
                      ],
                    ),
                    Expanded(child: availableWidget),
                    if (!widget.disabled) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions,
                      ),
                    ],
                    Expanded(child: selectedWidget),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: widget.label ?? Text(widget.labelText ?? ''),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: availableWidget),
                          if (!widget.disabled) ...[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: actions,
                            ),
                          ],
                          Expanded(child: selectedWidget),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget generateItem({required ThemedSelectItem<T> item, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: InkWell(
        onTap: onTap,
        child: item.content ??
            Row(
              children: [
                const SizedBox(width: 10),
                if (item.leading != null) ...[
                  SizedBox(width: 15, height: 15, child: item.leading!),
                  const SizedBox(width: 10),
                ] else if (item.icon != null) ...[
                  Icon(item.icon, size: 15),
                  const SizedBox(width: 10),
                ] else if (someHasIcon) ...[
                  const SizedBox(width: 25),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
      ),
    );
  }

  List<ThemedSelectItem<T>> getSelectedFiltered() => selected.where((element) {
        if (searchSelected.isEmpty) {
          return true;
        }
        return element.label.toLowerCase().contains(searchSelected.toLowerCase());
      }).toList();

  List<ThemedSelectItem<T>> getAvailableFiltered() => available.where((element) {
        if (searchAvailable.isEmpty) {
          return true;
        }

        return element.label.toLowerCase().contains(searchAvailable.toLowerCase());
      }).toList();

  void toggleAllToSelected() {
    if (searchAvailable.isNotEmpty) {
      availableFiltered = getAvailableFiltered();
      selected.addAll(availableFiltered);

      available.removeWhere((element) => availableFiltered.contains(element));
    } else {
      selected.addAll(available);
      available.clear();
    }
    selected.sort((a, b) => a.label.compareTo(b.label));
    widget.onChanged?.call(selected);
    searchAvailable = "";
    searchSelected = "";
    availableFiltered = getAvailableFiltered();
    selectedFiltered = getSelectedFiltered();
    setState(() {});
  }

  void toggleAllToAvailable() {
    if (searchSelected.isNotEmpty) {
      selectedFiltered = getSelectedFiltered();
      available.addAll(selectedFiltered);

      selected.removeWhere((element) => selectedFiltered.contains(element));
    } else {
      available.addAll(selected);
      selected.clear();
    }

    available.sort((a, b) => a.label.compareTo(b.label));
    widget.onChanged?.call(selected);
    searchAvailable = "";
    searchSelected = "";
    availableFiltered = getAvailableFiltered();
    selectedFiltered = getSelectedFiltered();
    setState(() {});
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
