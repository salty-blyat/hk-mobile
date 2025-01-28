import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/helpers/common_validators.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class ForgotPasswordController extends GetxController {
  final formGroup = fb.group({
    'sendTo': FormControl<String>(
      value: null,
      validators: [
        Validators.delegate(CommonValidators.required),
        Validators.delegate(CommonValidators.phoneOrEmailValidator)
      ],
    ),
    'encodedResponse': FormControl<String>(),
  });
  final formValid = false.obs;
  final _authService = AuthService();
  final loading = false.obs;
  final error = ''.obs;
  @override
  void onInit() {
    super.onInit();
    formGroup.valueChanges.listen((value) {
      formValid.value = formGroup.valid;
    });
  }

  void submit() async {
    if (formGroup.valid) {
      Modal.loadingDialog();
      try {
        var res = await _authService.forgotPassword(formGroup.value);
        if (res.statusCode == 200) {
          Get.back();
          Get.snackbar('Forgot Password', res.data['message']);
          Get.toNamed('/verify-otp', arguments: {
            'userId': res.data['userId'],
          });
        } else {
          Get.back();
          error.value = res.data['message'].tr;
        }
      } on DioException catch (e) {
        Get.back();
        error.value = e.response?.data['message'].toString().tr ??
            'Failed to send verification code';
      }
    }
  }
}
