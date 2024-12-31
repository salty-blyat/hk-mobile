// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveType _$LeaveTypeFromJson(Map<String, dynamic> json) => LeaveType(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      code: json['code'] as String?,
      trackBalance: json['trackBalance'] as bool?,
      entitleType: (json['entitleType'] as num?)?.toInt(),
      isAllowHour: json['isAllowHour'] as bool?,
      note: json['note'] as String?,
      entitleTypeName: json['entitleTypeName'] as String?,
    );

Map<String, dynamic> _$LeaveTypeToJson(LeaveType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'trackBalance': instance.trackBalance,
      'entitleType': instance.entitleType,
      'isAllowHour': instance.isAllowHour,
      'note': instance.note,
      'entitleTypeName': instance.entitleTypeName,
    };
