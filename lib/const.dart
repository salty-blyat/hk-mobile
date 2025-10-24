import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';

class Const {
  static const String version = '1.9';
  static const String date = '10-02-2025';
  static const String staffId = "StaffId";
  static String numberFormat(double value) {
    return NumberFormat('###.##').format(value);
  }

  static String getPrettyDate(DateTime? d) {
    if(d == null)return '';
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  static String percentageFormat(double value) {
    return NumberFormat('###').format(value * 100);
  }

  static String getRequestType(int requestType) {
    return requestType == RequestTypes.internal.value
        ? "Guest".tr
        : "Internal".tr;
  }

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
    'MenuItems': 'MenuItems',
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
        'DelegateVisibility': 'DelegateVisibility',
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
