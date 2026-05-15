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

class ThemedTable2OnSortEvent<T> extends ThemedTable2Event<T> {
  final int columnIndex;
  final bool ascending;

  ThemedTable2OnSortEvent({
    required this.columnIndex,
    required this.ascending,
  });
}

class ThemedTable2SearchEvent<T> extends ThemedTable2Event<T> {
  final String search;

  ThemedTable2SearchEvent({
    required this.search,
  });
}

class ThemedTable2OnSearchEvent<T> extends ThemedTable2Event<T> {
  final String search;

  ThemedTable2OnSearchEvent({
    required this.search,
  });
}

class ThemedTable2RefreshEvent<T> extends ThemedTable2Event<T> {}
