part of '../grid.dart';

class ResponsiveRow extends StatelessWidget {
  static ResponsiveRow builder({
    /// [itemCount] The number of children to display.
    required int itemCount,

    /// [itemBuilder] The builder to use to create the children.
    required ResponsiveCol Function(int) itemBuilder,

    /// [mainAxisAlignment] The alignment of the children.
    WrapAlignment mainAxisAlignment = .start,

    /// [crossAxisAlignment] The alignment of the children.
    WrapCrossAlignment crossAxisAlignment = .start,

    /// [spacing] The spacing between the children.
    double spacing = 0,
  }) {
    List<ResponsiveCol> children = [];
    for (int i = 0; i < itemCount; i++) {
      children.add(itemBuilder(i));
    }
    return ResponsiveRow(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      spacing: spacing,
      children: children,
    );
  }

  /// Component to generate a grid system using 12 columns (as standard), uses the following constants as breakpoints:
  /// [kExtraSmallGrid] = Extra small size, width between 0 and [kSmallGrid].
  /// [kSmallGrid] = Tablet size, width between [kExtraSmallGrid] and [kMediumGrid].
  /// [kMediumGrid] = Desktop size, width between [kSmallGrid] and [kLargeGrid].
  /// [kLargeGrid] = Large desktop size, width between [kMediumGrid] and [kExtraLargeGrid].
  /// [kExtraLargeGrid] = Extra large desktop size, width greater than [kLargeGrid].
  /// This component is based over flutter widget [Wrap], and the [mainAxisAlignment] and [crossAxisAlignment]
  /// are the same as the [Wrap] ones.
  /// [children] The children to wrap. Only will receive a list of [ResponsiveCol], if you need a divider or something like that,
  /// you should use `const ResponsiveCol(child: Divider())`.
  final List<ResponsiveCol> children;

  /// [mainAxisAlignment] The alignment of the children in the main axis.
  final WrapAlignment mainAxisAlignment;

  /// [crossAxisAlignment] The alignment of the children in the cross axis.
  final WrapCrossAlignment crossAxisAlignment;

  /// [spacing] The spacing between the children. By default is 0.
  final double spacing;

  /// [ResponsiveRow] is a component to generate a grid system using 12 columns (as standard),
  /// uses the following constants as breakpoints:
  const ResponsiveRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = .start,
    this.crossAxisAlignment = .start,
    this.spacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) => _renderRows(constraints.maxWidth),
      ),
    );
  }

  /// Orchestrates row rendering. Returns a shrink widget for empty children,
  /// otherwise a [Column] of [Row]s interleaved with vertical gap [SizedBox]es.
  Widget _renderRows(double totalWidth) {
    if (children.isEmpty) return const SizedBox.shrink();

    final groups = _groupIntoRows(children, totalWidth);
    final widgets = <Widget>[];

    for (var i = 0; i < groups.length; i++) {
      if (i > 0) widgets.add(SizedBox(height: spacing));
      widgets.add(_buildRow(groups[i], totalWidth));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  /// Groups [cols] into logical rows where each row's sum of gridSizes is ≤ 12.
  /// A new row starts whenever adding the next child would push the sum above 12.
  List<List<ResponsiveCol>> _groupIntoRows(List<ResponsiveCol> cols, double totalWidth) {
    final rows = <List<ResponsiveCol>>[];
    var current = <ResponsiveCol>[];
    var sum = 0;

    for (final col in cols) {
      final g = col.gridSizeAt(totalWidth);
      if (sum + g > 12 && current.isNotEmpty) {
        rows.add(current);
        current = [];
        sum = 0;
      }
      current.add(col);
      sum += g;
    }

    if (current.isNotEmpty) rows.add(current);
    return rows;
  }

  /// Builds a single [Row] for a group of [ResponsiveCol] children.
  /// Each child is wrapped in a [SizedBox] sized by the per-row math:
  /// `available = totalWidth - spacing * (n - 1)`, `childWidth = available * gridSize / 12`.
  Widget _buildRow(List<ResponsiveCol> rowCols, double totalWidth) {
    final n = rowCols.length;
    final available = totalWidth - spacing * (n - 1);
    final rowChildren = <Widget>[];

    for (var i = 0; i < n; i++) {
      if (i > 0) rowChildren.add(SizedBox(width: spacing));
      final g = rowCols[i].gridSizeAt(totalWidth);
      rowChildren.add(SizedBox(width: available * g / 12, child: rowCols[i]));
    }

    return Row(
      mainAxisAlignment: _mapMain(mainAxisAlignment),
      crossAxisAlignment: _mapCross(crossAxisAlignment),
      children: rowChildren,
    );
  }

  /// Maps [WrapAlignment] to [MainAxisAlignment] exhaustively.
  MainAxisAlignment _mapMain(WrapAlignment a) => switch (a) {
        WrapAlignment.start => MainAxisAlignment.start,
        WrapAlignment.end => MainAxisAlignment.end,
        WrapAlignment.center => MainAxisAlignment.center,
        WrapAlignment.spaceBetween => MainAxisAlignment.spaceBetween,
        WrapAlignment.spaceAround => MainAxisAlignment.spaceAround,
        WrapAlignment.spaceEvenly => MainAxisAlignment.spaceEvenly,
      };

  /// Maps [WrapCrossAlignment] to [CrossAxisAlignment] exhaustively.
  CrossAxisAlignment _mapCross(WrapCrossAlignment a) => switch (a) {
        WrapCrossAlignment.start => CrossAxisAlignment.start,
        WrapCrossAlignment.center => CrossAxisAlignment.center,
        WrapCrossAlignment.end => CrossAxisAlignment.end,
      };
}
