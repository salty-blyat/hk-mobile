import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/models/client_info_model.dart';

class AuthService {
  final String authUrl = AppSetting.setting['AUTH_API_URL'];
  final dio.Dio dioClient = dio.Dio();
  final secureStorage = const FlutterSecureStorage();

  Future<dynamic> login(dynamic model, bool isSingleLogin) async {
    // Set base options for Dio
    dioClient.options.baseUrl = authUrl;
    dioClient.options.headers.addAll({
      'disableErrorNotification': 'yes',
      'X-ACCEPT-REFRESH-TOKEN': 'true',
    });

    // Add single login header if required
    if (isSingleLogin) {
      dioClient.options.headers['X-SINGLE-SESSION'] = 'true';
    }

    try {
      final response = await dioClient.post(
        '/auth/login',
        data: model,
        options: dio.Options(
          headers: dioClient.options.headers,
          contentType: dio.Headers.jsonContentType,
          responseType: dio.ResponseType.json,
        ),
      );

      if (response.statusCode == 200) {
        final result = response.data;
        ClientInfo clientInfo = ClientInfo.fromJson(result);

        // Save to secure storage
        await saveToLocalStorage(
            'APP_STORAGE_KEY_Authorized', jsonEncode(result));

        await saveToLocalStorage('accessToken', clientInfo.token ?? '');
        await saveToLocalStorage('refreshToken', clientInfo.refreshToken ?? '');
        return response.statusCode;
      } else {
        throw Exception('Failed to login: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<void> saveToLocalStorage(String key, String value) async {
    try {
      await secureStorage.write(key: key, value: value);
    } catch (e) {
      throw Exception('Error saving to secure storage: $e');
    }
  }

  Future<String?> readFromLocalStorage(String key) async {
    try {
      return await secureStorage.read(key: key);
    } catch (e) {
      throw Exception('Error reading from secure storage: $e');
    }
  }

  Future<void> deleteFromLocalStorage(String key) async {
    try {
      await secureStorage.delete(key: key);
    } catch (e) {
      throw Exception('Error deleting from secure storage: $e');
    }
  }
}
