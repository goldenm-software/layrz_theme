part of layrz_theme;

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

  const ThemedMultiSelectInput({
    Key? key,
    required this.items,
    String? dialogLabelText,
    Widget? dialogLabel,
    this.label,
    this.labelText,
    this.prefixIcon,
    this.prefixText,
    this.onPrefixTap,
    this.onChanged,
    this.value,
    this.autoselectFirst = true,
    this.searchLabel = "Search",
    this.filter,
    this.enableSearch = true,
    this.disabled = false,
    this.errors = const [],
    this.hideDetails = false,
    this.hideTitle = false,
    this.saveText = "OK",
    this.autoclose = false,
    this.emptyText = "No items selected",
    this.isRequired = false,
    this.emptyListText = "Without items available to select",
    this.padding = const EdgeInsets.all(10),
    this.heightFactor = 0.7,
    this.maxHeight = 400,
    this.selectAllLabelText = "Select all",
    this.unselectAllLabelText = "Unselect all",
    this.searchKeyboardType = TextInputType.text,
  })  : assert((label == null && labelText != null) || (label != null && labelText == null)),
        super(key: key);

  @override
  State<ThemedMultiSelectInput<T>> createState() => _ThemedMultiSelectInputState<T>();
}

class _ThemedMultiSelectInputState<T> extends State<ThemedMultiSelectInput<T>> with SingleTickerProviderStateMixin {
  final GlobalKey key = GlobalKey();
  late AnimationController animation;
  late OverlayState overlayState;
  OverlayEntry? overlayEntry;
  final FocusNode focusNode = FocusNode();
  Duration get duration => const Duration(milliseconds: 150);
  Map<ThemedSelectItem<T>, bool> hovered = {};
  bool get hasAllSelected => widget.items.every((item) => selected.contains(item));

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List<ThemedSelectItem<T>> get items => widget.items.where((e) {
        if (searchText.isEmpty) {
          return true;
        }

        return e.label.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

  List<ThemedSelectItem<T>> selected = [];
  final List<T?> customValues = [];
  String searchText = "";

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: duration);
    overlayState = Overlay.of(context);
    _handleUpdate(force: true);
  }

  @override
  void didUpdateWidget(covariant ThemedMultiSelectInput<T> oldWidget) {
    Function eq = const ListEquality().equals;
    _handleUpdate(force: !eq(widget.value, oldWidget.value));
    super.didUpdateWidget(oldWidget);
  }

  void _handleUpdate({bool force = false}) {
    if (overlayEntry == null && widget.items.isNotEmpty) {
      final values = widget.items.where((item) => (widget.value ?? []).contains(item.value)).toList();
      setState(() {
        selected = values;

        if (values.isNotEmpty) {
          textEditingController.text = values.map((e) => e.label).join(", ");
        } else {
          textEditingController.text = widget.emptyText;
        }
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
    return Actions(
      actions: {
        DismissIntent: CallbackAction<DismissIntent>(
          onInvoke: (intent) {
            return false;
          },
        ),
      },
      child: ThemedTextInput(
        onTap: widget.disabled ? null : _handleTap,
        key: key,
        label: widget.label,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        prefixText: widget.prefixText,
        onPrefixTap: widget.onPrefixTap,
        suffixIcon: MdiIcons.chevronDown,
        disabled: widget.disabled,
        errors: widget.errors,
        padding: widget.padding,
        hideDetails: widget.hideDetails,
        controller: textEditingController,
        focusNode: focusNode,
        readonly: true,
        placeholder: widget.searchLabel,
      ),
    );
  }

  void _handleTap() {
    if (overlayEntry == null) {
      _buildOverlay();
    } else {
      _destroyOverlay();
    }
  }

  void _buildOverlay() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }

    double scrollOffset = 0;
    ScrollController listController = ScrollController(initialScrollOffset: scrollOffset);

    RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero);

    Size screenSize = MediaQuery.of(context).size;
    double width = box.size.width - widget.padding.horizontal;

    double height = screenSize.height * widget.heightFactor;

    double? top;
    double? bottom;

    if (screenSize.height - offset.dy > height) {
      top = offset.dy + widget.padding.top;
    } else {
      bottom = screenSize.height - offset.dy - box.size.height + widget.padding.bottom;
    }

    if (height > widget.maxHeight) {
      height = widget.maxHeight;
    }

    height += 2;

    FocusNode localFocusNode = FocusNode();

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _destroyOverlay,
                ),
              ),
              Positioned(
                top: top,
                bottom: bottom,
                left: offset.dx + widget.padding.left,
                child: SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            return Container(
                              width: double.infinity,
                              height: height,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Actions(
                                    actions: {
                                      DismissIntent: CallbackAction<DismissIntent>(
                                        onInvoke: (intent) {
                                          if (localFocusNode.hasFocus) {
                                            localFocusNode.unfocus();
                                          }

                                          return false;
                                        },
                                      ),
                                    },
                                    child: TextField(
                                      controller: searchController,
                                      focusNode: localFocusNode,
                                      keyboardType: widget.searchKeyboardType,
                                      decoration: InputDecoration(
                                        filled: true,
                                        isDense: true,
                                        hintText: widget.searchLabel,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onChanged: (value) => setState(() => searchText = value),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: height - 136,
                                    ),
                                    child: items.isEmpty
                                        ? Center(
                                            child: Text(widget.emptyListText),
                                          )
                                        : ListView.builder(
                                            padding: EdgeInsets.zero,
                                            controller: listController,
                                            itemCount: items.length,
                                            itemBuilder: (context, index) {
                                              ThemedSelectItem<T> item = items[index];
                                              bool isSelected = selected.contains(item);
                                              bool isDark = Theme.of(context).brightness == Brightness.dark;
                                              Color hoverColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
                                              Color cardColor = isSelected
                                                  ? hoverColor
                                                  : hovered[item] == true
                                                      ? hoverColor
                                                      : Theme.of(context).cardColor;

                                              return Container(
                                                height: 50,
                                                padding: const EdgeInsets.all(5),
                                                child: InkWell(
                                                  onHover: (value) {
                                                    setState(() => hovered[item] = value);
                                                  },
                                                  onTap: () {
                                                    if (selected.contains(item)) {
                                                      selected.remove(item);
                                                    } else {
                                                      selected.add(item);
                                                    }
                                                    widget.onChanged?.call(selected);
                                                    setState(() {});
                                                    textEditingController.text = item.label;
                                                    searchText = '';
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: duration,
                                                    curve: Curves.easeInOut,
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: cardColor,
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          isSelected ? MdiIcons.radioboxMarked : MdiIcons.radioboxBlank,
                                                          color: validateColor(color: cardColor),
                                                          size: 15,
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Expanded(
                                                          child: item.content ??
                                                              Row(
                                                                children: [
                                                                  if (item.leading != null) ...[
                                                                    SizedBox(
                                                                      width: 15,
                                                                      height: 15,
                                                                      child: item.leading!,
                                                                    ),
                                                                    const SizedBox(width: 5),
                                                                  ] else if (item.icon != null) ...[
                                                                    Icon(
                                                                      item.icon,
                                                                      color: validateColor(color: cardColor),
                                                                      size: 15,
                                                                    ),
                                                                    const SizedBox(width: 5),
                                                                  ] else ...[
                                                                    const SizedBox(width: 20),
                                                                  ],
                                                                  Expanded(
                                                                    child: Text(
                                                                      item.label,
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .bodySmall
                                                                          ?.copyWith(
                                                                            color: validateColor(color: cardColor),
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (widget.items.isEmpty) ...[
                                        const SizedBox(),
                                      ] else ...[
                                        ThemedButton(
                                          style: ThemedButtonStyle.filledTonal,
                                          color: isDark ? Colors.white : Theme.of(context).primaryColor,
                                          labelText:
                                              hasAllSelected ? widget.unselectAllLabelText : widget.selectAllLabelText,
                                          onTap: () {
                                            if (hasAllSelected) {
                                              selected.clear();
                                            } else {
                                              selected = widget.items;
                                            }

                                            widget.onChanged?.call(selected);
                                            setState(() {});
                                            _destroyOverlay();
                                          },
                                        ),
                                      ],
                                      ThemedButton(
                                        style: ThemedButtonStyle.filledTonal,
                                        color: Colors.green,
                                        labelText: widget.saveText,
                                        onTap: () => _destroyOverlay(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    animation.forward();
    overlayState.insert(overlayEntry!);
  }

  void _destroyOverlay() async {
    searchController.text = '';
    searchText = '';
    await animation.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
    _handleUpdate();
  }
}
