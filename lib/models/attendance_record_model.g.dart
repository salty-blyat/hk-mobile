// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRecordModel _$AttendanceRecordModelFromJson(
        Map<String, dynamic> json) =>
    AttendanceRecordModel(
      (json['id'] as num?)?.toInt(),
      json['fileName'] as String?,
      json['staffNameLatin'] as String?,
      json['terminalName'] as String?,
      json['staffName'] as String?,
      json['staffCode'] as String?,
      (json['scanType'] as num?)?.toInt(),
      json['checkInOutTypeNameKh'] as String?,
      json['checkInOutTypeName'] as String?,
      (json['uploadId'] as num?)?.toInt(),
      (json['terminalId'] as num?)?.toInt(),
      json['enrollmentNo'] as String?,
      json['time'] == null ? null : DateTime.parse(json['time'] as String),
      (json['staffId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AttendanceRecordModelToJson(
        AttendanceRecordModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'staffNameLatin': instance.staffNameLatin,
      'terminalName': instance.terminalName,
      'staffName': instance.staffName,
      'staffCode': instance.staffCode,
      'scanType': instance.scanType,
      'checkInOutTypeNameKh': instance.checkInOutTypeNameKh,
      'checkInOutTypeName': instance.checkInOutTypeName,
      'uploadId': instance.uploadId,
      'terminalId': instance.terminalId,
      'enrollmentNo': instance.enrollmentNo,
      'time': instance.time?.toIso8601String(),
      'staffId': instance.staffId,
    };
