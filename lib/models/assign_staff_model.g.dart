// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_staff_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignStaffModel _$AssignStaffModelFromJson(Map<String, dynamic> json) =>
    AssignStaffModel(
      requestId: (json['requestId'] as num?)?.toInt(),
      staffId: (json['staffId'] as num?)?.toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$AssignStaffModelToJson(AssignStaffModel instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'staffId': instance.staffId,
      'note': instance.note,
    };
