import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:staff_view_ui/helpers/storage.dart';

class AppSetting {
  static var setting;
  static Storage storage = Storage();
  Future<void> initSetting() async {
    if (storage.read('setting') == null) {
      try {
        String jsonString = await rootBundle.loadString('assets/setting.json');
        var data = jsonDecode(jsonString);

        setting = data;
      } catch (e) {
        kDebugMode ? print('Error loading settings: $e') : null;
      }
      storage.write('setting', jsonEncode(setting));
    } else {
      setting = jsonDecode(storage.read('setting') ?? '');
    }
  }
}
