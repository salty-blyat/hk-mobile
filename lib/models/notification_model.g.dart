// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: (json['id'] as num?)?.toInt(),
      requestId: (json['requestId'] as num?)?.toInt(),
      title: json['title'] as String?,
      message: json['message'] as String?,
      isView: json['isView'] as bool?,
      viewDate: json['viewDate'] == null
          ? null
          : DateTime.parse(json['viewDate'] as String),
      staffId: (json['staffId'] as num?)?.toInt(),
      isSentSuccessfully: json['isSentSuccessfully'] as bool?,
      staffName: json['staffName'] as String?,
      serviceItem: json['serviceItem'] as String?,
      serviceItemType: json['serviceItemType'] as String?,
      requestType: (json['requestType'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      roomNumber: json['roomNumber'] as String?,
      floorName: json['floorName'] as String?,
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requestId': instance.requestId,
      'title': instance.title,
      'message': instance.message,
      'isView': instance.isView,
      'viewDate': instance.viewDate?.toIso8601String(),
      'staffId': instance.staffId,
      'isSentSuccessfully': instance.isSentSuccessfully,
      'staffName': instance.staffName,
      'serviceItem': instance.serviceItem,
      'serviceItemType': instance.serviceItemType,
      'requestType': instance.requestType,
      'quantity': instance.quantity,
      'roomNumber': instance.roomNumber,
      'floorName': instance.floorName,
      'createdDate': instance.createdDate?.toIso8601String(),
    };
