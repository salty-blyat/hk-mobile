// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_terminal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceTerminalModel _$AttendanceTerminalModelFromJson(
        Map<String, dynamic> json) =>
    AttendanceTerminalModel(
      json['name'] as String?,
      (json['terminalTypeId'] as num?)?.toInt(),
      (json['branchId'] as num?)?.toInt(),
      json['settingData'] as String?,
      json['customEnrollment'] as bool?,
      json['latitude'] as String?,
      json['longitude'] as String?,
      json['isCheckIn'] as bool?,
      json['isCheckOut'] as bool?,
      json['address'] as String?,
      json['username'] as String?,
      json['password'] as String?,
      json['fromDate'] == null
          ? null
          : DateTime.parse(json['fromDate'] as String),
      json['toDate'] == null ? null : DateTime.parse(json['toDate'] as String),
      json['terminalTypeName'] as String?,
      json['branchName'] as String?,
      json['key'] as String?,
      json['statusName'] as String?,
      json['statusNameKh'] as String?,
      (json['status'] as num?)?.toInt(),
      json['statusDate'] == null
          ? null
          : DateTime.parse(json['statusDate'] as String),
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$AttendanceTerminalModelToJson(
        AttendanceTerminalModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'name': instance.name,
      'terminalTypeId': instance.terminalTypeId,
      'branchId': instance.branchId,
      'settingData': instance.settingData,
      'customEnrollment': instance.customEnrollment,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isCheckIn': instance.isCheckIn,
      'isCheckOut': instance.isCheckOut,
      'address': instance.address,
      'username': instance.username,
      'password': instance.password,
      'fromDate': instance.fromDate?.toIso8601String(),
      'toDate': instance.toDate?.toIso8601String(),
      'terminalTypeName': instance.terminalTypeName,
      'branchName': instance.branchName,
      'key': instance.key,
      'statusName': instance.statusName,
      'statusNameKh': instance.statusNameKh,
      'status': instance.status,
      'statusDate': instance.statusDate?.toIso8601String(),
    };
