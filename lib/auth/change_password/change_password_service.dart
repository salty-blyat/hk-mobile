import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';

class ChangePasswordService {
  final String authUrl = AppSetting.setting['AUTH_API_URL'];
  final dioClient = DioClient();

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

  Future<dynamic> getUserInfo() async {
    try {
      final response = await dioClient.getCustom('$authUrl/auth/info');
      return response;
    } catch (e) {
      // ignore: avoid_print
      print('Get user info Error: $e');
    }
  }
}
