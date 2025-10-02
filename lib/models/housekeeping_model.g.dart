// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'housekeeping_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Housekeeping _$HousekeepingFromJson(Map<String, dynamic> json) => Housekeeping(
      roomNumber: json['roomNumber'] as String?,
      description: json['description'] as String?,
      blockName: json['blockName'] as String?,
      roomTypeId: (json['roomTypeId'] as num?)?.toInt(),
      floorId: (json['floorId'] as num?)?.toInt(),
      tagIds: (json['tagIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      status: (json['status'] as num?)?.toInt(),
      houseKeepingStatus: (json['houseKeepingStatus'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      floorName: json['floorName'] as String?,
      roomTypeName: json['roomTypeName'] as String?,
      roomClassNameKh: json['roomClassNameKh'] as String?,
      roomClassNameEn: json['roomClassNameEn'] as String?,
      statusNameEn: json['statusNameEn'] as String?,
      statusNameKh: json['statusNameKh'] as String?,
      statusImage: json['statusImage'] as String?,
      houseKeepingStatusNameEn: json['houseKeepingStatusNameEn'] as String?,
      houseKeepingStatusNameKh: json['houseKeepingStatusNameKh'] as String?,
      houseKeepingStatusImage: json['houseKeepingStatusImage'] as String?,
      tagNames: (json['tagNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      total: (json['total'] as num?)?.toInt(),
      pending: (json['pending'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HousekeepingToJson(Housekeeping instance) =>
    <String, dynamic>{
      'roomNumber': instance.roomNumber,
      'blockName': instance.blockName,
      'description': instance.description,
      'roomTypeId': instance.roomTypeId,
      'floorId': instance.floorId,
      'tagIds': instance.tagIds,
      'status': instance.status,
      'houseKeepingStatus': instance.houseKeepingStatus,
      'id': instance.id,
      'floorName': instance.floorName,
      'roomTypeName': instance.roomTypeName,
      'roomClassNameKh': instance.roomClassNameKh,
      'roomClassNameEn': instance.roomClassNameEn,
      'statusNameEn': instance.statusNameEn,
      'statusNameKh': instance.statusNameKh,
      'statusImage': instance.statusImage,
      'houseKeepingStatusNameEn': instance.houseKeepingStatusNameEn,
      'houseKeepingStatusNameKh': instance.houseKeepingStatusNameKh,
      'houseKeepingStatusImage': instance.houseKeepingStatusImage,
      'tagNames': instance.tagNames,
      'total': instance.total,
      'pending': instance.pending,
    };
