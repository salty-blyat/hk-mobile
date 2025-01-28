import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class VerifyMfaController extends GetxController {
  final _authService = AuthService();
  final loading = false.obs;
  final error = ''.obs;
  final mfaToken = ''.obs;
  @override
  void onInit() {
    super.onInit();
    mfaToken.value = Get.arguments['mfaToken'];
  }

  void submit(String otp) async {
    Modal.loadingDialog();
    try {
      var res = await _authService
          .verifyMfa({'verifyCode': otp, 'mfaToken': mfaToken.value});
      if (res.statusCode == 200) {
        ClientInfo info = ClientInfo.fromJson(res.data);
        Get.back();
        if (info.changePasswordRequired == true) {
          Get.toNamed('/change-password');
        } else {
          _authService.saveToken(info);
          Get.toNamed('/menu');
        }
      } else {
        Get.back();
        error.value = res.data['message'].toString().tr;
      }
    } on DioException catch (e) {
      Get.back();
      error.value = e.response?.data['message'].toString().tr ??
          'Failed to verify OTP'.tr;
    }
  }
}
