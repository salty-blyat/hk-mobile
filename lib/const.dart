import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Const {
  static const String version = '1.9';
  static const String date = '16-01-2025';
  static const String staffId = "StaffId";
  static String numberFormat(double value) {
    return NumberFormat('###.##').format(value);
  }

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
      'image': 'assets/images/kh_FLAG.png',
      'code': 'km'
    },
    {
      'key': Locale('en'),
      'label': 'English',
      'image': 'assets/images/en_FLAG.png',
      'code': 'en'
    },
  ];
}
