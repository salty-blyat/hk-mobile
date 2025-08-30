// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceItem _$ServiceItemFromJson(Map<String, dynamic> json) => ServiceItem(
      trackQty: json['trackQty'] as bool?,
      departmentName: json['departmentName'] as String?,
      serviceTypeName: json['serviceTypeName'] as String?,
      name: json['name'] as String?,
      serviceTypeId: (json['serviceTypeId'] as num?)?.toInt(),
      departmentId: (json['departmentId'] as num?)?.toInt(),
      maxQty: (json['maxQty'] as num?)?.toInt(),
      image: json['image'] as String?,
      description: json['description'] as String?,
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$ServiceItemToJson(ServiceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'trackQty': instance.trackQty,
      'departmentName': instance.departmentName,
      'serviceTypeName': instance.serviceTypeName,
      'name': instance.name,
      'serviceTypeId': instance.serviceTypeId,
      'departmentId': instance.departmentId,
      'maxQty': instance.maxQty,
      'image': instance.image,
      'description': instance.description,
    };
