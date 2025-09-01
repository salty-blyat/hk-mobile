// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Staff _$StaffFromJson(Map<String, dynamic> json) => Staff(
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

Map<String, dynamic> _$StaffToJson(Staff instance) => <String, dynamic>{
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
