import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';

class ThemedFile {
  /// [name] is the name of the file.
  final String name;

  /// [path] is the path of the file. Only will return a value on native platforms (Android, iOS, Windows, macOS, Linux)
  final String? path;

  /// [bytes] is the bytes of the file.
  final Uint8List bytes;

  /// [ThemedFile] is a wrapper around [Uint8List] that adds a name and path to the file.
  ThemedFile({
    required this.name,
    this.path,
    required this.bytes,
  });

  @override
  String toString() {
    return 'ThemedFile(name: $name, size: ${bytes.lengthInBytes})';
  }

  /// [mimeType] returns the mime type of the file.
  String? get mimeType => lookupMimeType(path ?? name);
}
