// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LookupModel _$LookupModelFromJson(Map<String, dynamic> json) => LookupModel(
      id: (json['id'] as num?)?.toInt(),
      lookupTypeId: (json['lookupTypeId'] as num?)?.toInt(),
      name: json['name'] as String?,
      nameKh: json['nameKh'] as String?,
      ordering: (json['ordering'] as num?)?.toInt(),
      note: json['note'] as String?,
      image: json['image'],
      lookupTypeName: json['lookupTypeName'] as String?,
    );

Map<String, dynamic> _$LookupModelToJson(LookupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lookupTypeId': instance.lookupTypeId,
      'name': instance.name,
      'nameKh': instance.nameKh,
      'ordering': instance.ordering,
      'note': instance.note,
      'image': instance.image,
      'lookupTypeName': instance.lookupTypeName,
    };
