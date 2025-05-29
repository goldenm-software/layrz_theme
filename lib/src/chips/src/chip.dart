part of '../chips.dart';

class ThemedChip extends StatelessWidget {
  /// [content] is the content of the chip, only text.
  final String content;

  /// [style] defines the style of the text in the chip.
  ///
  /// By default, uses the [Theme.of(context).textTheme.bodyMedium] if not provided.
  final TextStyle? style;

  /// [color] is the color of the chip.
  final Color color;

  /// [padding] is the padding of the chip.
  /// By default, it is set to `EdgeInsets.symmetric(horizontal: 10, vertical: 5)`.
  final EdgeInsetsGeometry padding;

  /// [ThemedChip] is a widget that displays a content in the chip style.
  const ThemedChip({
    super.key,
    required this.content,
    this.style,
    this.color = Colors.blue,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).toInt()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        content,
        style: (style ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(color: color),
      ),
    );
  }
}
