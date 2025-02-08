import 'dart:convert';

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/helpers/storage.dart';

class AppInfoController extends GetxController {
  final storage = Storage();
  final formGroup = FormGroup({
    'coreUrl': FormControl<String>(validators: [Validators.required]),
    'apiUrl': FormControl<String>(validators: [Validators.required]),
    'tenant': FormControl<String>(validators: [Validators.required]),
  });
  final isValid = false.obs;
  @override
  void onInit() {
    super.onInit();
    formGroup.valueChanges.listen((value) {
      isValid.value = formGroup.valid;
    });
    var setting = jsonDecode(storage.read('setting') ?? '');
    setFormValue({
      'coreUrl': setting['AUTH_API_URL'],
      'apiUrl': setting['BASE_API_URL'],
      'tenant': setting['TENANT_CODE'],
    });
  }

  setFormValue(Map<String, dynamic> value) {
    formGroup.patchValue(value);
  }

  save() async {
    var setting = jsonDecode(storage.read('setting') ?? '');
    setting['AUTH_API_URL'] = formGroup.value['coreUrl'];
    setting['BASE_API_URL'] = formGroup.value['apiUrl'];
    setting['TENANT_CODE'] = formGroup.value['tenant'];
    storage.write('setting', jsonEncode(setting));
    AppSetting.setting = setting;
    Get.back();
  }

  @override
  void onClose() {
    formGroup.dispose();
    super.onClose();
  }
}
