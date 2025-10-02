// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_with_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskWithSummaryModel _$TaskWithSummaryModelFromJson(
        Map<String, dynamic> json) =>
    TaskWithSummaryModel(
      summaryByStatuses: (json['summaryByStatuses'] as List<dynamic>?)
          ?.map((e) => TaskSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskWithSummaryModelToJson(
        TaskWithSummaryModel instance) =>
    <String, dynamic>{
      'summaryByStatuses': instance.summaryByStatuses,
      'results': instance.results,
    };
