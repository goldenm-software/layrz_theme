import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('ThemedTable2Controller', () {
    late ThemedTable2Controller controller;

    setUp(() {
      controller = ThemedTable2Controller();
    });

    tearDown(() {
      controller.dispose();
    });

    test('addListener adds listener to list', () {
      var called = false;
      controller.addListener((event) => called = true);

      controller.refresh();

      expect(called, true);
    });

    test('removeListener removes specific listener', () {
      var called1 = false;
      var called2 = false;

      void listener1(ThemedTable2Event event) => called1 = true;
      void listener2(ThemedTable2Event event) => called2 = true;

      controller.addListener(listener1);
      controller.addListener(listener2);
      controller.removeListener(listener1);

      controller.refresh();

      expect(called1, false);
      expect(called2, true);
    });

    test('clearListeners removes all listeners', () {
      var called1 = false;
      var called2 = false;

      controller.addListener((event) => called1 = true);
      controller.addListener((event) => called2 = true);
      controller.clearListeners();

      controller.refresh();

      expect(called1, false);
      expect(called2, false);
    });

    test('sort triggers ThemedTable2SortEvent with correct parameters', () {
      ThemedTable2Event? receivedEvent;
      controller.addListener((event) => receivedEvent = event);

      controller.sort(columnIndex: 3, ascending: false);

      expect(receivedEvent, isA<ThemedTable2SortEvent>());
      final sortEvent = receivedEvent as ThemedTable2SortEvent;
      expect(sortEvent.columnIndex, 3);
      expect(sortEvent.ascending, false);
    });

    test('sort with default parameters', () {
      ThemedTable2Event? receivedEvent;
      controller.addListener((event) => receivedEvent = event);

      controller.sort();

      expect(receivedEvent, isA<ThemedTable2SortEvent>());
      final sortEvent = receivedEvent as ThemedTable2SortEvent;
      expect(sortEvent.columnIndex, 0);
      expect(sortEvent.ascending, true);
    });

    test('refresh triggers ThemedTable2RefreshEvent', () {
      ThemedTable2Event? receivedEvent;
      controller.addListener((event) => receivedEvent = event);

      controller.refresh();

      expect(receivedEvent, isA<ThemedTable2RefreshEvent>());
    });

    test('multiple listeners all receive events', () {
      var count = 0;
      controller.addListener((event) => count++);
      controller.addListener((event) => count++);
      controller.addListener((event) => count++);

      controller.refresh();

      expect(count, 3);
    });

    test('dispose clears all listeners', () {
      var called = false;
      controller.addListener((event) => called = true);

      controller.dispose();
      controller.refresh();

      expect(called, false);
    });

    test('events fire in order listeners were added', () {
      final callOrder = <int>[];
      controller.addListener((event) => callOrder.add(1));
      controller.addListener((event) => callOrder.add(2));
      controller.addListener((event) => callOrder.add(3));

      controller.refresh();

      expect(callOrder, [1, 2, 3]);
    });
  });
}
