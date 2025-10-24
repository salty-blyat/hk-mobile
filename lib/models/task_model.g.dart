// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      requestNo: json['requestNo'] as String?,
      requestTime: json['requestTime'] == null
          ? null
          : DateTime.parse(json['requestTime'] as String),
      requestType: (json['requestType'] as num?)?.toInt(),
      guestId: (json['guestId'] as num?)?.toInt(),
      roomId: (json['roomId'] as num?)?.toInt(),
      floorName: json['floorName'] as String?,
      reservationId: (json['reservationId'] as num?)?.toInt(),
      serviceTypeId: (json['serviceTypeId'] as num?)?.toInt(),
      serviceItemId: (json['serviceItemId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      statusNameKh: json['statusNameKh'] as String?,
      statusNameEn: json['statusNameEn'] as String?,
      statusImage: json['statusImage'] as String?,
      statusColor: json['statusColor'] as String?,
      guestName: json['guestName'] as String?,
      roomNo: json['roomNo'] as String?,
      roomTypeName: json['roomTypeName'] as String?,
      staffId: (json['staffId'] as num?)?.toInt(),
      staffName: json['staffName'] as String?,
      serviceItemName: json['serviceItemName'] as String?,
      serviceItemImage: json['serviceItemImage'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastModifiedDate: json['lastModifiedDate'] == null
          ? null
          : DateTime.parse(json['lastModifiedDate'] as String),
      lastModifiedBy: json['lastModifiedBy'] as String?,
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'requestNo': instance.requestNo,
      'requestTime': instance.requestTime?.toIso8601String(),
      'requestType': instance.requestType,
      'guestId': instance.guestId,
      'roomId': instance.roomId,
      'floorName': instance.floorName,
      'reservationId': instance.reservationId,
      'serviceTypeId': instance.serviceTypeId,
      'serviceItemId': instance.serviceItemId,
      'quantity': instance.quantity,
      'status': instance.status,
      'statusNameKh': instance.statusNameKh,
      'statusNameEn': instance.statusNameEn,
      'statusImage': instance.statusImage,
      'statusColor': instance.statusColor,
      'guestName': instance.guestName,
      'roomNo': instance.roomNo,
      'roomTypeName': instance.roomTypeName,
      'staffId': instance.staffId,
      'staffName': instance.staffName,
      'serviceItemName': instance.serviceItemName,
      'serviceItemImage': instance.serviceItemImage,
      'attachments': instance.attachments,
      'lastModifiedDate': instance.lastModifiedDate?.toIso8601String(),
      'lastModifiedBy': instance.lastModifiedBy,
    };
