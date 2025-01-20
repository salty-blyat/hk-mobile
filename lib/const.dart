import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Const {
  static const String version = '1.9';
  static const String date = '20-01-2025';
  static const String staffId = "StaffId";
  static String numberFormat(double value) {
    return NumberFormat('###.##').format(value);
  }

  static String percentageFormat(double value) {
    return NumberFormat('###').format(value * 100);
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
  static bool isImage(String url) {
    final lowerUrl = url.toLowerCase();
    final imageExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
      '.svg'
    ];

    return imageExtensions.any((extension) => lowerUrl.endsWith(extension));
  }

  static Map<String, String> SETTING_KEY() => {
        'StaffAutoId': 'StaffAutoId',
        'StaffLeaveAutoId': 'StaffLeaveAutoId',
        'OvertimeAutoId': 'OvertimeAutoId',
        'StaffExceptionAutoId': 'StaffExceptionAutoId',
        'PayrollRequestAutoId': 'PayrollRequestAutoId',
        'LoanAutoId': 'LoanAutoId',
        'CurrencyId': 'CurrencyId',
        'CompanyName': 'CompanyName',
        'CompanyNameKh': 'CompanyNameKh',
        'CompanyAddress': 'CompanyAddress',
        'CompanyAddressKh': 'CompanyAddressKh',
        'CompanyPhone': 'CompanyPhone',
        'CompanyLogo': 'CompanyLogo',
        'CompanyEmail': 'CompanyEmail',
        'CompanyWebsite': 'CompanyWebsite',
        'LeaveAutoApprove': 'LeaveAutoApprove',
        'ExceptionAutoApprove': 'ExceptionAutoApprove',
        'OvertimeRequestAutoApprove': 'OvertimeRequestAutoApprove',
        'PayrollRequestAutoApprove': 'PayrollRequestAutoApprove',
        'LoanAutoApprove': 'LoanAutoApprove',
        'MissionAutoId': 'MissionAutoId',
        'LeaveVisibility': 'LeaveVisibility',
        'OvertimeVisibility': 'OvertimeVisibility',
        'ExceptionVisibility': 'ExceptionVisibility',
        'ApproveVisibility': 'ApproveVisibility',
        'GeoTrackingPeriod': 'GeoTrackingPeriod',
        'TrackingDistant': 'TrackingDistant',
        'SelfApprove': 'SelfApprove',
        'LogoutVisibility': 'LogoutVisibility',
        'AbsentExceptionVisibility': 'AbsentExceptionVisibility',
        'AppAndroidVersion': 'AppAndroidVersion',
        'AppIosVersion': 'AppIosVersion',
        'AppAndroidUrl': 'AppAndroidUrl',
        'AppIosUrl': 'AppIosUrl'
      };
}
