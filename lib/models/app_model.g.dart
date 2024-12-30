// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

App _$AppFromJson(Map<String, dynamic> json) => App(
      id: (json['id'] as num?)?.toInt(),
      code: json['code'] as String?,
      name: json['name'] as String?,
      appId: (json['appId'] as num?)?.toInt(),
      appName: json['appName'] as String?,
      language: json['language'],
      url: json['url'] as String?,
      dbInfo: json['dbInfo'],
      iconUrl: json['iconUrl'] as String?,
    )..appCode = json['appCode'] as String?;

Map<String, dynamic> _$AppToJson(App instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'appId': instance.appId,
      'appName': instance.appName,
      'appCode': instance.appCode,
      'language': instance.language,
      'url': instance.url,
      'dbInfo': instance.dbInfo,
      'iconUrl': instance.iconUrl,
    };
