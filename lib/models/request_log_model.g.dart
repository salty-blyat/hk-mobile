// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestLog _$RequestLogFromJson(Map<String, dynamic> json) => RequestLog(
      serviceItemName: json['serviceItemName'] as String?,
      statusNameKh: json['statusNameKh'] as String?,
      statusNameEn: json['statusNameEn'] as String?,
      statusImage: json['statusImage'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      requestNo: json['requestNo'] as String?,
      requestTime: json['requestTime'] as String?,
      guestId: (json['guestId'] as num?)?.toInt(),
      roomId: (json['roomId'] as num?)?.toInt(),
      reservationId: (json['reservationId'] as num?)?.toInt(),
      serviceTypeId: (json['serviceTypeId'] as num?)?.toInt(),
      serviceItemId: (json['serviceItemId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      requestLogs: (json['requestLogs'] as List<dynamic>?)
          ?.map((e) => Log.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$RequestLogToJson(RequestLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'serviceItemName': instance.serviceItemName,
      'statusNameKh': instance.statusNameKh,
      'statusNameEn': instance.statusNameEn,
      'statusImage': instance.statusImage,
      'attachments': instance.attachments,
      'requestNo': instance.requestNo,
      'requestTime': instance.requestTime,
      'guestId': instance.guestId,
      'roomId': instance.roomId,
      'reservationId': instance.reservationId,
      'serviceTypeId': instance.serviceTypeId,
      'serviceItemId': instance.serviceItemId,
      'quantity': instance.quantity,
      'status': instance.status,
      'requestLogs': instance.requestLogs,
    };
