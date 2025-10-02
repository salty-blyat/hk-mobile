import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class Translate extends Translations {
  final dio = Dio();
  final secureStorage = const FlutterSecureStorage();
  @override
  Map<String, Map<String, String>> get keys => translations;

  final Map<String, Map<String, String>> translations = {};

  Future<void> loadTranslations() async {
    for (var lang in ['en', 'km']) {
      final String jsonString =
          await rootBundle.loadString('assets/langs/$lang.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      translations[lang] =
          jsonMap.map((key, value) => MapEntry(key, value.toString()));
    }
  }
}
