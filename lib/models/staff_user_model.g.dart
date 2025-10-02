// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffUserModel _$StaffUserModelFromJson(Map<String, dynamic> json) =>
    StaffUserModel(
      staffId: (json['staffId'] as num?)?.toInt(),
      positionId: (json['positionId'] as num?)?.toInt(),
      staffCode: json['staffCode'] as String?,
      staffName: json['staffName'] as String?,
      staffPhone: json['staffPhone'] as String?,
      positionName: json['positionName'] as String?,
    );

Map<String, dynamic> _$StaffUserModelToJson(StaffUserModel instance) =>
    <String, dynamic>{
      'staffId': instance.staffId,
      'positionId': instance.positionId,
      'staffCode': instance.staffCode,
      'staffName': instance.staffName,
      'staffPhone': instance.staffPhone,
      'positionName': instance.positionName,
    };
