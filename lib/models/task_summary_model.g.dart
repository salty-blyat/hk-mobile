// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskSummaryModel _$TaskSummaryModelFromJson(Map<String, dynamic> json) =>
    TaskSummaryModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      value: (json['value'] as num?)?.toInt(),
    )..nameEn = json['nameEn'] as String?;

Map<String, dynamic> _$TaskSummaryModelToJson(TaskSummaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameEn': instance.nameEn,
      'value': instance.value,
    };
