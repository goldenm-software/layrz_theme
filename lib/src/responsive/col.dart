part of layrz_theme;

class ResponsiveCol extends StatelessWidget {
  /// Component to wrap a child between an especific breakpoints. Read the
  /// documentation of each field for more information.
  /// [xs] Default and mobile size, using [kExtraSmallGrid] as the default size.
  final Sizes xs;

  /// [sm] Tablet size, width between [kExtraSmallGrid] and [kSmallGrid].
  final Sizes? sm;

  /// [md] Large tablet or low-res desktop size, width between [kSmallGrid] and [kMediumGrid].
  final Sizes? md;

  /// [lg] Desktop size, width between [kMediumGrid] and [kLargeGrid].
  final Sizes? lg;

  /// [xl] Extra high-res (Like 1080p or 4K) desktop size, width greater than [kLargeGrid].
  final Sizes? xl;

  /// [child] The child to wrap.
  final Widget child;

  /// [ResponsiveCol] is a component to wrap a child between an especific breakpoints.
  /// Read the documentation of each field for more information.
  const ResponsiveCol({
    super.key,
    this.xs = Sizes.col12,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: _currentSize(width: constraints.maxWidth).boxWidth(constraints.maxWidth),
          child: child,
        );
      },
    );
  }

  Sizes _currentSize({required double width}) {
    if (width < kExtraSmallGrid) {
      return xs;
    } else if (width >= kExtraSmallGrid && width < kSmallGrid) {
      return sm ?? xs;
    } else if (width >= kSmallGrid && width < kMediumGrid) {
      return md ?? sm ?? xs;
    } else if (width >= kMediumGrid && width < kLargeGrid) {
      return lg ?? md ?? sm ?? xs;
    } else {
      return xl ?? lg ?? md ?? sm ?? xs;
    }
  }
}
