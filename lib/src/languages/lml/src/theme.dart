part of '../lml.dart';

Map<String, TextStyle> theme = {
  // Defined here
  'number': TextStyle(
    color: const Color(0xff2ecc71),
    fontFamily: ThemedCodeEditor.font.name,
  ),
  'root': TextStyle(
    backgroundColor: const Color(0xff1a1a1a),
    color: const Color(0xffecf0f1),
    fontFamily: ThemedCodeEditor.font.name,
  ),
  'string': TextStyle(
    color: const Color(0xfff1c40f),
    fontFamily: ThemedCodeEditor.font.name,
  ),
  'function': TextStyle(
    fontWeight: FontWeight.bold,
    color: const Color(0xff3498db),
    fontFamily: ThemedCodeEditor.font.name,
  ),
  'constant': TextStyle(
    color: const Color(0xffe67e22),
    fontFamily: ThemedCodeEditor.font.name,
  ),
};
