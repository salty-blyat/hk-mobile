import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/staff_user_model.dart';

class StaffUserService {
  final dioClient = DioClient(); 

  Future<StaffUserModel> getStaffUser() async {
    final res = await dioClient.get('/staffuser/mobile/info');

    if (res!.statusCode == 200) {
      return StaffUserModel.fromJson(res.data );
    } else {
      throw Exception("Cannot find the user linked to this account");
    }
  }
}
