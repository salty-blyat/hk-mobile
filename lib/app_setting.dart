import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AppSetting {
  static var setting;
  Future<void> initSetting() async {
    try {
      String jsonString = await rootBundle.loadString('assets/setting.json');

      var data = jsonDecode(jsonString);

      setting = data;
    } catch (e) {
      kDebugMode ? print('Error loading settings: $e') : null;
    }
  }
}
