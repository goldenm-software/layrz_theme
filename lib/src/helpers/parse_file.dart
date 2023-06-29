part of layrz_theme;

/// [parseFileToBase64] is a helper function to parse a file to base64.
/// Will return a Map with the keys:
/// - ['base64'] - the base64 string of the file.
/// - ['name'] - the name of the file.
/// - ['mimeType'] - the mime type of the file.
/// And, will receive a [file] argument that should be a [PlatformFile] instance.
Future<Map<String, String>?> parseFileToBase64(PlatformFile file) async {
  List<int> byteArray = file.bytes!.toList();
  String? mimeType = lookupMimeType(file.name);

  if (mimeType != null) {
    return {
      'name': file.name,
      'mimeType': mimeType,
      'base64': base64Encode(byteArray),
    };
  }

  return null;
}

/// [parseBase64ToFile] is a helper function to parse a base64 string to a file.
/// Will return a [List<int>] and will receive a [file] as [PlatformFile] instance
Future<List<int>> parseFileToByteArray(PlatformFile file) async {
  return file.bytes!.toList();
}
