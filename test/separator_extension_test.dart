import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('num.w (width)', () {
    test('creates SizedBox with width', () {
      final box = 10.w;

      expect(box, isA<SizedBox>());
      expect(box.width, 10.0);
      expect(box.height, isNull);
    });

    test('handles integer values', () {
      final box = 100.w;

      expect(box.width, 100.0);
    });

    test('handles double values', () {
      final box = 15.5.w;

      expect(box.width, 15.5);
    });

    test('handles zero', () {
      final box = 0.w;

      expect(box.width, 0.0);
    });

    test('width alias is equivalent to w', () {
      final box1 = 20.w;
      final box2 = 20.width;

      expect(box1.width, box2.width);
      expect(box1.height, box2.height);
    });
  });

  group('num.h (height)', () {
    test('creates SizedBox with height', () {
      final box = 20.h;

      expect(box, isA<SizedBox>());
      expect(box.height, 20.0);
      expect(box.width, isNull);
    });

    test('handles integer values', () {
      final box = 200.h;

      expect(box.height, 200.0);
    });

    test('handles double values', () {
      final box = 25.5.h;

      expect(box.height, 25.5);
    });

    test('handles zero', () {
      final box = 0.h;

      expect(box.height, 0.0);
    });

    test('height alias is equivalent to h', () {
      final box1 = 30.h;
      final box2 = 30.height;

      expect(box1.width, box2.width);
      expect(box1.height, box2.height);
    });
  });

  group('num.wh (square)', () {
    test('creates SizedBox with equal width and height', () {
      final box = 15.wh;

      expect(box, isA<SizedBox>());
      expect(box.width, 15.0);
      expect(box.height, 15.0);
    });

    test('handles integer values', () {
      final box = 50.wh;

      expect(box.width, 50.0);
      expect(box.height, 50.0);
    });

    test('handles double values', () {
      final box = 12.5.wh;

      expect(box.width, 12.5);
      expect(box.height, 12.5);
    });

    test('handles zero', () {
      final box = 0.wh;

      expect(box.width, 0.0);
      expect(box.height, 0.0);
    });

    test('square alias is equivalent to wh', () {
      final box1 = 40.wh;
      final box2 = 40.square;

      expect(box1.width, box2.width);
      expect(box1.height, box2.height);
    });
  });

  group('Different num types', () {
    test('works with int', () {
      const intValue = 10;
      final box = intValue.w;

      expect(box.width, 10.0);
    });

    test('works with double', () {
      const doubleValue = 10.5;
      final box = doubleValue.w;

      expect(box.width, 10.5);
    });

    test('works with num variable', () {
      num numValue = 15;
      final box = numValue.w;

      expect(box.width, 15.0);
    });
  });

  group('Edge cases', () {
    test('handles very small values', () {
      final box = 0.1.wh;

      expect(box.width, 0.1);
      expect(box.height, 0.1);
    });

    test('handles very large values', () {
      final box = 9999.99.wh;

      expect(box.width, 9999.99);
      expect(box.height, 9999.99);
    });

    test('handles negative values (though unusual in UI)', () {
      final box = (-10).w;

      expect(box.width, -10.0);
    });
  });

  group('Common usage patterns', () {
    test('can be used for spacing between widgets', () {
      final spacer = 16.h;

      expect(spacer, isA<SizedBox>());
      expect(spacer.height, 16.0);
    });

    test('can create responsive spacing', () {
      final screenWidth = 360.0;
      final spacing = (screenWidth * 0.05).w;

      expect(spacing.width, 18.0);
    });

    test('can create square placeholders', () {
      final placeholder = 100.wh;

      expect(placeholder.width, placeholder.height);
      expect(placeholder.width, 100.0);
    });
  });
}
