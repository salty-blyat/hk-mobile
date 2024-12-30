// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenMobile _$RefreshTokenMobileFromJson(Map<String, dynamic> json) =>
    RefreshTokenMobile(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$RefreshTokenMobileToJson(RefreshTokenMobile instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'permissions': instance.permissions,
    };
