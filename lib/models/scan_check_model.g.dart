// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_check_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanCheckModel _$ScanCheckModelFromJson(Map<String, dynamic> json) =>
    ScanCheckModel(
      json['message'] as String?,
      json['staffCode'] as String?,
      json['staffName'] as String?,
      json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      (json['type'] as num?)?.toInt(),
      json['terminalName'] as String?,
    );

Map<String, dynamic> _$ScanCheckModelToJson(ScanCheckModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'staffCode': instance.staffCode,
      'staffName': instance.staffName,
      'dateTime': instance.dateTime?.toIso8601String(),
      'type': instance.type,
      'terminalName': instance.terminalName,
    };
