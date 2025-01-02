// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overtime_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OvertimeType _$OvertimeTypeFromJson(Map<String, dynamic> json) => OvertimeType(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      rate: (json['rate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OvertimeTypeToJson(OvertimeType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rate': instance.rate,
    };
