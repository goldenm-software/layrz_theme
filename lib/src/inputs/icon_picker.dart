part of layrz_theme;

class ThemedIconPicker extends StatefulWidget {
  /// [labelText] is the label text of the icon picker. Avoid submit [label] and [labelText] at the same time.
  final String? labelText;

  /// [label] is the label widget of the icon picker. Avoid submit [label] and [labelText] at the same time.
  final Widget? label;

  /// [onChanged] is the callback function when the icon picker is changed.
  final void Function(IconData)? onChanged;

  /// [value] is the value of the icon picker.
  final IconData? value;

  /// [disabled] is the disabled state of the icon picker.
  final bool disabled;

  /// [errors] is the list of errors of the icon picker.
  final List<String> errors;

  /// [hideDetails] is the state of hiding the details of the icon picker.
  final bool hideDetails;

  /// [padding] is the padding of the icon picker.
  final EdgeInsets padding;

  /// [dense] is the state of the icon picker being dense.
  final bool dense;

  /// [isRequired] is the state of the icon picker being required.
  final bool isRequired;

  /// [focusNode] is the focus node of the icon picker.
  final FocusNode? focusNode;

  /// [borderRadius] is the border radius of the icon picker.
  final double? borderRadius;

  /// [containerHeight] is the height of the icon picker.
  final double? containerHeight;

  /// [customWidget] replaces the default text field with a custom widget.
  final Widget? customWidget;

  /// [ThemedIconPicker] is an icon picker input. It is a text field that opens an [OverlayEntry]
  /// with a list of icons to select from.
  const ThemedIconPicker({
    super.key,
    this.labelText,
    this.label,
    this.disabled = false,
    this.onChanged,
    this.value,
    this.errors = const [],
    this.hideDetails = false,
    this.padding = const EdgeInsets.all(10),
    this.dense = false,
    this.isRequired = false,
    this.focusNode,
    this.borderRadius,
    this.containerHeight,
    this.customWidget,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedIconPicker> createState() => _ThemedIconPickerState();
}

class _ThemedIconPickerState extends State<ThemedIconPicker> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController animation;
  late OverlayState overlayState;
  late ThemeData theme;
  IconData? _value;
  OverlayEntry? overlayEntry;
  String search = '';
  List<IconData>? selectedGroup;
  EdgeInsets get widgetPadding => widget.padding;
  bool get isDense => widget.dense;
  Color get color => Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).primaryColor;

  final GlobalKey key = GlobalKey();

  bool get disabled => widget.disabled;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: kHoverDuration);
    overlayState = Overlay.of(context, rootOverlay: true);
    _value = widget.value;
  }

  @override
  void didUpdateWidget(ThemedIconPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _value = widget.value;
      _controller.text = const IconOrNullConverter().toJson(_value) ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.customWidget != null) {
      return InkWell(
        key: key,
        onTap: widget.disabled ? null : _handleTap,
        child: widget.customWidget,
      );
    }
    return ThemedTextInput(
      key: key,
      prefixWidget: Padding(
        padding: const EdgeInsets.all(10),
        child: drawAvatar(
          context: context,
          icon: _value,
          size: isDense ? 20 : 30,
        ),
      ),
      suffixIcon: widget.disabled ? MdiIcons.lockOutline : MdiIcons.selectGroup,
      labelText: widget.labelText,
      label: widget.label,
      controller: _controller,
      dense: isDense,
      disabled: widget.disabled,
      value: const IconOrNullConverter().toJson(_value) ?? '',
      onTap: widget.disabled ? null : _handleTap,
    );
  }

  void _handleTap() {
    if (widget.disabled) return;
    if (overlayEntry != null) {
      _destroyOverlay();
    } else {
      _buildOverlay();
    }
  }

  void _destroyOverlay({VoidCallback? callback}) async {
    await animation.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
    callback?.call();
    setState(() {});
  }

  void _buildOverlay() {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    Size screenSize = MediaQuery.of(context).size;
    double height = widget.containerHeight ?? 300;
    double? top;
    double? bottom;

    if (screenSize.height - offset.dy > height) {
      top = offset.dy + widget.padding.top;
    } else {
      bottom = screenSize.height - offset.dy - renderBox.size.height - widget.padding.bottom;
    }
    if (height > 300) {
      height = 300;
    }

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(child: GestureDetector(onTap: _destroyOverlay)),
              Positioned(
                top: top,
                bottom: bottom,
                left: offset.dx + widget.padding.left,
                right: screenSize.width - (offset.dx + renderBox.size.width - widget.padding.right),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: animation,
                      child: StatefulBuilder(
                        builder: (BuildContext context, setState) {
                          return Container(
                            width: double.infinity,
                            constraints: BoxConstraints(maxHeight: height),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ThemedTextInput(
                                  labelText: i18n?.t('helpers.search') ?? 'Search',
                                  value: search,
                                  prefixIcon: MdiIcons.magnify,
                                  dense: true,
                                  onChanged: (value) {
                                    setState(() => search = value);
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(),
                                ),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (BuildContext context, BoxConstraints constraints) {
                                      return _IconGrid(
                                        iconSize: 16,
                                        selected: _value,
                                        constraints: constraints,
                                        onTap: (icon) {
                                          _destroyOverlay.call(callback: () {
                                            widget.onChanged?.call(icon);
                                            _value = icon;
                                            _controller.text = const IconOrNullConverter().toJson(_value) ?? '';
                                            setState(() {});
                                          });
                                        },
                                        search: search,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(overlayEntry!);
    animation.forward();
  }
}

typedef IconDataTapCallback = void Function(IconData icon);

class _IconGrid extends StatefulWidget {
  final IconDataTapCallback? onTap;
  final String search;
  final double iconSize;
  final IconData? selected;
  final BoxConstraints constraints;

  const _IconGrid({
    required this.iconSize,
    required this.constraints,
    this.onTap,
    this.search = '',
    this.selected,
  });

  @override
  State<_IconGrid> createState() => __IconGridState();
}

class __IconGridState extends State<_IconGrid> {
  BoxConstraints get constraints => widget.constraints;
  int get numOfColumns => (constraints.maxWidth / (widget.iconSize * 3)).floor();
  late ScrollController _scrollController;
  List<IconData> get icons {
    return iconMap.entries.where((entry) {
      if (widget.search.isNotEmpty) {
        return entry.key.toLowerCase().contains(widget.search.toLowerCase());
      }
      return true;
    }).map<IconData>((entry) {
      return entry.value;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _postFrameCallback();
  }

  @override
  void didUpdateWidget(_IconGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    _postFrameCallback();
  }

  void _postFrameCallback() {
    if (widget.selected != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final index = icons.indexOf(widget.selected!);
        if (index != -1) {
          final lines = (index / numOfColumns).floor();
          /*
          lines * ((widget.iconSize * scale factor of width and height of button) + padding)
          */
          _scrollController.jumpTo(lines * ((widget.iconSize * 2.5) + 10));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      controller: _scrollController,
      crossAxisCount: numOfColumns,
      childAspectRatio: 1,
      children: icons.map((icon) {
        return _IconButton(
          icon: icon,
          iconSize: widget.iconSize,
          onTap: () => widget.onTap?.call(icon),
          isSelected: widget.selected == icon,
        );
      }).toList(),
    );
  }
}

class _IconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double iconSize;
  final bool isSelected;

  const _IconButton({
    required this.icon,
    this.onTap,
    this.iconSize = 16,
    this.isSelected = false,
  });

  @override
  State<_IconButton> createState() => __IconButtonState();
}

class __IconButtonState extends State<_IconButton> {
  bool isHover = false;
  double get iconSize => widget.iconSize;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color hoverColor = isDark ? Colors.grey.shade700 : Colors.grey.shade200;
    return InkWell(
      onHover: (value) => setState(() {
        isHover = value;
      }),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: kHoverDuration,
        width: iconSize * 2.5,
        height: iconSize * 2.5,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: widget.isSelected || isHover ? hoverColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
