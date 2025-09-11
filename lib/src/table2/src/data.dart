part of '../table2.dart';

class _ThemedData<T> {
  final T item;
  final List<String> values;
  final List<List<InlineSpan>?> richTextValues;
  final bool isSelected;
  final List<ThemedActionButton> actions;

  const _ThemedData({
    required this.item,
    required this.values,
    required this.richTextValues,
    this.isSelected = false,
    required this.actions,
  });
}
