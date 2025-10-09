part of '../lml.dart';

List<String> functions = [
  'assetName',
  'assetPositionLatitude',
  'assetPositionLongitude',
  'assetPositionSpeed',
  'assetPositionSatellites',
  'assetPositionDirection',
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
  'locatorLink',
];

// Example
// Test phrase {{assetName}}

final lclFunctions = Mode(
  className: 'function',
  begin: '{{\\b(${functions.join('|')})}}',
);
