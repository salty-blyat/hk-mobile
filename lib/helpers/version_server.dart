import 'package:flutter/services.dart';
import 'package:staff_view_ui/app_setting.dart';

class AppVersion {
  static const MethodChannel _channel = MethodChannel('app.version.channel');

  static Future<String?> getAppVersion() async {
    try {
      // final String? version = await _channel.invokeMethod('getAppVersion');
      final String version = AppSetting.setting['APP_VERSION'];
      return version;
    } catch (e) {
      print('Error retrieving app version: $e');
      return null;
    }
  }
}
