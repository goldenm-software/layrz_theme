part of layrz_theme;

class ResponsiveRow extends StatelessWidget {
  static ResponsiveRow builder({
    /// [itemCount] The number of children to display.
    required int itemCount,

    /// [itemBuilder] The builder to use to create the children.
    required ResponsiveCol Function(int) itemBuilder,

    /// [mainAxisAlignment] The alignment of the children.
    WrapAlignment mainAxisAlignment = WrapAlignment.start,

    /// [crossAxisAlignment] The alignment of the children.
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
  }) {
    List<ResponsiveCol> childs = [];
    for (int i = 0; i < itemCount; i++) {
      childs.add(itemBuilder(i));
    }
    return ResponsiveRow(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: childs,
    );
  }

  /// Component to generate a grid system using 12 columns (as standard), uses the following constants as breakpoints:
  /// [kExtraSmallGrid] = Extra small size, width between 0 and [kSmallGrid].
  /// [kSmallGrid] = Tablet size, width between [kExtraSmallGrid] and [kMediumGrid].
  /// [kMediumGrid] = Desktop size, width between [kSmallGrid] and [kLargeGrid].
  /// [kLargeGrid] = Large desktop size, width between [kMediumGrid] and [kExtraLargeGrid].
  /// [kExtraLargeGrid] = Extra large desktop size, width greater than [kLargeGrid].
  /// This component is based over flutter widget [Wrap], and the [mainAxisAlignment] and [crossAxisAlignment] are the same as the [Wrap] ones.
  /// [children] The children to wrap. Only will receive a list of [ResponsiveCol], if you need a divider or something like that,
  /// you should use `const ResponsiveCol(child: Divider())`.
  final List<ResponsiveCol> children;

  /// [mainAxisAlignment] The alignment of the children in the main axis.
  final WrapAlignment mainAxisAlignment;

  /// [crossAxisAlignment] The alignment of the children in the cross axis.
  final WrapCrossAlignment crossAxisAlignment;

  const ResponsiveRow({
    Key? key,
    required this.children,
    this.mainAxisAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}
