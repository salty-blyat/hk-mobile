// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Staff _$StaffFromJson(Map<String, dynamic> json) => Staff(
      id: (json['id'] as num?)?.toInt(),
      tittleId: (json['tittleId'] as num?)?.toInt(),
      scheduleId: (json['scheduleId'] as num?)?.toInt(),
      name: json['name'] as String?,
      latinName: json['latinName'] as String?,
      code: json['code'] as String?,
      sexName: json['sexName'] as String?,
      sexNameKh: json['sexNameKh'] as String?,
      phone: json['phone'] as String?,
      positionName: json['positionName'] as String?,
      departmentName: json['departmentName'] as String?,
      branchName: json['branchName'] as String?,
      tittleName: json['tittleName'] as String?,
      photo: json['photo'] as String?,
    );

Map<String, dynamic> _$StaffToJson(Staff instance) => <String, dynamic>{
      'id': instance.id,
      'tittleId': instance.tittleId,
      'scheduleId': instance.scheduleId,
      'name': instance.name,
      'latinName': instance.latinName,
      'code': instance.code,
      'sexName': instance.sexName,
      'sexNameKh': instance.sexNameKh,
      'phone': instance.phone,
      'positionName': instance.positionName,
      'departmentName': instance.departmentName,
      'branchName': instance.branchName,
      'tittleName': instance.tittleName,
      'photo': instance.photo,
    };
