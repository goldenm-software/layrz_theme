part of inputs;

class ThemedSelectInput<T> extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final List<ThemedSelectItem<T>> items;
  final IconData? prefixIcon;
  final String? prefixText;
  final void Function()? onPrefixTap;
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
    this.searchLabel = "Search",

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
    this.hideTitle = false,

    /// [saveText] is the text of the save button.
    this.saveText = "OK",

    /// [autoclose] is the flag to close the input when an item is selected.
    this.autoclose = true,

    /// [isRequired] is the flag to mark the input as required.
    this.isRequired = false,

    /// [dense] is the flag to make the input dense.
    this.dense = false,

    /// [emptyListText] is the text to be displayed when the list is empty.
    this.padding = const EdgeInsets.all(10),

    /// [emptyListText] is the text to be displayed when the list is empty.
    this.overlayPadding = const EdgeInsets.all(20),

    /// [emptyListText] is the text to be displayed when the list is empty.
    this.emptyText = "No item selected",

    /// [emptyListText] is the text to be displayed when the list is empty.
    this.emptyListText = "Without items available to select",

    /// [heightFactor] is the factor of the height of the input.
    this.heightFactor = 0.7,

    /// [maxHeight] is the maximum height of the input.
    this.maxHeight = 300,

    /// [searchKeyboardType] is the keyboard type of the search input.
    this.searchKeyboardType = TextInputType.text,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedSelectInput<T>> createState() => _ThemedSelectInputState<T>();
}

class _ThemedSelectInputState<T> extends State<ThemedSelectInput<T>> with SingleTickerProviderStateMixin {
  final GlobalKey key = GlobalKey();
  late AnimationController animation;
  OverlayEntry? overlayEntry;
  final FocusNode focusNode = FocusNode();
  Duration get duration => const Duration(milliseconds: 150);
  Map<ThemedSelectItem<T>, bool> hovered = {};

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
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
    animation = AnimationController(vsync: this, duration: duration);
  }

  @override
  void didUpdateWidget(ThemedSelectInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _handleUpdate();
    }
  }

  void _handleUpdate({bool force = false}) {
    if (overlayEntry == null && widget.items.isNotEmpty) {
      try {
        ThemedSelectItem<T>? value = widget.items.firstWhereOrNull((item) => item.value == widget.value);
        setState(() {
          if (value != null) {
            selected = value;
            textEditingController.text = selected!.label;
          }
        });

        Future.delayed(Duration.zero, () {
          widget.onChanged?.call(selected);
        });
      } on StateError catch (_) {
        setState(() {
          selected = null;
          textEditingController.text = widget.emptyText;
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
        dense: widget.dense,
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
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }

    double scrollOffset = 0;

    if (selected != null) {
      scrollOffset = items.indexOf(selected!) * 50.0;
    }

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

    FocusNode localFocusNode = FocusNode();

    overlayEntry = OverlayEntry(
      builder: (context) {
        return PointerInterceptor(
          child: Material(
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
                                height: height - 1,
                                padding: widget.overlayPadding,
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
                                    if (widget.enableSearch) ...[
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
                                    ],
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: height - (widget.enableSearch ? 100 : 45),
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
                                                bool isSelected = selected == item;
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
                                                      widget.onChanged?.call(item);
                                                      setState(() => selected = item);
                                                      textEditingController.text = item.label;
                                                      searchText = '';
                                                      _destroyOverlay();
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
                                                            isSelected
                                                                ? MdiIcons.radioboxMarked
                                                                : MdiIcons.radioboxBlank,
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
          ),
        );
      },
    );
    animation.forward();
    Overlay.of(context, rootOverlay: true).insert(overlayEntry!);
  }

  void _destroyOverlay() async {
    searchController.text = '';
    searchText = '';
    await animation.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
  }
}
