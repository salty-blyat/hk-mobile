// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimelineModel _$TimelineModelFromJson(Map<String, dynamic> json) =>
    TimelineModel(
      id: (json['id'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      statusNameKh: json['statusNameKh'] as String?,
      statusName: json['statusName'] as String?,
      note: json['note'] as String?,
      approverId: (json['approverId'] as num?)?.toInt(),
      approverName: json['approverName'] as String?,
      positionName: json['positionName'] as String?,
      departmentName: json['departmentName'] as String?,
      branchName: json['branchName'] as String?,
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$TimelineModelToJson(TimelineModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'statusNameKh': instance.statusNameKh,
      'statusName': instance.statusName,
      'note': instance.note,
      'approverId': instance.approverId,
      'approverName': instance.approverName,
      'positionName': instance.positionName,
      'departmentName': instance.departmentName,
      'branchName': instance.branchName,
      'createdDate': instance.createdDate?.toIso8601String(),
      'createdBy': instance.createdBy,
    };
