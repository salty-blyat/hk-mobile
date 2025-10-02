// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_op_multi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskOPMultiModel _$TaskOPMultiModelFromJson(Map<String, dynamic> json) =>
    TaskOPMultiModel(
      roomIds: (json['roomIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      staffId: (json['staffId'] as num?)?.toInt(),
      requestNo: json['requestNo'] as String?,
      requestTime: json['requestTime'] == null
          ? null
          : DateTime.parse(json['requestTime'] as String),
      requestType: (json['requestType'] as num?)?.toInt(),
      guestId: (json['guestId'] as num?)?.toInt(),
      roomId: (json['roomId'] as num?)?.toInt(),
      reservationId: (json['reservationId'] as num?)?.toInt(),
      serviceTypeId: (json['serviceTypeId'] as num?)?.toInt(),
      serviceItemId: (json['serviceItemId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      note: json['note'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskOPMultiModelToJson(TaskOPMultiModel instance) =>
    <String, dynamic>{
      'roomIds': instance.roomIds,
      'staffId': instance.staffId,
      'requestNo': instance.requestNo,
      'requestTime': instance.requestTime?.toIso8601String(),
      'requestType': instance.requestType,
      'guestId': instance.guestId,
      'roomId': instance.roomId,
      'reservationId': instance.reservationId,
      'serviceTypeId': instance.serviceTypeId,
      'serviceItemId': instance.serviceItemId,
      'quantity': instance.quantity,
      'status': instance.status,
      'note': instance.note,
      'attachments': instance.attachments,
    };
