// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientInfo _$ClientInfoFromJson(Map<String, dynamic> json) => ClientInfo(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      token: json['token'] as String?,
      branchId: json['branchId'] as String?,
      refreshToken: json['refreshToken'] as String?,
      changePasswordRequired: json['changePasswordRequired'] as bool?,
      isEnabled2FA: json['isEnabled2FA'] as bool?,
      verifyMethod2FA: (json['verifyMethod2FA'] as num?)?.toInt(),
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      profile: json['profile'] as String?,
      apps: (json['apps'] as List<dynamic>?)
          ?.map((e) => App.fromJson(e as Map<String, dynamic>))
          .toList(),
      mfaRequired: json['mfaRequired'] as bool?,
      mfaToken: json['mfaToken'] as String?,
    );

Map<String, dynamic> _$ClientInfoToJson(ClientInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'token': instance.token,
      'branchId': instance.branchId,
      'refreshToken': instance.refreshToken,
      'changePasswordRequired': instance.changePasswordRequired,
      'mfaRequired': instance.mfaRequired,
      'mfaToken': instance.mfaToken,
      'isEnabled2FA': instance.isEnabled2FA,
      'verifyMethod2FA': instance.verifyMethod2FA,
      'permissions': instance.permissions,
      'profile': instance.profile,
      'apps': instance.apps,
    };
