part of helpers;

/// [generateContainerElevation] is a helper generator for the [BoxDecoration] of the [Container] widget.
/// It generates the [BoxDecoration] with the given [elevation] and [radius].
BoxDecoration generateContainerElevation({
  required BuildContext context,

  /// The [elevation] is the number of shadows to be generated, by default it is 1.
  /// The maximum value is 5.
  /// The minimum value is 0.
  int elevation = 1,

  /// The [radius] is the radius of the [BorderRadius.circular] of the [BoxDecoration], by default it is 10.
  /// The minimum value is 0.
  double radius = 10,

  /// The [color] is the color of the [BoxDecoration], by default it is [Theme.of(context).cardColor].
  Color? color,

  /// The [shadowColor] is the color of the [BoxShadow], by default it is [Theme.of(context).dividerColor].
  Color? shadowColor,

  /// The [reverse] is the boolean to reverse the [BoxDecoration], by default it is false.
  bool reverse = false,
}) {
  assert(elevation <= 5, 'The elevation must be less than or equal to 5');
  assert(elevation >= 0, 'The elevation must be greater than or equal to 0');
  assert(radius >= 0, 'The radius must be greater than or equal to 0');

  return BoxDecoration(
    color: color ?? Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(radius),
    border: elevation == 0
        ? Border.all(
            color: shadowColor ?? Theme.of(context).dividerColor,
            width: 1,
          )
        : null,
    boxShadow: elevation > 0
        ? [
            BoxShadow(
              color: shadowColor ?? Theme.of(context).dividerColor,
              blurRadius: 2 * elevation.toDouble(),
              offset: Offset(0, elevation.toDouble() * (reverse ? -1 : 1)), // changes position of shadow
            ),
          ]
        : null,
  );
}
