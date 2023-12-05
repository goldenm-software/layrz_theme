part of '../languages.dart';

final List<Map<String, dynamic>> kLayrzComputeLanguageFormulas = [
  {
    'formula': 'GET_PARAM',
    'arguments': ['value', 'default']
  },
  {
    'formula': 'GET_SENSOR',
    'arguments': ['value', 'default']
  },
  {
    'formula': 'CONSTANT',
    'arguments': ['value']
  },
  {
    'formula': 'GET_CUSTOM_FIELD',
    'arguments': ['value']
  },
  {
    'formula': 'COMPARE',
    'arguments': ['value', 'value']
  },
  {
    'formula': 'OR_OPERATOR',
    'arguments': ['value_inf']
  },
  {
    'formula': 'AND_OPERATOR',
    'arguments': ['value_inf']
  },
  {
    'formula': 'SUM',
    'arguments': ['value_inf']
  },
  {
    'formula': 'SUBSTRACT',
    'arguments': ['value_inf']
  },
  {
    'formula': 'MULTIPLY',
    'arguments': ['value_inf']
  },
  {
    'formula': 'DIVIDE',
    'arguments': ['value_inf']
  },
  {
    'formula': 'TO_BOOL',
    'arguments': ['value']
  },
  {
    'formula': 'TO_STR',
    'arguments': ['value']
  },
  {
    'formula': 'TO_INT',
    'arguments': ['value']
  },
  {
    'formula': 'TO_FLOAT',
    'arguments': ['value']
  },
  {
    'formula': 'CEIL',
    'arguments': ['value']
  },
  {
    'formula': 'FLOOR',
    'arguments': ['value']
  },
  {
    'formula': 'ROUND',
    'arguments': ['value']
  },
  {
    'formula': 'SQRT',
    'arguments': ['value']
  },
  {
    'formula': 'CONCAT',
    'arguments': ['value_inf']
  },
  {'formula': 'NOW', 'arguments': []},
  {
    'formula': 'RANDOM',
    'arguments': ['minimum', 'maximum']
  },
  {
    'formula': 'RANDOM_INT',
    'arguments': ['minimum', 'maximum']
  },
  {
    'formula': 'GREATER_THAN_OR_EQUALS_TO',
    'arguments': ['value', 'minimum', 'maximum']
  },
  {
    'formula': 'GREATER_THAN',
    'arguments': ['value', 'minimum', 'maximum']
  },
  {
    'formula': 'LESS_THAN_OR_EQUALS_TO',
    'arguments': ['value', 'minimum', 'maximum']
  },
  {
    'formula': 'LESS_THAN',
    'arguments': ['value', 'minimum', 'maximum']
  },
  {
    'formula': 'DIFFERENT',
    'arguments': ['value', 'value']
  },
  {
    'formula': 'HEX_TO_STR',
    'arguments': ['value']
  },
  {
    'formula': 'STR_TO_HEX',
    'arguments': ['value']
  },
  {
    'formula': 'HEX_TO_INT',
    'arguments': ['value']
  },
  {
    'formula': 'INT_TO_HEX',
    'arguments': ['value']
  },
  {
    'formula': 'IS_PARAMETER_PRESENT',
    'arguments': ['key']
  },
  {
    'formula': 'IS_SENSOR_PRESENT',
    'arguments': ['key']
  },
  {
    'formula': 'INSIDE_RANGE',
    'arguments': ['value', 'minimum', 'maximum']
  },
  {
    'formula': 'OUTSIDE_RANGE',
    'arguments': ['value', 'minimum', 'maximum']
  },
  {'formula': 'GET_TIME_DIFFERENCE', 'arguments': []},
  {
    'formula': 'IF',
    'arguments': ['value', 'true', 'false']
  },
  {
    'formula': 'REGEX',
    'arguments': ['value', 'pattern']
  },
  {
    'formula': 'IS_NONE',
    'arguments': ['value']
  },
  {'formula': 'GET_DISTANCE_TRAVELED', 'arguments': []},
  {
    'formula': 'GET_PREVIOUS_SENSOR',
    'arguments': ['value', 'default']
  },
  {
    'formula': 'NOT',
    'arguments': ['value']
  },
  {
    'formula': 'CONTAINS',
    'arguments': ['substring', 'value']
  },
  {
    'formula': 'STARTS_WITH',
    'arguments': ['substring', 'value']
  },
  {
    'formula': 'ENDS_WITH',
    'arguments': ['substring', 'value']
  },
  {'formula': 'PRIMARY_DEVICE', 'arguments': []},
  {
    'formula': 'SUBSTRING',
    'arguments': ['substring', 'startsWith', 'endsWith']
  }
];

final lclFormulas = kLayrzComputeLanguageFormulas.map((formula) => formula['formula']).toList();

final lclLang = Mode(
  refs: {
    '~lclFunctions': Mode(
      className: 'keyword',
      begin: '\\b(${lclFormulas.join('|')})\\b',
      end: '\\(',
      excludeEnd: true,
      relevance: 10,
    ),
  },
  aliases: [
    "lcl",
    "layrzComputeLanguage",
  ],
  contains: [
    Mode(ref: '~lclFunctions'),
    Mode(
      relevance: 5,
      className: 'number',
      begin: '([0-9])+',
    ),
    Mode(
      relevance: 5,
      className: 'number',
      begin: '([True|None|False])',
    ),
    Mode(
      relevance: 5,
      className: 'string',
      begin: '"([a-zA-Z0-9])+',
      end: '"',
    ),
  ],
);
