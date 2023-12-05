part of '../languages.dart';

final List<String> kLayrzMarkupLanguageVariables = [
  'assetName',
  'assetPositionLatitude',
  'assetPositionLongitude',
  'assetPositionSpeed',
  'assetPositionSatellites',
  'assetPositionDirection',
  'assetSensorName',
  'assetSensorValue',
  'triggerName',
  'triggerCode',
  'triggerPresencegeofenceTypeRaw',
  'triggerPresencegeofenceTypeTranslated',
  'operationName',
  'geofenceName',
  'geofenceDescription',
  'executedAt',
  'executedAtUnix',
  'caseTriggerName',
  'caseTriggerCode',
  'caseCreatedAt',
  'caseUpdatedAt',
  'caseCommentUserName',
  'caseCommentContent',
  'caseCommentAt',
];

final lmlLang = Mode(
  refs: {
    '~lmlLanguage': Mode(
      className: 'variable',
      begin: '\\{{(${kLayrzMarkupLanguageVariables.join('|')})\\b',
      end: '\\}}',
      // excludeEnd: true,
    ),
  },
  aliases: [
    "lml",
    "layrzMarkupLanguage",
  ],
  contains: [
    Mode(ref: '~lmlLanguage'),
    Mode(
      className: 'literal',
      begin: '\\<',
      end: '\\>',
      // excludeBegin: true,
      // excludeEnd: true,
    ),
  ],
);
