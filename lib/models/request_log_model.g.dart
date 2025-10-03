// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestLogModel _$RequestLogModelFromJson(Map<String, dynamic> json) =>
    RequestLogModel(
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
      staffName: json['staffName'] as String?,
      positionName: json['positionName'] as String?,
      serviceItemName: json['serviceItemName'] as String?,
      statusNameKh: json['statusNameKh'] as String?,
      statusNameEn: json['statusNameEn'] as String?,
      statusImage: json['statusImage'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      staffId: (json['staffId'] as num?)?.toInt(),
      roomNumber: json['roomNumber'] as String?,
      serviceItemImage: json['serviceItemImage'] as String?,
      floorName: json['floorName'] as String?,
      requestLogs: (json['requestLogs'] as List<dynamic>?)
          ?.map((e) => Log.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$RequestLogModelToJson(RequestLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
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
      'staffId': instance.staffId,
      'staffName': instance.staffName,
      'positionName': instance.positionName,
      'serviceItemName': instance.serviceItemName,
      'statusNameKh': instance.statusNameKh,
      'statusNameEn': instance.statusNameEn,
      'statusImage': instance.statusImage,
      'attachments': instance.attachments,
      'roomNumber': instance.roomNumber,
      'serviceItemImage': instance.serviceItemImage,
      'floorName': instance.floorName,
      'requestLogs': instance.requestLogs,
    };
