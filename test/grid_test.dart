import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('Sizes.gridSize', () {
    test('each enum returns correct column count', () {
      expect(Sizes.col1.gridSize, 1);
      expect(Sizes.col2.gridSize, 2);
      expect(Sizes.col3.gridSize, 3);
      expect(Sizes.col4.gridSize, 4);
      expect(Sizes.col5.gridSize, 5);
      expect(Sizes.col6.gridSize, 6);
      expect(Sizes.col7.gridSize, 7);
      expect(Sizes.col8.gridSize, 8);
      expect(Sizes.col9.gridSize, 9);
      expect(Sizes.col10.gridSize, 10);
      expect(Sizes.col11.gridSize, 11);
      expect(Sizes.col12.gridSize, 12);
    });
  });

  group('Sizes.boxWidth', () {
    test('col12 returns full width', () {
      expect(Sizes.col12.boxWidth(1200), 1200.0);
    });

    test('col6 returns half width', () {
      expect(Sizes.col6.boxWidth(1200), 600.0);
    });

    test('col4 returns one-third width', () {
      expect(Sizes.col4.boxWidth(1200), 400.0);
    });

    test('col3 returns one-quarter width', () {
      expect(Sizes.col3.boxWidth(1200), 300.0);
    });

    test('col1 returns 1/12 of width', () {
      expect(Sizes.col1.boxWidth(1200), 100.0);
    });

    test('formula is (width / 12) * gridSize', () {
      const screenWidth = 960.0;
      for (final size in Sizes.values) {
        expect(size.boxWidth(screenWidth), (screenWidth / 12) * size.gridSize);
      }
    });
  });
}
