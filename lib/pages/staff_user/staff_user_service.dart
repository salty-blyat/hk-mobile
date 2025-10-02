import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/staff_user_model.dart';

class StaffUserService {
  final dioClient = DioClient();
  // final Dio dio = Dio();
  // final secureStorage = const FlutterSecureStorage();
  // final String baseUrl = AppSetting.setting['BASE_API_URL'];

  // Future<void> setOptions({String? token}) async {
  //   final tokenFromStorage= await secureStorage.read(key: Const.authorized['AccessToken']!);

  //   dio.options.baseUrl = baseUrl;
  //   dio.options.headers['Authorization'] = 'Bearer ${token ?? tokenFromStorage}';
  //   dio.options.headers['Tenant-Code'] = AppSetting.setting['TENANT_CODE'];
  //   dio.options.headers['App-Code'] = AppSetting.setting['APP_CODE'];
  //   dio.options.headers['Content-Type'] = 'application/json';
  // }

  Future<StaffUserModel> getUserInfoWithToken() async {
    // await setOptions(token: token);

    final res = await dioClient.get('/staffuser/mobile/info');

    if (res!.statusCode == 200) {
      return StaffUserModel.fromJson(res.data );
    } else {
      throw Exception("Cannot find the user linked to this account");
    }
  }
}
