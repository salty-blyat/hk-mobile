// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_mark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationMarkModel _$NotificationMarkModelFromJson(
        Map<String, dynamic> json) =>
    NotificationMarkModel(
      requestId: (json['requestId'] as num?)?.toInt(),
      title: json['title'] as String?,
      message: json['message'] as String?,
      isView: json['isView'] as bool?,
      viewDate: json['viewDate'] == null
          ? null
          : DateTime.parse(json['viewDate'] as String),
      staffId: (json['staffId'] as num?)?.toInt(),
      isSentSuccessfully: json['isSentSuccessfully'] as bool?,
    );

Map<String, dynamic> _$NotificationMarkModelToJson(
        NotificationMarkModel instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'title': instance.title,
      'message': instance.message,
      'isView': instance.isView,
      'viewDate': instance.viewDate?.toIso8601String(),
      'staffId': instance.staffId,
      'isSentSuccessfully': instance.isSentSuccessfully,
    };
