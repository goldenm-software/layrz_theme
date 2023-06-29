import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  test("orm", () {
    Map<String, dynamic> errors = {
      'main': [
        {'code': 'format'}
      ],
      'main.sub': [
        {'code': 'empty'}
      ],
      'main.sub2': [
        {'code': 'empty'}
      ],
      'min': [
        {'code': 'minLength', 'expected': 3, 'received': 0}
      ],
    };

    ThemedOrm.setErrors(errors: errors);
    expect(ThemedOrm.getErrors(key: 'main'), ['format']);
    expect(ThemedOrm.getErrors(key: 'main.sub'), ['empty']);
    expect(ThemedOrm.getErrors(key: 'min'), ['minLength:expected=3:received=0']);
    expect(ThemedOrm.hasErrors(key: 'main'), true);
    expect(ThemedOrm.hasErrors(key: 'main2'), false);
    expect(ThemedOrm.hasContainerErrors(key: 'main'), true);
  });
}
