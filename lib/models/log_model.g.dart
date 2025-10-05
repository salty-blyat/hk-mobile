// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogModel _$LogModelFromJson(Map<String, dynamic> json) => LogModel(
      requestId: (json['requestId'] as num?)?.toInt(),
      staffId: (json['staffId'] as num?)?.toInt(),
      staffName: json['staffName'] as String?,
      status: (json['status'] as num?)?.toInt(),
      statusNameKh: json['statusNameKh'] as String?,
      statusNameEn: json['statusNameEn'] as String?,
      statusImage: json['statusImage'] as String?,
      createdBy: json['createdBy'] as String?,
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$LogModelToJson(LogModel instance) => <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'requestId': instance.requestId,
      'staffId': instance.staffId,
      'staffName': instance.staffName,
      'status': instance.status,
      'statusNameKh': instance.statusNameKh,
      'statusNameEn': instance.statusNameEn,
      'statusImage': instance.statusImage,
      'createdBy': instance.createdBy,
      'createdDate': instance.createdDate?.toIso8601String(),
    };
