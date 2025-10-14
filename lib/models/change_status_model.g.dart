// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeStatusModel _$ChangeStatusModelFromJson(Map<String, dynamic> json) =>
    ChangeStatusModel(
      id: (json['id'] as num?)?.toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$ChangeStatusModelToJson(ChangeStatusModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
    };
