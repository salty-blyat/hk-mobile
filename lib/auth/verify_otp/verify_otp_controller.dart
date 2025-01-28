import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class VerifyOtpController extends GetxController {
  final _authService = AuthService();
  final loading = false.obs;
  final error = ''.obs;
  final userId = 0.obs;
  @override
  void onInit() {
    super.onInit();
    userId.value = Get.arguments['userId'];
  }

  void submit(String otp) async {
    Modal.loadingDialog();
    try {
      var res =
          await _authService.verifyOtp({'otp': otp, 'userId': userId.value});
      if (res.statusCode == 200) {
        Get.back();
        Get.toNamed('/input-new-password', arguments: {
          'resetKey': res.data['resetKey'],
        });
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
