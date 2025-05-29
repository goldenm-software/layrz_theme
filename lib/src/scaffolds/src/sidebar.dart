part of '../scaffolds.dart';

class ThemedScaffoldView<T> extends StatefulWidget {
  /// Represents the module name of the table. This is used to generate the titleText.
  /// The format of each translation key should be:
  /// - for `titleText` => `module.title.list` and the value should be `My items ({count})`
  final String module;

  /// Represents the width of the sidebar.
  /// This property only works when the `constraints.maxWidth` is greater than [mobileBreakpoint].
  final double sidebarWidth;

  /// Represents the mobile breakpoint
  /// This property changes the sidebar behavior to a button and a [BottomSheet] in mobile size.
  final double mobileBreakpoint;

  /// Represents the content of the view. The 'content' of the view.
  final Widget child;

  /// Represents the items of the sidebar list.
  final List<T> items;

  /// Represents the current item
  final T? item;

  /// Represents the callback when an item is selected
  final void Function(T) onTap;

  /// Represents the builders of row avatar in the [ListView] of the sidebar.
  /// In mobile mode, this sidebar will be replaced as a bottom sheet.
  ///
  /// This avatar will be in the left of the row, before the title and subtitle.
  final ThemedTableAvatar Function(BuildContext, T) avatarBuilder;

  /// Represents the builder of row title in the [ListView] of the sidebar.
  /// In mobile mode, this sidebar will be replaced as a bottom sheet.
  ///
  /// This title will be in the center of the row, after the avatar and above the subtitle.
  final String Function(BuildContext, T) titleBuilder;

  /// Represents the builder of row subtitle in the [ListView] of the sidebar.
  /// In mobile mode, this sidebar will be replaced as a bottom sheet.
  ///
  /// This subtitle will be in the center of the row, after the avatar and below the title.
  final String Function(BuildContext, T) subtitleBuilder;

  /// Represents the builder of id
  final String Function(BuildContext, T) idBuilder;

  /// Represents the custom translations of the table.
  /// If you cannot use Layrz Translation Engine, you can add your custom translations here.
  /// If the Layrz Translation Engine is null, the table will use this property to generate the translations,
  /// but you may see this error: `Missing translation for key: translation.key : {itemCount} : {arguments}`
  /// `{itemCount}` is the number of items in the table. Only will appear when the translation has pluralization.
  /// `{arguments}` is the representation of a `Map<String, dynamic>` arguments object.
  final Map<String, dynamic> customTranslations;

  /// [prefixSidebarIcon] is the prefix of the sidebar icon. Should return an [IconData]
  final IconData? Function(BuildContext, T)? prefixIconBuilder;

  /// [ThemedScaffoldView] is a widget to easly configure the scaffold details view.
  /// Helps with the sidebar and their button in mobile size (Refer to [mobileBreakpoint] for more details).
  const ThemedScaffoldView({
    super.key,
    required this.module,
    this.sidebarWidth = 300,
    this.mobileBreakpoint = kSmallGrid,
    required this.child,
    required this.items,
    this.item,
    required this.onTap,
    required this.avatarBuilder,
    required this.titleBuilder,
    required this.subtitleBuilder,
    required this.idBuilder,
    this.customTranslations = const {},
    this.prefixIconBuilder,
  });

  @override
  State<ThemedScaffoldView<T>> createState() => _ThemedScaffoldViewState<T>();
}

class _ThemedScaffoldViewState<T> extends State<ThemedScaffoldView<T>> {
  double get sidebarButtonSize => 30;
  String search = '';
  List<T> get items => widget.items.where((item) {
    if (search.isEmpty) return true;

    bool c1 = widget.titleBuilder(context, item).toLowerCase().contains(search.toLowerCase());
    bool c2 = widget.subtitleBuilder(context, item).toLowerCase().contains(search.toLowerCase());
    return c1 || c2;
  }).toList();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < widget.mobileBreakpoint;

        if (isMobile) {
          return Column(
            children: [
              Expanded(child: widget.child),
              _drawBottomSheetButton(
                isUp: true,
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) => _drawContent(isMobile: true),
                ),
              ),
            ],
          );
        }

        return Row(
          // alignment: WrapAlignment.center,
          children: [
            Expanded(child: widget.child),
            const SizedBox(width: 10),
            SizedBox(
              width: widget.sidebarWidth,
              height: constraints.maxHeight,
              child: _drawContent(),
            ),
          ],
        );
      },
    );
  }

  Widget _drawBottomSheetButton({bool isUp = true, required VoidCallback onTap}) {
    BorderRadius border = BorderRadius.circular(10);

    return Container(
      height: sidebarButtonSize,
      width: sidebarButtonSize,
      decoration: generateContainerElevation(context: context, elevation: 2).copyWith(borderRadius: border),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: border,
          onTap: onTap,
          child: Center(
            child: Icon(
              isUp ? LayrzIcons.solarOutlineAltArrowUp : LayrzIcons.solarOutlineAltArrowDown,
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawContent({bool isMobile = false}) {
    return Container(
      padding: const EdgeInsets.all(10).subtract(EdgeInsets.only(top: isMobile ? 0 : 10)),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: isMobile
            ? null
            : Border(
                left: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
        borderRadius: isMobile ? BorderRadius.circular(10) : BorderRadius.zero,
        boxShadow: isMobile
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t('${widget.module}.title.list', {'count': widget.items.length}),
            style: context.subtitleStyle,
          ),
          const SizedBox(height: 5),
          ThemedSearchInput(
            labelText: t('${widget.module}.search'),
            value: search,
            onSearch: (value) => setState(() => search = value),
            asField: true,
            maxWidth: double.infinity,
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemExtent: 43,
              itemBuilder: (context, index) {
                T item = items[index];
                ThemedTableAvatar avatar = widget.avatarBuilder(context, item);
                String currentId = widget.idBuilder(context, item);
                String? selectedId = widget.item != null ? widget.idBuilder(context, widget.item as T) : null;
                bool isSelected = currentId == selectedId;

                IconData? prefixIcon = widget.prefixIconBuilder?.call(context, item);

                return Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).inputDecorationTheme.fillColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isSelected
                          ? null
                          : () {
                              if (isMobile) {
                                Navigator.of(context).pop();
                              }
                              widget.onTap(item);
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            ThemedAvatar(
                              name: avatar.label,
                              avatar: avatar.avatar,
                              icon: avatar.icon,
                              color: avatar.color,
                              dynamicAvatar: avatar.dynamicAvatar,
                              size: 27,
                              iconSize: 18,
                              elevation: 0,
                              radius: 5,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (isSelected) ...[
                                        Icon(LayrzIcons.solarOutlineStart1, size: 14, color: Colors.grey),
                                        const SizedBox(width: 5),
                                      ] else if (prefixIcon != null) ...[
                                        Icon(
                                          prefixIcon,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 5),
                                      ],
                                      Expanded(
                                        child: Text(
                                          widget.titleBuilder(context, item),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    widget.subtitleBuilder(context, item),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
  }

  /// Translation helper
  String t(String key, [Map<String, dynamic> args = const {}]) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.maybeOf(context);

    if (i18n != null) {
      return i18n.t(key, args);
    }

    if (widget.customTranslations.containsKey(key)) {
      String result = widget.customTranslations[key]!;
      args.forEach((key, value) => result = result.replaceAll('{$key}', value.toString()));
      return result;
    }

    return 'Missing translation for key $key : $args';
  }

  /// Translation helper for singular / plural detection
  /// Note: To a correct use of this method, your translation should be
  /// in the following format: `singular | plural`
  /// Is important to have the ` | ` character with the spaces before and after to work correctly
  String tc(String key, int count, {Map<String, dynamic> args = const {}}) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.maybeOf(context);

    if (i18n != null) {
      return i18n.tc(key, count, args);
    }

    if (widget.customTranslations.containsKey(key)) {
      String result = widget.customTranslations[key]!;
      args.forEach((key, value) => result = result.replaceAll('{$key}', value.toString()));

      List<String> parts = result.split(' | ');
      if (parts.length == 2) {
        return count == 1 ? parts[0] : parts[1];
      }

      return result;
    }

    return 'Missing translation for key $key : $count : $args';
  }
}
