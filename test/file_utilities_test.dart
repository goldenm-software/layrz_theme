import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:layrz_theme/layrz_theme.dart';

void main() {
  group('ThemedFile', () {
    test('creates file with name and bytes', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4]);
      final file = ThemedFile(name: 'test.txt', bytes: bytes);

      expect(file.name, 'test.txt');
      expect(file.bytes, bytes);
      expect(file.path, isNull);
    });

    test('creates file with optional path', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final file = ThemedFile(
        name: 'test.txt',
        path: '/path/to/test.txt',
        bytes: bytes,
      );

      expect(file.name, 'test.txt');
      expect(file.path, '/path/to/test.txt');
      expect(file.bytes, bytes);
    });

    test('toString() includes name and size', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final file = ThemedFile(name: 'document.pdf', bytes: bytes);

      final str = file.toString();
      expect(str, contains('document.pdf'));
      expect(str, contains('5'));
    });
  });

  group('ThemedFile.mimeType', () {
    test('detects PNG image', () {
      final file = ThemedFile(
        name: 'image.png',
        bytes: Uint8List(0),
      );

      expect(file.mimeType, 'image/png');
    });

    test('detects JPG image', () {
      final file = ThemedFile(
        name: 'photo.jpg',
        bytes: Uint8List(0),
      );

      expect(file.mimeType, 'image/jpeg');
    });

    test('detects JPEG image', () {
      final file = ThemedFile(
        name: 'photo.jpeg',
        bytes: Uint8List(0),
      );

      expect(file.mimeType, 'image/jpeg');
    });

    test('detects GIF image', () {
      final file = ThemedFile(
        name: 'animation.gif',
        bytes: Uint8List(0),
      );

      expect(file.mimeType, 'image/gif');
    });

    test('detects SVG image', () {
      final file = ThemedFile(
        name: 'icon.svg',
        bytes: Uint8List(0),
      );

      expect(file.mimeType, 'image/svg+xml');
    });

    test('detects PDF document', () {
      final file = ThemedFile(
        name: 'document.pdf',
        bytes: Uint8List(0),
      );

      expect(file.mimeType, 'application/pdf');
    });

    test('detects custom .lc extension', () {
      final file = ThemedFile(
        name: 'config.lc',
        bytes: Uint8List(0),
      );

      expect(file.mimeType, 'text/layrz-cycle');
    });

    test('uses path over name when both provided', () {
      final file = ThemedFile(
        name: 'wrongname.txt',
        path: '/path/to/file.png',
        bytes: Uint8List(0),
      );

      expect(file.mimeType, 'image/png');
    });

    test('handles unknown extension', () {
      final file = ThemedFile(
        name: 'file.unknown123',
        bytes: Uint8List(0),
      );

      // mime package returns null for unknown extensions
      expect(file.mimeType, isNull);
    });

    test('case insensitive extension detection', () {
      final file1 = ThemedFile(name: 'IMAGE.PNG', bytes: Uint8List(0));
      final file2 = ThemedFile(name: 'image.png', bytes: Uint8List(0));

      expect(file1.mimeType, file2.mimeType);
    });
  });

  group('parseFileToBase64()', () {
    test('converts bytes to base64', () async {
      final bytes = Uint8List.fromList([72, 101, 108, 108, 111]); // "Hello"
      final file = ThemedFile(name: 'test.txt', bytes: bytes);

      final result = await parseFileToBase64(file);

      expect(result, isNotNull);
      expect(result!['base64'], base64Encode([72, 101, 108, 108, 111]));
    });

    test('includes file name in result', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final file = ThemedFile(name: 'document.pdf', bytes: bytes);

      final result = await parseFileToBase64(file);

      expect(result, isNotNull);
      expect(result!['name'], 'document.pdf');
    });

    test('includes mime type in result', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final file = ThemedFile(name: 'image.png', bytes: bytes);

      final result = await parseFileToBase64(file);

      expect(result, isNotNull);
      expect(result!['mimeType'], 'image/png');
    });

    test('returns null when mime type cannot be determined', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final file = ThemedFile(name: 'file.unknownext', bytes: bytes);

      final result = await parseFileToBase64(file);

      expect(result, isNull);
    });

    test('handles empty file', () async {
      final bytes = Uint8List(0);
      final file = ThemedFile(name: 'empty.txt', bytes: bytes);

      final result = await parseFileToBase64(file);

      expect(result, isNotNull);
      expect(result!['base64'], '');
    });

    test('round-trip base64 encoding/decoding', () async {
      final originalBytes = Uint8List.fromList([1, 2, 3, 4, 5, 255, 128, 0]);
      final file = ThemedFile(name: 'test.bin', bytes: originalBytes);

      final result = await parseFileToBase64(file);

      expect(result, isNotNull);
      final decoded = base64Decode(result!['base64']!);
      expect(decoded, equals(originalBytes));
    });
  });

  group('parseFileToByteArray()', () {
    test('returns file bytes as List<int>', () async {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final file = ThemedFile(name: 'test.bin', bytes: bytes);

      final result = await parseFileToByteArray(file);

      expect(result, isA<List<int>>());
      expect(result, [1, 2, 3, 4, 5]);
    });

    test('handles empty file', () async {
      final bytes = Uint8List(0);
      final file = ThemedFile(name: 'empty.bin', bytes: bytes);

      final result = await parseFileToByteArray(file);

      expect(result, isEmpty);
    });

    test('preserves byte values', () async {
      final bytes = Uint8List.fromList([0, 127, 128, 255]);
      final file = ThemedFile(name: 'test.bin', bytes: bytes);

      final result = await parseFileToByteArray(file);

      expect(result[0], 0);
      expect(result[1], 127);
      expect(result[2], 128);
      expect(result[3], 255);
    });

    test('returns a copy (new list)', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final file = ThemedFile(name: 'test.bin', bytes: bytes);

      final result = await parseFileToByteArray(file);

      // Modifying result shouldn't affect original
      result[0] = 99;
      expect(file.bytes[0], 1);
    });
  });

  group('globalMimeResolver', () {
    test('includes custom .lc extension', () {
      final mimeType = globalMimeResolver.lookup('file.lc');

      expect(mimeType, 'text/layrz-cycle');
    });

    test('still supports standard extensions', () {
      expect(globalMimeResolver.lookup('file.png'), 'image/png');
      expect(globalMimeResolver.lookup('file.jpg'), 'image/jpeg');
      expect(globalMimeResolver.lookup('file.pdf'), 'application/pdf');
    });
  });
}
