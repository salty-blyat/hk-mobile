// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceType _$ServiceTypeFromJson(Map<String, dynamic> json) => ServiceType(
      valueId: (json['valueId'] as num?)?.toInt(),
      lookupTypeName: json['lookupTypeName'] as String?,
      canRemove: json['canRemove'] as bool?,
      lookupTypeId: (json['lookupTypeId'] as num?)?.toInt(),
      name: json['name'] as String?,
      nameEn: json['nameEn'] as String?,
      ordering: (json['ordering'] as num?)?.toInt(),
      image: json['image'] as String?,
      color: json['color'] as String?,
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$ServiceTypeToJson(ServiceType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'valueId': instance.valueId,
      'lookupTypeName': instance.lookupTypeName,
      'canRemove': instance.canRemove,
      'lookupTypeId': instance.lookupTypeId,
      'name': instance.name,
      'nameEn': instance.nameEn,
      'ordering': instance.ordering,
      'image': instance.image,
      'color': instance.color,
    };
