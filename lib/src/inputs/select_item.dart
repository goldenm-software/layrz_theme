part of inputs;

class ThemedSelectItem<T> {
  final Widget? content;
  final String label;
  final T? value;
  final IconData? icon;
  final Widget? leading;
  final void Function()? onTap;
  final bool canDelete;

  const ThemedSelectItem({
    required this.label,
    required this.value,
    this.icon,
    this.leading,
    this.onTap,
    this.content,
    this.canDelete = false,
  });

  @override
  String toString() => "ThemedSelectItem($label, $value)";

  @override
  bool operator ==(Object other) => identical(this, other) || other is ThemedSelectItem && value == other.value;

  @override
  int get hashCode => label.hashCode ^ value.hashCode ^ icon.hashCode;
}
