// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_cycle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceCycleModel _$AttendanceCycleModelFromJson(
        Map<String, dynamic> json) =>
    AttendanceCycleModel(
      name: json['name'] as String?,
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$AttendanceCycleModelToJson(
        AttendanceCycleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'name': instance.name,
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
    };
