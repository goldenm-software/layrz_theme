part of '../table2.dart';

abstract class ThemedTable2Event<T> {}

class ThemedTable2SortEvent<T> extends ThemedTable2Event<T> {
  final int columnIndex;
  final bool ascending;

  ThemedTable2SortEvent({
    required this.columnIndex,
    required this.ascending,
  });
}

class ThemedTable2RefreshEvent<T> extends ThemedTable2Event<T> {}
