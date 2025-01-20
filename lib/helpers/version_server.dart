import 'package:flutter/services.dart';

class AppVersion {
  static const MethodChannel _channel = MethodChannel('app.version.channel');

  static Future<String?> getAppVersion() async {
    try {
      final String? version = await _channel.invokeMethod('getAppVersion');
      return version;
    } catch (e) {
      print('Error retrieving app version: $e');
      return null;
    }
  }
}
