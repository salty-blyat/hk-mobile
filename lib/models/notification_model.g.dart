// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      requestId: (json['requestId'] as num?)?.toInt(),
      staffId: (json['staffId'] as num?)?.toInt(),
      title: json['title'] as String?,
      message: json['message'] as String?,
      isView: json['isView'] as bool?,
      viewDate: json['viewDate'] == null
          ? null
          : DateTime.parse(json['viewDate'] as String),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'requestId': instance.requestId,
      'staffId': instance.staffId,
      'title': instance.title,
      'message': instance.message,
      'isView': instance.isView,
      'viewDate': instance.viewDate?.toIso8601String(),
      'createdDate': instance.createdDate?.toIso8601String(),
    };
