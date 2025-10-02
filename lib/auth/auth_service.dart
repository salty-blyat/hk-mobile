import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/models/client_info_model.dart';

class AuthService {
  final String authUrl = AppSetting.setting['AUTH_API_URL'];
  final dio.Dio dioClient = dio.Dio();
  final secureStorage = const FlutterSecureStorage();

  setOptions(bool isSingleLogin) {
    dioClient.options.baseUrl = authUrl;
    dioClient.options.headers.addAll({
      'disableErrorNotification': 'yes',
      'X-ACCEPT-REFRESH-TOKEN': 'true',
    });
    if (isSingleLogin) {
      dioClient.options.headers['X-SINGLE-SESSION'] = 'true';
    }
  }

  Future<dio.Response> login(dynamic model, bool isSingleLogin) async {
    setOptions(isSingleLogin);

    final response = await dioClient.post(
      '/auth/login',
      data: model,
      options: dio.Options(
        headers: dioClient.options.headers,
        contentType: dio.Headers.jsonContentType,
        responseType: dio.ResponseType.json,
      ),
    );
 
    return response;
  }

  Future<dio.Response> verifyMfa(Map<String, String> map) async {
    setOptions(false);

    final response = await dioClient.post(
      '/auth/mfa',
      data: map,
      options: dio.Options(
        headers: dioClient.options.headers,
        contentType: dio.Headers.jsonContentType,
        responseType: dio.ResponseType.json,
      ),
    );
    return response;
  }

  Future<dio.Response> forgotPassword(dynamic model) async {
    setOptions(false);

    final response = await dioClient.post(
      '/auth/forget-password',
      data: model,
      options: dio.Options(
        headers: dioClient.options.headers,
        contentType: dio.Headers.jsonContentType,
        responseType: dio.ResponseType.json,
      ),
    );

    return response;
  }

  Future<void> saveToLocalStorage(String key, String value) async {
    try {
      await secureStorage.write(key: key, value: value);
    } catch (e) {
      throw Exception('Error reading from secure storage: $e');
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

  Future<dio.Response> logout() async {
    setOptions(false);

    return await dioClient.get(
      '/auth/logout',
      options: dio.Options(
        headers: dioClient.options.headers,
        contentType: dio.Headers.jsonContentType,
        responseType: dio.ResponseType.json,
      ),
    );
  }

  Future<dio.Response> verifyOtp(Map<String, dynamic> model) async {
    setOptions(false);

    final response = await dioClient.post(
      '/auth/forget-password-verify-otp',
      data: model,
      options: dio.Options(
        headers: dioClient.options.headers,
        contentType: dio.Headers.jsonContentType,
        responseType: dio.ResponseType.json,
      ),
    );

    return response;
  }

  Future<dio.Response> resetPassword(Map<String, Object?> model) async {
    setOptions(false);

    final response = await dioClient.post(
      '/auth/reset-password',
      data: model,
      options: dio.Options(
        headers: dioClient.options.headers,
        contentType: dio.Headers.jsonContentType,
        responseType: dio.ResponseType.json,
      ),
    );

    return response;
  }

  Future<void> saveToken(ClientInfo info) async {
    await saveToLocalStorage(Const.authorized['Authorized']!, jsonEncode(info.toJson()));
    await saveToLocalStorage('accessToken', info.token ?? '');
    await saveToLocalStorage('refreshToken', info.refreshToken ?? '');
  }
}
