import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';

class EditProfileService {
  final String authUrl = AppSetting.setting['AUTH_API_URL'];
  final dioClient = DioClient();
  final secureStorage = const FlutterSecureStorage();

  Future<dynamic> editProfile(dynamic model) async {
    try {
      final response = await dioClient.postCustom(
        '$authUrl/auth/edit-profile',
        data: model,
      );

      return response;
    } catch (e) {
      // ignore: avoid_print
      print('Error edit: $e');
    }
  }

  Future<dynamic> getUserInfo() async {
    try {
      final response = await dioClient.getCustom('$authUrl/auth/info');
      return response;
    } catch (e) {
      // ignore: avoid_print
      print('Get user info Error: $e');
    }
  }

  Future<void> saveToLocalStorage(String key, String value) async {
    try {
      await secureStorage.write(key: key, value: value);
    } catch (e) {
      throw Exception('Error saving to secure storage: $e');
    }
  }
}
