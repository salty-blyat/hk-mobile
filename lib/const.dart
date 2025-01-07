import 'package:flutter/material.dart';

class Const {
  static const String version = '1.8';
  static const String date = '03-01-2025';
  static const Map<String, String> authorized = {
    'Authorized': 'authorized',
    'Lang': 'lang',
    'TenantCode': 'tenantCode',
    'AppCode': 'appCode',
    'BaseApiUrl': 'baseApiUrl',
    'AuthApiUrl': 'authApiUrl',
    'Token': 'token',
    'RefreshToken': 'refreshToken',
    'AccessToken': 'accessToken',
  };
  static const List<Map<String, dynamic>> languages = [
    {
      'key': Locale('km'),
      'label': 'ភាសាខ្មែរ',
      'image': 'assets/images/kh_FLAG.png'
    },
    {
      'key': Locale('en'),
      'label': 'English',
      'image': 'assets/images/en_FLAG.png'
    },
  ];
}
