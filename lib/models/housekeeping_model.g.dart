// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'housekeeping_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Housekeeping _$HousekeepingFromJson(Map<String, dynamic> json) => Housekeeping(
      roomNumber: json['roomNumber'] as String?,
      roomTypeName: json['roomTypeName'] as String?,
      blockName: json['blockName'] as String?,
      floorName: json['floorName'] as String?,
      statusNameKh: json['statusNameKh'] as String?,
      statusNameEn: json['statusNameEn'] as String?,
      houseKeepingStatusNameKh: json['houseKeepingStatusNameKh'] as String?,
      houseKeepingStatusNameEn: json['houseKeepingStatusNameEn'] as String?,
      note: json['note'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      hkStaffName: json['hkStaffName'] as String?,
      activityDate: json['activityDate'] as String?,
      status: (json['status'] as num?)?.toInt(),
      statusColor: json['statusColor'] as String?,
      statusImage: json['statusImage'] as String?,
      houseKeepingStatus: (json['houseKeepingStatus'] as num?)?.toInt(),
      houseKeepingStatusColor: json['houseKeepingStatusColor'] as String?,
      houseKeepingStatusImage: json['houseKeepingStatusImage'] as String?,
      roomId: (json['roomId'] as num?)?.toInt(),
      roomTypeId: (json['roomTypeId'] as num?)?.toInt(),
      blockId: (json['blockId'] as num?)?.toInt(),
      floorId: (json['floorId'] as num?)?.toInt(),
      staffId: (json['staffId'] as num?)?.toInt(),
      hkStaffId: (json['hkStaffId'] as num?)?.toInt(),
      blockStaffId: (json['blockStaffId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HousekeepingToJson(Housekeeping instance) =>
    <String, dynamic>{
      'roomNumber': instance.roomNumber,
      'roomTypeName': instance.roomTypeName,
      'blockName': instance.blockName,
      'floorName': instance.floorName,
      'statusNameKh': instance.statusNameKh,
      'statusNameEn': instance.statusNameEn,
      'houseKeepingStatusNameKh': instance.houseKeepingStatusNameKh,
      'houseKeepingStatusNameEn': instance.houseKeepingStatusNameEn,
      'note': instance.note,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'hkStaffName': instance.hkStaffName,
      'activityDate': instance.activityDate,
      'status': instance.status,
      'statusColor': instance.statusColor,
      'statusImage': instance.statusImage,
      'houseKeepingStatus': instance.houseKeepingStatus,
      'houseKeepingStatusColor': instance.houseKeepingStatusColor,
      'houseKeepingStatusImage': instance.houseKeepingStatusImage,
      'roomId': instance.roomId,
      'roomTypeId': instance.roomTypeId,
      'blockId': instance.blockId,
      'floorId': instance.floorId,
      'staffId': instance.staffId,
      'hkStaffId': instance.hkStaffId,
      'blockStaffId': instance.blockStaffId,
    };
