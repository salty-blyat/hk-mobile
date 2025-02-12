import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/helpers/common_validators.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';
import 'package:staff_view_ui/utils/widgets/snack_bar.dart';

class InputNewPasswordController extends GetxController {
  final formGroup = fb.group({
    'password': FormControl<String>(
      value: null,
      validators: [
        Validators.delegate(CommonValidators.required),
      ],
    ),
    'confirmPassword': FormControl<String>(
      value: null,
      validators: [
        Validators.delegate(CommonValidators.required),
      ],
    ),
    'resetKey': FormControl<String>(
      value: Get.arguments['resetKey'],
      validators: [
        Validators.delegate(CommonValidators.required),
      ],
    ),
  }, [
    Validators.delegate(CommonValidators.mustMatch(
        'password', 'confirmPassword',
        markAsDirty: false)),
  ]);
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
    Get.focusScope?.unfocus();
    if (formGroup.valid) {
      Modal.loadingDialog();
      try {
        var res = await _authService.resetPassword({
          'resetKey': formGroup.value['resetKey'],
          'password': formGroup.value['password'],
        });
        if (res.statusCode == 200) {
          successSnackbar('Success'.tr, 'Password reset successfully');
          Get.offAllNamed('/login');
        } else {
          throw Exception('Failed to send verification code');
        }
      } on DioException catch (e) {
        print(e.response?.data);
        error.value = 'Failed to send verification code';
      } catch (e) {
        print(e);
        error.value = 'Failed to send verification code';
      }
    }
  }
}
