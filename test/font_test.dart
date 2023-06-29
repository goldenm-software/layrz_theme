import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Font test', () {
    debugPrint(GoogleFonts.getFont('Kaput').fontFamily);
  });
}
