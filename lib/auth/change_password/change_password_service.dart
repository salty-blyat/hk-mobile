import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:staff_view_ui/app_setting.dart';

class ChangePasswordService {
  final String authUrl = AppSetting.setting['AUTH_API_URL'];
  final dio.Dio dioClient = dio.Dio();
  final secureStorage = const FlutterSecureStorage();

  Future<dynamic> changePassword(dynamic model) async {
    dioClient.options.baseUrl = authUrl;
    dioClient.options.headers.addAll({
      'disableErrorNotification': 'yes',
      'X-ACCEPT-REFRESH-TOKEN': 'true',
    });
    try {
      final token = await readFromLocalStorage('accessToken');

      if (token != null) {
        dioClient.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await dioClient.post(
        '/auth/change-password',
        data: model,
        options: dio.Options(
          headers: dioClient.options.headers,
          contentType: dio.Headers.jsonContentType,
          responseType: dio.ResponseType.json,
        ),
      );
      print("Response data: ${response.data}");

      return response.data;
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
