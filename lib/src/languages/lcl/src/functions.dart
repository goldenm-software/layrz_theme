part of '../lcl.dart';

List<String> functions = [
  'GET_PARAM',
  'GET_SENSOR',
  'CONSTANT',
  'GET_CUSTOM_FIELD',
  'COMPARE',
  'OR_OPERATOR',
  'AND_OPERATOR',
  'SUM',
  'SUBSTRACT',
  'MULTIPLY',
  'DIVIDE',
  'TO_BOOL',
  'TO_STR',
  'TO_INT',
  'TO_FLOAT',
  'CEIL',
  'FLOOR',
  'ROUND',
  'SQRT',
  'CONCAT',
  'NOW',
  'RANDOM',
  'RANDOM_INT',
  'GREATER_THAN_OR_EQUALS_TO',
  'GREATER_THAN',
  'LESS_THAN_OR_EQUALS_TO',
  'LESS_THAN',
  'DIFFERENT',
  'HEX_TO_STR',
  'STR_TO_HEX',
  'HEX_TO_INT',
  'INT_TO_HEX',
  'IS_PARAMETER_PRESENT',
  'IS_SENSOR_PRESENT',
  'INSIDE_RANGE',
  'OUTSIDE_RANGE',
  'GET_TIME_DIFFERENCE',
  'IF',
  'REGEX',
  'IS_NONE',
  'GET_DISTANCE_TRAVELED',
  'GET_PREVIOUS_SENSOR',
  'NOT',
  'CONTAINS',
  'STARTS_WITH',
  'ENDS_WITH',
  'PRIMARY_DEVICE',
  'SUBSTRING',
];

final lclFunctions = Mode(
  className: 'function',
  begin: functions.join('|'),
);
