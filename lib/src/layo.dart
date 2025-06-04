import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:layrz_theme/layrz_theme.dart';
import 'package:simple_shadow/simple_shadow.dart';

class Layo extends StatelessWidget {
  /// [size] is thez size of the layo.
  final double size;

  /// [emotion] is the emotion of the layo.
  final LayoEmotions emotion;

  /// [elevation] is the elevation of the layo.
  final double elevation;

  /// The [shadowColor] is the color of the [BoxShadow], by default it is [Theme.of(context).dividerColor].
  final Color? shadowColor;

  /// The [reverse] is the boolean to reverse shadow of the [BoxDecoration], by default it is false.
  final bool reverse;

  /// The [radius] is the radius of the [BorderRadius.circular] of the [BoxDecoration], by default it
  /// is the `size`. The minimum value is 0.
  final double radius;

  /// [Layo] is a widget that shows a Layo.
  const Layo({
    super.key,
    required this.size,
    this.emotion = LayoEmotions.standard,
    double? radius,
    this.elevation = 1,
    this.shadowColor,
    this.reverse = false,
  }) : radius = radius ?? size,
       assert(elevation <= 5, 'The elevation must be less than or equal to 5'),
       assert(elevation >= 0, 'The elevation must be greater than or equal to 0');

  /// [layoAspectRatio] is the aspect ratio of the image (This ratio is based on the original export).
  double get layoAspectRatio => 500 / 833;

  /// [layoWidth] is the width of the image.
  double get layoWidth => size * 2.2;

  /// [layoHeight] is the height of the image.
  double get layoHeight => layoWidth * layoAspectRatio;

  /// [layoPadding] is the padding of the image.
  EdgeInsets get layoPadding => const EdgeInsets.all(10);

  double get innerSize => size - (size * 0.1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: generateContainerElevation(
        context: context,
        color: emotion.borderColor,
        shadowColor: shadowColor,
        elevation: elevation,
        reverse: reverse,
        radius: radius,
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Container(
          width: innerSize,
          height: innerSize,
          decoration: BoxDecoration(
            color: emotion.backgroundColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: innerSize * 0.1,
                right: innerSize * 0.1,
                child: Center(
                  child: SimpleShadow(
                    opacity: 0.8,
                    color: Colors.black,
                    offset: const Offset(0, 0),
                    sigma: 4,
                    child: SvgPicture.asset(
                      'packages/layrz_theme/${emotion.svg}',
                      height: layoHeight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum LayoEmotions {
  angry,
  dead,
  happy,
  idea,
  standard,
  love,
  question,
  sleep,
  warning,
  bolivariano,
  mrLayo,
  layo404;

  String get svg {
    switch (this) {
      case LayoEmotions.angry:
        return 'assets/layo/angry.svg';
      case LayoEmotions.dead:
        return 'assets/layo/dead.svg';
      case LayoEmotions.happy:
        return 'assets/layo/happy.svg';
      case LayoEmotions.idea:
        return 'assets/layo/idea.svg';
      case LayoEmotions.love:
        return 'assets/layo/love.svg';
      case LayoEmotions.question:
        return 'assets/layo/question.svg';
      case LayoEmotions.sleep:
        return 'assets/layo/sleep.svg';
      case LayoEmotions.warning:
        return 'assets/layo/warning.svg';
      case LayoEmotions.bolivariano:
        return 'assets/layo/layo-bolivariano.svg';
      case LayoEmotions.layo404:
        return 'assets/layo/404.svg';
      case LayoEmotions.mrLayo:
      case LayoEmotions.standard:
        // default:
        return 'assets/layo/mr-layo.svg';
    }
  }

  Color get borderColor {
    switch (this) {
      case LayoEmotions.angry:
      case LayoEmotions.bolivariano:
        return Colors.red.shade900;

      case LayoEmotions.idea:
        return Colors.orange.shade900;

      case LayoEmotions.love:
        return Colors.pink.shade900;

      case LayoEmotions.warning:
        return Colors.orange.shade900;

      case LayoEmotions.sleep:
      case LayoEmotions.dead:
      case LayoEmotions.layo404:
        return Colors.grey.shade800;

      case LayoEmotions.question:
      case LayoEmotions.happy:
      case LayoEmotions.mrLayo:
      case LayoEmotions.standard:
        // default:
        return const Color.fromARGB(255, 0, 15, 45);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case LayoEmotions.angry:
      case LayoEmotions.bolivariano:
        return Colors.red.shade700;

      case LayoEmotions.idea:
        return Colors.orange.shade700;

      case LayoEmotions.love:
        return Colors.pink.shade700;

      case LayoEmotions.warning:
        return Colors.orange.shade600;

      case LayoEmotions.sleep:
      case LayoEmotions.dead:
      case LayoEmotions.layo404:
        return Colors.grey.shade600;

      case LayoEmotions.question:
      case LayoEmotions.happy:
      case LayoEmotions.mrLayo:
      case LayoEmotions.standard:
        // default:
        return kPrimaryColor;
    }
  }
}
