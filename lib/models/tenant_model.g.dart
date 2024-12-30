// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tenant _$TenantFromJson(Map<String, dynamic> json) => Tenant(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      note: json['note'] as String?,
      code: json['code'] as String?,
      url: json['url'] as String?,
      dbInfo: json['dbInfo'],
      logo: json['logo'] as String?,
      tenantData: json['tenantData'] as String?,
    );

Map<String, dynamic> _$TenantToJson(Tenant instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'note': instance.note,
      'code': instance.code,
      'url': instance.url,
      'dbInfo': instance.dbInfo,
      'logo': instance.logo,
      'tenantData': instance.tenantData,
    };
