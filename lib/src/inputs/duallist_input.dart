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

  const ThemedDualListInput({
    super.key,
    required this.items,
    this.label,
    this.labelText,
    this.onChanged,
    this.value,
    this.disabled = false,
    this.errors = const [],
    this.availableText = "Available",
    this.selectedText = "Selected",
    this.searchText = "Search",
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedDualListInput<T>> createState() => _ThemedDualListInputState<T>();
}

class _ThemedDualListInputState<T> extends State<ThemedDualListInput<T>> {
  final List<ThemedSelectItem<T>> available = [];
  final List<ThemedSelectItem<T>> selected = [];

  bool get someHasIcon => widget.items.any((element) => element.icon != null);

  List<ThemedSelectItem<T>> get selectedFiltered => selected.where((element) {
        if (search.isEmpty) {
          return true;
        }
        return element.label.toLowerCase().contains(search.toLowerCase());
      }).toList();

  List<ThemedSelectItem<T>> get availableFiltered => available.where((element) {
        if (search.isEmpty) {
          return true;
        }

        return element.label.toLowerCase().contains(search.toLowerCase());
      }).toList();

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
                  child: Text(widget.availableText, style: Theme.of(context).textTheme.titleSmall),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(),
                ),
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
                        onTap: () {
                          final availableGlobal = available.indexOf(item);

                          selected.add(available[availableGlobal]);
                          available.removeAt(availableGlobal);
                          available.sort((a, b) => a.label.compareTo(b.label));
                          selected.sort((a, b) => a.label.compareTo(b.label));
                          widget.onChanged?.call(selected);
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
                  child: Text(widget.selectedText, style: Theme.of(context).textTheme.titleSmall),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: selectedFiltered.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = selectedFiltered[index];

                      return generateItem(
                        item: item,
                        onTap: () {
                          final selectedGlobal = selected.indexOf(item);

                          available.add(selected[selectedGlobal]);
                          selected.removeAt(selectedGlobal);
                          available.sort((a, b) => a.label.compareTo(b.label));
                          selected.sort((a, b) => a.label.compareTo(b.label));
                          widget.onChanged?.call(selected);
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions,
                    ),
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
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: actions,
                          ),
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

  Widget generateItem({required ThemedSelectItem<T> item, required VoidCallback onTap}) {
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

  void toggleAllToSelected() {
    selected.addAll(available);
    available.clear();

    selected.sort((a, b) => a.label.compareTo(b.label));
    widget.onChanged?.call(selected);
    setState(() {});
  }

  void toggleAllToAvailable() {
    available.addAll(selected);
    selected.clear();

    available.sort((a, b) => a.label.compareTo(b.label));
    widget.onChanged?.call(selected);
    setState(() {});
  }
}
