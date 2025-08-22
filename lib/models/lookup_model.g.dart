// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LookupModel _$LookupModelFromJson(Map<String, dynamic> json) => LookupModel(
      id: (json['id'] as num?)?.toInt(),
      lookupTypeId: (json['lookupTypeId'] as num?)?.toInt(),
      name: json['name'] as String?,
      nameEn: json['nameEn'] as String?,
      ordering: (json['ordering'] as num?)?.toInt(),
      note: json['note'] as String?,
      valueId: (json['valueId'] as num?)?.toInt(),
      image: json['image'],
      color: json['color'] as String?,
      lookupTypeName: json['lookupTypeName'] as String?,
    );

Map<String, dynamic> _$LookupModelToJson(LookupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lookupTypeId': instance.lookupTypeId,
      'name': instance.name,
      'nameEn': instance.nameEn,
      'ordering': instance.ordering,
      'note': instance.note,
      'image': instance.image,
      'valueId': instance.valueId,
      'color': instance.color,
      'lookupTypeName': instance.lookupTypeName,
    };
