part of inputs;

class ThemedDynamicAvatarInput extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final AvatarInput? value;
  final void Function(AvatarInput?)? onChanged;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final EdgeInsets padding;
  final List<AvatarType> enabledTypes;
  final double heightFactor;
  final double maxHeight;

  const ThemedDynamicAvatarInput({
    super.key,
    this.label,
    this.value,
    this.labelText,
    this.onChanged,
    this.disabled = false,
    this.errors = const [],
    this.hideDetails = false,
    this.padding = const EdgeInsets.all(10),
    this.enabledTypes = const [
      AvatarType.url,
      AvatarType.base64,
      AvatarType.icon,
      AvatarType.emoji,
    ],
    this.heightFactor = 0.7,
    this.maxHeight = 350,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedDynamicAvatarInput> createState() => _ThemedDynamicAvatarInputState();
}

class _ThemedDynamicAvatarInputState extends State<ThemedDynamicAvatarInput> with TickerProviderStateMixin {
  late AnimationController animation;
  OverlayEntry? overlayEntry;
  final ScrollController _emojiController = ScrollController();
  EmojiGroup? selectedGroup;
  String search = "";

  late AvatarInput _value;
  EdgeInsets get padding => widget.padding;
  bool get disabled => widget.disabled;
  GlobalKey key = GlobalKey();

  List<AvatarType> get enabledTypes => [
        AvatarType.none,
        ...widget.enabledTypes,
      ];

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? AvatarInput();
    animation = AnimationController(vsync: this, duration: kHoverDuration);
  }

  @override
  Widget build(BuildContext context) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color containerColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
    Color iconColor = isDark ? Colors.grey.shade300 : Colors.grey.shade600;
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: disabled ? null : _handleTap,
            child: Container(
              key: key,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  drawAvatar(
                    context: context,
                    size: 50,
                    radius: 25,
                    dynamicAvatar: Avatar.fromJson(_value.toJson()),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(i18n?.t("helpers.dynamicAvatar.types.${_value.type}") ?? "Type: ${_value.type}"),
                  ),
                  if (!disabled) ...[
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.edit, size: 15, color: iconColor),
                      onPressed: disabled ? null : _handleTap,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (widget.errors.isNotEmpty) ThemedFieldDisplayError(errors: widget.errors, hideDetails: widget.hideDetails),
        ],
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
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);
    RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    Offset offset = box.localToGlobal(Offset.zero);

    Size screenSize = MediaQuery.of(context).size;
    bool isSmall = screenSize.width < kSmallGrid;
    double width = box.size.width - widget.padding.right;

    double height = screenSize.height * widget.heightFactor;

    double? top;
    double? bottom;

    if (screenSize.height - offset.dy > height) {
      top = offset.dy;
    } else {
      bottom = screenSize.height - offset.dy - box.size.height;
    }

    if (height > widget.maxHeight) {
      height = widget.maxHeight;
    }

    if (_value.type == AvatarType.emoji && _value.emoji != null) {
      final emoji = Emoji.byChar(_value.emoji!);
      selectedGroup = emoji?.emojiGroup;
    }

    ScrollController typesController = ScrollController();

    if (isSmall) {
      typesController = ScrollController(initialScrollOffset: enabledTypes.indexOf(_value.type) * 150.0);
    }

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
                left: offset.dx,
                right: screenSize.width - box.size.width - offset.dx,
                child: SizedBox(
                  width: width,
                  child: Column(
                    children: [
                      FadeTransition(
                        opacity: animation,
                        child: StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            double contentHeight =
                                height - 20 /* Global padding */ - 30 /* Confirm button */ - 40 /* Toolbar */;
                            return Container(
                              padding: const EdgeInsets.all(10),
                              height: height,
                              decoration: generateContainerElevation(context: context),
                              child: Column(
                                children: [
                                  SingleChildScrollView(
                                    controller: typesController,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: enabledTypes.map((type) {
                                        return ThemedButton(
                                          style: _value.type == type
                                              ? ThemedButtonStyle.filledTonal
                                              : ThemedButtonStyle.text,
                                          labelText: i18n?.t('helpers.dynamicAvatar.types.$type') ?? "Type: $type",
                                          onTap: _value.type == type
                                              ? null
                                              : () {
                                                  setState(() {
                                                    _value.type = type;
                                                  });
                                                  widget.onChanged?.call(_value);
                                                },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildContent(isSmall: isSmall, height: contentHeight, setState: setState),
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 10),
                                  ThemedButton(
                                    style: ThemedButtonStyle.filledTonal,
                                    labelText: i18n?.t('actions.save') ?? 'Confirm',
                                    onTap: () {
                                      _destroyOverlay(callback: () {
                                        widget.onChanged?.call(_value);
                                      });
                                    },
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

    Overlay.of(context, rootOverlay: true).insert(overlayEntry!);
    animation.forward();
  }

  void _destroyOverlay({VoidCallback? callback}) async {
    await animation.reverse();
    overlayEntry?.remove();
    overlayEntry = null;
    search = '';
    selectedGroup = null;
    setState(() {});
    callback?.call();
  }

  Widget _buildContent({required bool isSmall, required double height, dynamic setState}) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);

    Widget searchBar = ThemedTextInput(
      labelText: i18n?.t('helpers.search') ?? 'Search',
      value: search,
      prefixIcon: MdiIcons.magnify,
      dense: isSmall,
      onChanged: (value) {
        setState(() => search = value);
      },
    );

    Widget content;
    switch (_value.type) {
      case AvatarType.emoji:
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              i18n?.t('helpers.dynamicAvatar.types.EMOJI.hint') ?? "Select your emoji",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.justify,
            ),
            if (!isSmall) searchBar,
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                controller: _emojiController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [null, ...EmojiGroup.values].map((group) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: _EmojiGroupButton(
                          group: group,
                          onTap: () {
                            setState(() => selectedGroup = group);
                          },
                          isSelected: selectedGroup == group,
                          iconSize: 16,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return _EmojiGrid(
                    iconSize: 16,
                    selected: _value.emoji == null ? null : Emoji.byChar(_value.emoji!),
                    constraints: constraints,
                    onTap: (emoji) {
                      setState(() {
                        _value.type = AvatarType.emoji;
                        _value.base64 = null;
                        _value.icon = null;
                        _value.url = null;
                        _value.emoji = emoji.char;
                      });
                      widget.onChanged?.call(_value);
                    },
                    group: selectedGroup,
                    search: search,
                  );
                },
              ),
            ),
          ],
        );
        break;
      case AvatarType.icon:
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              i18n?.t('helpers.dynamicAvatar.types.ICON.hint') ?? "Select your icon",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.justify,
            ),
            searchBar,
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return _IconGrid(
                    iconSize: 16,
                    selected: _value.icon,
                    constraints: constraints,
                    onTap: (icon) {
                      setState(() {
                        _value.type = AvatarType.icon;
                        _value.base64 = null;
                        _value.emoji = null;
                        _value.url = null;
                        _value.icon = icon;
                      });
                      widget.onChanged?.call(_value);
                    },
                    search: search,
                  );
                },
              ),
            ),
          ],
        );
        break;
      case AvatarType.url:
        content = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              i18n?.t('helpers.dynamicAvatar.types.URL.hint') ?? "Insert your image URL",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.justify,
            ),
            ThemedTextInput(
              labelText: i18n?.t('helpers.dynamicAvatar.types.URL.url') ?? "URL",
              value: _value.url,
              onChanged: (value) {
                setState(() {
                  _value.type = AvatarType.url;
                  _value.icon = null;
                  _value.emoji = null;
                  _value.base64 = null;
                  _value.url = value;
                  widget.onChanged?.call(_value);
                });
              },
            ),
          ],
        );
        break;
      case AvatarType.base64:
        content = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              i18n?.t('helpers.dynamicAvatar.types.BASE64.hint') ?? "Insert your image BASE64",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.justify,
            ),
            ThemedFileInput(
              labelText: i18n?.t('helpers.dynamicAvatar.types.BASE64.file') ?? "File",
              acceptedTypes: FileType.image,
              value: _value.base64,
              onChanged: (value, _) {
                setState(() {
                  _value.type = AvatarType.base64;
                  _value.icon = null;
                  _value.emoji = null;
                  _value.url = null;
                  _value.base64 = value;
                });
                widget.onChanged?.call(_value);
              },
            ),
          ],
        );
        break;
      case AvatarType.none:
      default:
        content = Center(
          child: Text(
            i18n?.t('helpers.dynamicAvatar.types.NONE.hint') ?? "No avatar",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.justify,
          ),
        );
        break;
    }

    return Container(
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: content,
    );
  }
}
