// import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';

class ChangePasswordService {
  final String authUrl = AppSetting.setting['AUTH_API_URL'];
  final dioClient = DioClient();
  final secureStorage = const FlutterSecureStorage();

  Future<dynamic> changePassword(dynamic model) async {
    try {
      final response = await dioClient.postCustom(
        '$authUrl/auth/change-password',
        data: model,
      );
      return response;
    } catch (e) {
      print('Error changing password: $e');
    }
  }

  // Read data from secure storage
  Future<String?> readFromLocalStorage(String key) async {
    try {
      return await secureStorage.read(key: key);
    } catch (e) {
      throw Exception('Error reading from secure storage: $e');
    }
  }
}
