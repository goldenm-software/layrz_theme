part of inputs;

class ThemedDualListInput<T> extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final List<ThemedSelectItem<T>> items;
  final void Function(List<ThemedSelectItem<T>>)? onChanged;
  final List<T>? value;
  final bool disabled;
  final List<String> errors;
  final String availableText;
  final String selectedText;
  final String searchText;

  /// [ThemedDualListInput] is a dual list input.
  const ThemedDualListInput({
    super.key,

    /// [labelText] is the label text of the dual list input. Avoid submit [label] and [labelText] at the same time.
    this.labelText,

    /// [label] is the label widget of the dual list input. Avoid submit [label] and [labelText] at the same time.
    this.label,

    /// [items] is the list of items of the dual list input.
    required this.items,

    /// [onChanged] is the callback function when the dual list input is changed.
    this.onChanged,

    /// [value] is the value of the dual list input.
    this.value,

    /// [disabled] is the disabled state of the dual list input.
    this.disabled = false,

    /// [errors] is the list of errors of the dual list input.
    this.errors = const [],

    /// [availableText] is the text of the available list.
    this.availableText = "Available",

    /// [selectedText] is the text of the selected list.
    this.selectedText = "Selected",

    /// [searchText] is the text of the search input.
    this.searchText = "Search",
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedDualListInput<T>> createState() => _ThemedDualListInputState<T>();
}

class _ThemedDualListInputState<T> extends State<ThemedDualListInput<T>> {
  final List<ThemedSelectItem<T>> available = [];
  final List<ThemedSelectItem<T>> selected = [];

  bool get someHasIcon => widget.items.any((element) => element.icon != null);

  List<ThemedSelectItem<T>> selectedFiltered = [];
  List<ThemedSelectItem<T>> availableFiltered = [];

  String search = "";

  @override
  void initState() {
    super.initState();

    available.addAll(widget.items);

    for (final item in widget.value ?? []) {
      final index = available.indexWhere((element) => element.value == item);
      if (index != -1) {
        selected.add(available.removeAt(index));
      }
    }
    availableFiltered = getAvailableFiltered();
    selectedFiltered = getSelectedFiltered();
  }

  @override
  void didUpdateWidget(covariant ThemedDualListInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    for (final item in widget.value ?? []) {
      final index = available.indexWhere((element) => element.value == item);
      if (index != -1) {
        selected.add(available.removeAt(index));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDark = Theme.of(context).brightness == Brightness.dark;
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
              decoration: BoxDecoration(
                color: buttonsColors,
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: () => toggleAllToSelected(),
                child: Icon(allToSelected, color: validateColor(color: buttonsColors)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: buttonsColors,
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: () => toggleAllToAvailable(),
                child: Icon(allToAvailable, color: validateColor(color: buttonsColors)),
              ),
            ),
          ),
        ];

        Widget searchWidget = ThemedTextInput(
          labelText: widget.searchText,
          value: search,
          prefixIcon: MdiIcons.magnify,
          dense: true,
          onChanged: (value) {
            setState(() {
              search = value;
              availableFiltered = getAvailableFiltered();
              selectedFiltered = getSelectedFiltered();
            });
          },
        );

        Widget availableWidget = Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: generateContainerElevation(context: context, elevation: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.availableText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    itemCount: availableFiltered.length,
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(),
                    ),
                    itemBuilder: (context, index) {
                      final item = availableFiltered[index];

                      return generateItem(
                        item: item,
                        onTap: widget.disabled
                            ? null
                            : () {
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
            decoration: generateContainerElevation(context: context, elevation: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    widget.selectedText,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    itemCount: selectedFiltered.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = selectedFiltered[index];

                      return generateItem(
                        item: item,
                        onTap: widget.disabled
                            ? null
                            : () {
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

        return Container(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
          ),
          height: displayVertical ? null : 400,
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
                    searchWidget,
                    SizedBox(
                      height: 300,
                      child: availableWidget,
                    ),
                    if (!widget.disabled) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions,
                      ),
                    ],
                    SizedBox(
                      height: 300,
                      child: selectedWidget,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: widget.label ?? Text(widget.labelText ?? ''),
                    ),
                    searchWidget,
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: availableWidget,
                          ),
                          if (!widget.disabled) ...[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: actions,
                            ),
                          ],
                          Expanded(
                            child: selectedWidget,
                          ),
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
        if (search.isEmpty) {
          return true;
        }
        return element.label.toLowerCase().contains(search.toLowerCase());
      }).toList();

  List<ThemedSelectItem<T>> getAvailableFiltered() => available.where((element) {
        if (search.isEmpty) {
          return true;
        }

        return element.label.toLowerCase().contains(search.toLowerCase());
      }).toList();

  void toggleAllToSelected() {
    if (search.isNotEmpty) {
      availableFiltered = getAvailableFiltered();
      selected.addAll(availableFiltered);

      available.removeWhere((element) => availableFiltered.contains(element));
    } else {
      selected.addAll(available);
      available.clear();
    }
    selected.sort((a, b) => a.label.compareTo(b.label));
    widget.onChanged?.call(selected);
    availableFiltered = getAvailableFiltered();
    selectedFiltered = getSelectedFiltered();
    setState(() {});
  }

  void toggleAllToAvailable() {
    if (search.isNotEmpty) {
      selectedFiltered = getSelectedFiltered();
      available.addAll(selectedFiltered);

      selected.removeWhere((element) => selectedFiltered.contains(element));
    } else {
      available.addAll(selected);
      selected.clear();
    }

    available.sort((a, b) => a.label.compareTo(b.label));
    widget.onChanged?.call(selected);
    availableFiltered = getAvailableFiltered();
    selectedFiltered = getSelectedFiltered();
    setState(() {});
  }
}
