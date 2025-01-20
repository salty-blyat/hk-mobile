// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingModel _$SettingModelFromJson(Map<String, dynamic> json) => SettingModel(
      id: (json['id'] as num?)?.toInt(),
      key: json['key'] as String?,
      note: json['note'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$SettingModelToJson(SettingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'note': instance.note,
      'value': instance.value,
    };
