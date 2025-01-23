// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExceptionTypeModel _$ExceptionTypeModelFromJson(Map<String, dynamic> json) =>
    ExceptionTypeModel(
      name: json['name'] as String?,
      code: json['code'] as String?,
      autoApprove: json['autoApprove'] as bool?,
      note: json['note'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExceptionTypeModelToJson(ExceptionTypeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'autoApprove': instance.autoApprove,
      'note': instance.note,
      'id': instance.id,
    };
