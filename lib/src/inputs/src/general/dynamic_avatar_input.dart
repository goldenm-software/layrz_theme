part of '../../inputs.dart';

typedef ThemedDynamicAvatarOnChanged = void Function(AvatarInput? value);

class ThemedDynamicAvatarInput extends StatefulWidget {
  final String? labelText;
  final Widget? label;
  final AvatarInput? value;
  final ThemedDynamicAvatarOnChanged? onChanged;
  final bool disabled;
  final List<String> errors;
  final bool hideDetails;
  final EdgeInsets? padding;
  final List<AvatarType> enabledTypes;
  final double heightFactor;
  final double maxHeight;

  /// [ThemedDynamicAvatarInput] is a dynamic avatar input.
  /// Layrz supports 5 types of avatars:
  /// - [AvatarType.none] is a no avatar. It is the default value.
  /// - [AvatarType.url] is an avatar from an URL.
  /// - [AvatarType.base64] is an avatar from a base64 string.
  /// - [AvatarType.icon] is an avatar from an icon.
  /// - [AvatarType.emoji] is an avatar from an emoji.
  /// To handle this in any form, this is the Widget to use, helps in the process to select the avatar.
  const ThemedDynamicAvatarInput({
    super.key,

    /// [labelText] is the label text of the field. Avoid submit [label] and [labelText] at the same time.
    this.labelText,

    /// [label] is the label widget of the field. Avoid submit [label] and [labelText] at the same time.
    this.label,

    /// [value] is the value of the field.
    this.value,

    /// [onChanged] is the callback function when the field is changed.
    this.onChanged,

    /// [disabled] is the disabled state of the field.
    this.disabled = false,

    /// [errors] is the list of errors of the field.
    this.errors = const [],

    /// [hideDetails] is the state of hiding the details of the field.
    this.hideDetails = false,

    /// [padding] is the padding of the field.
    this.padding,

    /// [enabledTypes] is the list of enabled types of the field.
    this.enabledTypes = const [
      AvatarType.url,
      AvatarType.base64,
      AvatarType.icon,
      AvatarType.emoji,
    ],

    /// [heightFactor] is the height factor of the field.
    this.heightFactor = 0.7,

    /// [maxHeight] is the max height of the field.
    this.maxHeight = 350,
  }) : assert((label == null && labelText != null) || (label != null && labelText == null));

  @override
  State<ThemedDynamicAvatarInput> createState() => _ThemedDynamicAvatarInputState();
}

class _ThemedDynamicAvatarInputState extends State<ThemedDynamicAvatarInput> with TickerProviderStateMixin {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  bool get isDark => Theme.of(context).brightness == Brightness.dark;
  Color get containerColor => isDark ? Colors.grey.shade800 : Colors.grey.shade200;
  Color get iconColor => isDark ? Colors.grey.shade300 : Colors.grey.shade600;

  late AvatarInput _value;
  EdgeInsets get padding => widget.padding ?? ThemedTextInput.outerPadding;
  bool get disabled => widget.disabled;

  List<AvatarType> get enabledTypes => [
        AvatarType.none,
        ...widget.enabledTypes,
      ];

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? AvatarInput();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: disabled ? null : _showDialog,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  ThemedAvatar(
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
                      onPressed: disabled ? null : _showDialog,
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

  Future<void> _showDialog() async {
    await showDialog(
      context: context,
      builder: (context) => _ThemedDynamicAvatarDialog(
        types: enabledTypes,
        value: _value,
        onChanged: (output) {
          _value = output ?? AvatarInput();
          widget.onChanged?.call(output);
          setState(() {});
        },
      ),
    );
  }
}

class _ThemedDynamicAvatarDialog extends StatefulWidget {
  final ThemedDynamicAvatarOnChanged onChanged;
  final AvatarInput value;
  final List<AvatarType> types;

  const _ThemedDynamicAvatarDialog({
    // ignore: unused_element
    super.key,
    required this.onChanged,
    required this.value,
    required this.types,
  });

  @override
  State<_ThemedDynamicAvatarDialog> createState() => _ThemedDynamicAvatarDialogState();
}

class _ThemedDynamicAvatarDialogState extends State<_ThemedDynamicAvatarDialog> {
  LayrzAppLocalizations? get i18n => LayrzAppLocalizations.maybeOf(context);
  AvatarInput get _value => widget.value;

  final ScrollController _emojiController = ScrollController();
  EmojiGroup? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
        padding: const EdgeInsets.all(10),
        decoration: generateContainerElevation(context: context, elevation: 5, radius: 10),
        child: DefaultTabController(
          length: widget.types.length,
          initialIndex: widget.types.indexOf(_value.type),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  tabBarTheme: const TabBarTheme(tabAlignment: TabAlignment.start),
                ),
                child: TabBar(
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                  onTap: (index) {
                    final type = widget.types[index];
                    widget.onChanged.call(_value.copyWith(type: type));
                  },
                  tabs: [
                    ...widget.types.map((type) {
                      return ThemedTab(
                        labelText: i18n?.t('helpers.dynamicAvatar.types.$type') ?? type.readableName,
                        leading: Icon(type.icon, size: 16),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return TabBarView(
                      children: [
                        ...widget.types.map((type) {
                          return _buildContent(
                            type: type,
                            setState: setState,
                            constraints: constraints,
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent({
    required BoxConstraints constraints,
    dynamic setState,
    required AvatarType type,
  }) {
    Widget content;
    switch (type) {
      case AvatarType.emoji:
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                            setState(() => _selectedGroup = group);
                          },
                          isSelected: _selectedGroup == group,
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
                        _value.base64 = null;
                        _value.icon = null;
                        _value.url = null;
                        _value.emoji = emoji.char;
                        _value.type = AvatarType.emoji;
                      });
                      widget.onChanged.call(_value);
                    },
                    group: _selectedGroup,
                  );
                },
              ),
            ),
          ],
        );
        break;
      case AvatarType.icon:
        content = _IconGrid(
          selected: _value.icon,
          constraints: constraints,
          onTap: (icon) {
            setState(() {
              _value.base64 = null;
              _value.emoji = null;
              _value.url = null;
              _value.icon = icon;
              _value.type = AvatarType.icon;
            });
            widget.onChanged.call(_value);
          },
        );
        break;
      case AvatarType.url:
        content = SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThemedTextInput(
                labelText: i18n?.t('helpers.dynamicAvatar.types.URL.url') ?? "URL",
                value: _value.url,
                prefixIcon: MdiIcons.link,
                onChanged: (value) {
                  setState(() {
                    _value.icon = null;
                    _value.emoji = null;
                    _value.base64 = null;
                    _value.url = value;
                    _value.type = AvatarType.url;
                    widget.onChanged.call(_value);
                  });
                },
              ),
            ],
          ),
        );
        break;
      case AvatarType.base64:
        content = SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ThemedAvatarPicker(
                labelText: i18n?.t('helpers.dynamicAvatar.types.BASE64') ?? type.readableName,
                value: _value.base64,
                onChanged: (base64) {
                  setState(() {
                    _value.icon = null;
                    _value.emoji = null;
                    _value.url = null;
                    _value.base64 = base64;
                    _value.type = AvatarType.base64;
                  });
                  widget.onChanged.call(_value);
                },
              ),
            ],
          ),
        );
        break;
      case AvatarType.none:
      default:
        content = Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              i18n?.t('helpers.dynamicAvatar.types.NONE.hint') ??
                  "This type does not support any content, to change that, select other option in the tab bar.",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              maxLines: 8,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: content,
    );
  }
}

extension on AvatarType {
  IconData? get icon {
    switch (this) {
      case AvatarType.none:
        return MdiIcons.imageOff;
      case AvatarType.url:
        return MdiIcons.link;
      case AvatarType.base64:
        return MdiIcons.imageFilterHdr;
      case AvatarType.icon:
        return MdiIcons.emoticon;
      case AvatarType.emoji:
        return MdiIcons.emoticon;
      default:
        return null;
    }
  }

  String get readableName {
    switch (this) {
      case AvatarType.none:
        return "Without avatar";
      case AvatarType.url:
        return "Direct URL";
      case AvatarType.base64:
        return "Upload your image";
      case AvatarType.icon:
        return "Layrz Icon";
      case AvatarType.emoji:
        return "Emoji";
      default:
        return "";
    }
  }
}
