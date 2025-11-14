part of '../helpers.dart';

/// [generateContainerElevation] is a helper generator for the [BoxDecoration] of the [Container] widget.
///
/// It generates the [BoxDecoration] with the given [elevation] and [radius].
///
/// The [elevation] is the number of shadows to be generated, by default it is 1.
/// The maximum value is 5.
/// The minimum value is 0.
/// The [radius] is the radius of the `BorderRadius.circular` of the `BoxDecoration`, by default it is 10.
/// The minimum value is 0.
/// The [color] is the color of the `BoxDecoration`, by default it is `Theme.of(context).cardColor`.
/// The [shadowColor] is the color of the `BoxShadow`, by default it is `Colors.black.withAlpha((255 * 0.1).toInt())`.
/// The [reverse] is the boolean to reverse shadow of the `BoxDecoration`, by default it is false.
BoxDecoration generateContainerElevation({
  required BuildContext context,
  double elevation = 1,
  double radius = 10,
  Color? color,
  Color? shadowColor,
  bool reverse = false,
  bool hideOnElevationZero = false,
}) {
  assert(elevation <= 5, 'The elevation must be less than or equal to 5');
  assert(elevation >= 0, 'The elevation must be greater than or equal to 0');
  assert(radius >= 0, 'The radius must be greater than or equal to 0');

  final theme = Theme.of(context);
  final isDark = theme.brightness == .dark;

  // Base background color
  final surfaceColor = color ?? theme.cardColor;

  // Compute opacities based on elevation (0..5)
  double t = (elevation.clamp(0, 5) / 5.0);
  // Light mode: sutil, 6%..12%
  final lightShadowOpacity = 0.06 + (0.12 - 0.06) * t;

  // Dark mode: combinamos key (black) + highlight (white)
  final darkKeyOpacity = 0.22 + (0.30 - 0.22) * (1 - t); // ~0.30 -> 0.22
  final darkAmbientOpacity = 0.08 + (0.14 - 0.08) * t; // ~0.08 -> 0.14
  final highlightOpacity = 0.04 + (0.08 - 0.04) * t; // ~0.04 -> 0.08

  // Shadow colors
  final black = (shadowColor ?? Colors.black).withValues(
    alpha: isDark ? darkAmbientOpacity : lightShadowOpacity,
  );

  // Optional outline for low elevation (helps in dark mode)
  final bool addOutline = (elevation == 0 && !hideOnElevationZero) || (isDark && elevation <= 1);

  // Build shadows
  final List<BoxShadow>? shadows = elevation > 0
      ? <BoxShadow>[
          // Main/downwards shadow (key+ambient)
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: darkKeyOpacity) : black,
            blurRadius: 3 * elevation.toDouble() + 2,
            spreadRadius: isDark ? 0.5 : 0,
            offset: Offset(0, (elevation - 1).toDouble() * (reverse ? -1 : 1)),
          ),
          if (isDark)
            // Subtle top highlight to simulate raised edge on dark surfaces
            BoxShadow(
              color: Colors.white.withValues(alpha: highlightOpacity),
              blurRadius: 2 * elevation.toDouble() + 1,
              spreadRadius: 0,
              offset: const Offset(0, -0.5),
            ),
        ]
      : null;

  return BoxDecoration(
    color: surfaceColor,
    borderRadius: .circular(radius),
    border: addOutline
        ? .all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : (shadowColor ?? Colors.black.withValues(alpha: 0.10)),
            width: 1,
          )
        : null,
    boxShadow: shadows,
  );
}
