// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StaffModel _$StaffModelFromJson(Map<String, dynamic> json) => StaffModel(
      id: (json['id'] as num?)?.toInt(),
      positionNameEn: json['positionNameEn'] as String?,
      positionNameKh: json['positionNameKh'] as String?,
      sexNameKh: json['sexNameKh'] as String?,
      sexNameEn: json['sexNameEn'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      sexId: (json['sexId'] as num?)?.toInt(),
      positionId: (json['positionId'] as num?)?.toInt(),
      phone: json['phone'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$StaffModelToJson(StaffModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'positionNameEn': instance.positionNameEn,
      'positionNameKh': instance.positionNameKh,
      'sexNameKh': instance.sexNameKh,
      'sexNameEn': instance.sexNameEn,
      'code': instance.code,
      'name': instance.name,
      'sexId': instance.sexId,
      'positionId': instance.positionId,
      'phone': instance.phone,
      'address': instance.address,
    };
