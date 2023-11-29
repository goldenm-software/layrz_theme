part of scaffolds;

bool kThemedTableCanTrue(BuildContext context, item) => true;

class ThemedTable<T> extends StatefulWidget {
  /// Represents the columns or headers of the table. This columns only will be displayed in desktop size.
  /// For mobile mode, refer to the [rowTitleBuilder], [rowSubtitleBuilder] and [rowAvatarBuilder] properties.
  /// You can display up to 99 columns, but I don't recommend it.
  final List<ThemedColumn<T>> columns;

  /// Is the list of items to display
  final List<T> items;

  /// [onShow] will be called when the user clicks on the show button.
  /// On mobile size, the row click also will call this function.
  /// The `show` button only will show ehen this function is not null.
  final Future<void> Function(BuildContext, T)? onShow;

  /// [onEdit] will be called when the user clicks on the edit button.
  /// The `edit` button only will show ehen this function is not null.
  final Future<void> Function(BuildContext, T)? onEdit;

  /// [onDelete] will be called when the user clicks on the delete button.
  /// The `delete` button only will show ehen this function is not null.
  final Future<void> Function(BuildContext, T)? onDelete;

  /// [onMultiDelete] will be called when the user selects multiple items and perform the option `multiDelete`.
  /// The `multiDelete` button only will show ehen this function is not null.
  ///
  final Future<bool> Function(BuildContext ctx, List<T> items)? onMultiDelete;

  /// Represents the callback when the user clicks on the add button.
  final VoidCallback? onAdd;

  /// Represents the additional buttons of the table. This buttons will be append before the [onAdd] button.
  final List<Widget> additionalButtons;

  /// Represents the additional actions generator for each row.
  /// This actions will be append before the [onShow] button inside the [ThemedActionsButtons] widget.
  final List<ThemedActionButton> Function(BuildContext, T)? additionalActions;

  /// Represents the default search value of the table.
  final String searchText;

  /// Represents the module name of the table. This is used to generate the titleText and the add button label.
  /// The format of each translation key should be:
  /// - for `titleText` => `module.title.list` and the value should be `My items ({count})`
  /// - for `addButtonLabel` => `module.title.new` and the value should be `Add new item`
  final String module;

  /// [title] represents the custom title of the table. If this property is null, the title will be generated
  /// using the [module] property.
  final Widget? title;

  /// Represents the builders of row avatar when the table is in mobile size.
  /// This will appear at the left of the row, before the title and subtitle.
  final ThemedTableAvatar Function(BuildContext, List<ThemedColumn<T>>, T) rowAvatarBuilder;

  /// Represents the builders of row title when the table is in mobile size.
  /// This will appear at the center of the row, after the avatar and above the subtitle.
  /// This widget returned will be inside in a [Expanded][Column] widget.
  final Widget Function(BuildContext, List<ThemedColumn<T>>, T) rowTitleBuilder;

  /// Represents the builders of row subtitle when the table is in mobile size.
  /// This will appear at the center of the row, after the title and below the avatar.
  /// This widget returned will be inside in a [Expanded][Column] widget.
  final Widget Function(BuildContext, List<ThemedColumn<T>>, T) rowSubtitleBuilder;

  /// Represents the builder of the id of the item.
  /// This will be used to sort the items by id, and will appear as the first column of the table.
  final String Function(BuildContext, T) idBuilder;

  /// Represents the multiple selection is enabled
  final bool multiSelectionEnabled;

  /// Represents the additional actions to display when the multiple selection is enabled
  final List<ThemedTableAction<T>> multiSelectionActions;

  /// Represents the minimum selected items before show the dialog
  final int minSelectionsBeforeDialog;

  /// Represents the breakpoint to switch to mobile size. By default is [kSmallGrid]
  final double mobileBreakpoint;

  /// Represents the indicator of the buttons
  /// Indicates (through buttons) that the table is loading
  final bool isLoading;

  /// Indicates (through buttons) that the table is in cooldown
  final bool isCooldown;

  /// This will be called when the [ThemedButton] completes the cooldown
  final VoidCallback? onCooldown;

  /// This will be called when the user clicks on the refresh button
  final VoidCallback? onRefresh;

  /// Represents the custom translations of the table.
  /// If you cannot use Layrz Translation Engine, you can add your custom translations here.
  /// If the Layrz Translation Engine is null, the table will use this property to generate the translations,
  /// but you may see this error: `Missing translation for key: translation.key : {itemCount} : {arguments}`
  /// `{itemCount}` is the number of items in the table. Only will appear when the translation has pluralization.
  /// `{arguments}` is the representation of a `Map<String, dynamic>` arguments object.
  final Map<String, dynamic> customTranslations;

  /// Represents the callback when the user selects multiple items.
  /// This callback will be called when the user selects or deselects an item.
  final void Function(BuildContext, List<T>)? onSelectedItemsChanged;

  /// Represents the automatic dialog display of the multiple selection.
  /// If this property is true, the dialog will be displayed when the user selects more
  /// than [minSelectionsBeforeDialog] items.
  final bool enableMultiSelectDialog;

  /// [canEdit] represents the callback to check if the item can be edited.
  /// If this function returns false, the edit button will be disabled.
  /// By default, this function returns true.
  final bool Function(BuildContext, T) canEdit;

  /// [canDelete] represents the callback to check if the item can be deleted.
  /// If this function returns false, the delete button will be disabled.
  /// By default, this function returns true.
  final bool Function(BuildContext, T) canDelete;

  /// [mobileRowHeight] represents the height of the row when the table is in mobile size.
  /// By default, this value is 72.0
  final double mobileRowHeight;

  /// [idLabel] represents the label of the id column.
  /// By default, this value is `ID`
  final String idLabel;

  /// [customTitleText] represents the custom title text of the table.
  /// If this property is null, the title will be generated using the [module] property.
  final String? customTitleText;

  /// [rowHeight] represents the height of the row when the table is in desktop size.
  /// By default, this value is 40.0
  final double rowHeight;

  /// [initialPage] represents the initial page of the table.
  /// By default, this value is 0
  final int initialPage;

  /// [onPageChanged] represents the callback when the user changes the page.
  /// By default, this value is null
  final void Function(int)? onPageChanged;

  /// [enablePaginator] represents the indicator of the paginator.
  /// Will only apply in desktop mode.
  /// By default, this value is true
  /// We strongly recommend to use the paginator to prevent issues displaying a lot of items with many columns.
  final bool enablePaginator;

  /// [itemsPerPage] represents the number of items per page.
  /// By default, this value is calculated using the [rowHeight] and the available height of the table
  final int? itemsPerPage;

  /// [paginatorLeading] represents the widget to display before the paginator.
  /// By default, this value is null
  final Widget? paginatorLeading;

  /// [paginatorTrailing] represents the widget to display after the paginator.
  /// By default, this value is null
  final Widget? paginatorTrailing;

  /// [onIdTap] represents the callback when the user taps on a cell.
  final CellTap? onIdTap;

  /// [shouldExpand] represents the callback to check if the table in desktop mode should use `Expanded` widget.
  /// By default, this value is true
  final bool shouldExpand;

  /// [idEnabled] refers to the id column. If this property is false, the id column will be hidden.
  /// By default, this value is true
  final bool idEnabled;

  /// [forceResync] represents the indicator to force the resync of the items.
  /// By default, this value is false
  /// Be careful, this operation can be expensive, because it will recalculate the sizes of the columns.
  final bool forceResync;

  /// A standard table with a list of items, designed to be used in the scaffold.
  /// Helps to display a list of items in desktop and mobile mode without a lot of code. (I hope so)
  /// Please read the documentation of each property to understand how to use it.
  const ThemedTable({
    super.key,
    required this.columns,
    required this.items,
    this.onShow,
    this.onEdit,
    this.onDelete,
    this.onMultiDelete,
    this.additionalActions,
    this.searchText = '',
    required this.module,
    this.title,
    this.onAdd,
    this.additionalButtons = const [],
    required this.rowAvatarBuilder,
    required this.rowTitleBuilder,
    required this.rowSubtitleBuilder,
    required this.idBuilder,
    this.multiSelectionEnabled = true,
    this.multiSelectionActions = const [],
    this.minSelectionsBeforeDialog = 2,
    this.mobileBreakpoint = kSmallGrid,
    this.isLoading = false,
    this.isCooldown = false,
    this.onCooldown,
    this.onRefresh,
    this.customTranslations = const {
      'layrz.table.paginator.start': 'First page',
      'layrz.table.paginator.previous': 'Previous page',
      'layrz.table.paginator.page': 'Page {page} of {total}',
      'layrz.table.paginator.next': 'Next page',
      'layrz.table.paginator.end': 'Last page',
      'helpers.buttons.show': 'Show item',
      'helpers.buttons.edit': 'Edit item',
      'helpers.buttons.delete': 'Delete item',
      'helpers.actions': 'Actions',
      'helpers.search': 'Search',
    },
    this.onSelectedItemsChanged,
    this.enableMultiSelectDialog = true,
    this.canEdit = kThemedTableCanTrue,
    this.canDelete = kThemedTableCanTrue,
    this.mobileRowHeight = 72.0,
    this.idLabel = 'ID',
    this.customTitleText,
    this.rowHeight = 40.0,
    this.initialPage = 0,
    this.onPageChanged,
    this.enablePaginator = true,
    this.itemsPerPage,
    this.paginatorLeading,
    this.paginatorTrailing,
    this.onIdTap,
    this.shouldExpand = true,
    this.idEnabled = true,
    this.forceResync = false,
  })  : assert(columns.length > 0),
        assert(columns.length < 99);

  @override
  State<ThemedTable<T>> createState() => _ThemedTableState<T>();
}

class _ThemedTableState<T> extends State<ThemedTable<T>> with TickerProviderStateMixin {
  /// [isDark] predicts if the device is in dark mode.
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  /// [primaryColor] predicts the primary color for buttons, icons, etc.
  ///
  /// This prediction is based on the following rules:
  /// - Mainly, the primary color comes from the theme `primaryColor` property.
  /// - If the device is in dark mode, we check if the color should be in white or black background.
  /// - If the color should be in a black background, the color.
  /// - Otherwise, the color will be white.
  /// - If the device is using a light theme, the color will be the same as the theme `primaryColor`.
  Color get primaryColor {
    Color color = Theme.of(context).primaryColor;

    if (isDark && !useBlack(color: color)) {
      return Colors.white;
    }
    return color;
  }

  String get module => widget.module;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    searchText = widget.searchText;
  }

  @override
  void didUpdateWidget(ThemedTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.searchText != widget.searchText) {
      searchText = widget.searchText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < widget.mobileBreakpoint;

        return Column(
          children: [
            Row(
              children: [
                // Title
                Expanded(
                  child: widget.title ??
                      Text(
                        widget.customTitleText ?? t('$module.title.list', {'count': widget.items.length}),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                ),
                // Search text
                ThemedSearchInput(
                  value: searchText,
                  labelText: t('helpers.search'),
                  onSearch: (value) => setState(() => searchText = value),
                ),

                // Actions
                ...widget.additionalButtons,
                if (widget.onAdd != null) ...[
                  const SizedBox(width: 5),
                  ThemedButton(
                    labelText: t('$module.title.new'),
                    icon: MdiIcons.plus,
                    style: isMobile ? ThemedButtonStyle.fab : ThemedButtonStyle.filledTonal,
                    color: primaryColor,
                    onTap: widget.onAdd,
                    isLoading: widget.isLoading,
                    isCooldown: widget.isCooldown,
                    onCooldownFinish: widget.onCooldown,
                  ),
                ],
                if (widget.onRefresh != null) ...[
                  const SizedBox(width: 5),
                  ThemedButton(
                    labelText: t('helpers.refersh'),
                    icon: MdiIcons.refresh,
                    style: ThemedButtonStyle.filledFab,
                    color: primaryColor,
                    onTap: widget.onRefresh,
                    isLoading: widget.isLoading,
                    isCooldown: widget.isCooldown,
                    onCooldownFinish: widget.onCooldown,
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  /// Translation helper
  String t(String key, [Map<String, dynamic> args = const {}]) {
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);

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
    LayrzAppLocalizations? i18n = LayrzAppLocalizations.of(context);

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
