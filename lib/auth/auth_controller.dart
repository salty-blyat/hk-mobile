import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/models/staff_user_model.dart';
import 'package:staff_view_ui/pages/staff_user/staff_user_controller.dart';
import 'package:staff_view_ui/pages/staff_user/staff_user_service.dart';
import 'package:staff_view_ui/route.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';
import 'package:staff_view_ui/utils/widgets/snack_bar.dart';

enum PositionEnum { manager, housekeeper }

extension PositionEnumExtension on PositionEnum {
  static const Map<PositionEnum, int> _values = {
    PositionEnum.manager: 1,
    PositionEnum.housekeeper: 2,
  };

  int get value => _values[this]!;
}

class AuthController extends GetxController {
  final language = 'en'.obs;
  final _authService = AuthService();
  // final _firebaseService = NotificationService();
  // final staffUserController = Get.put(StaffUserController());
  final staffUserService = StaffUserService();
  final passwordController = TextEditingController();
  final loading = false.obs;
  final formValid = false.obs;
  final storage = Storage();
  final error = ''.obs;
  final formKey = GlobalKey<FormState>();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final FormGroup formGroup = fb.group({
    'username': FormControl<String>(validators: [Validators.required]),
    'password': FormControl<String>(validators: [Validators.required]),
  });
  final position = PositionEnum.manager.value.obs;

  @override
  void onInit() {
    super.onInit();
    formGroup.valueChanges.listen((value) {
      formValid.value = formGroup.valid;
    });

    language.value = Storage().read('lang') ?? 'km';
  }

  // Login Form Group
  Rx<ClientInfo?> auth = Rxn<ClientInfo>();

  login() async {
    Get.focusScope?.unfocus();
    Modal.loadingDialog();
    try {
      final response = await _authService.login(
        formGroup.value,
        false,
      );

      if (response.statusCode == 200) {
        error.value = '';
        ClientInfo info = ClientInfo.fromJson(response.data);
        if (info.mfaRequired == true) {
          successSnackbar('MFA'.tr, response.data['message']);
          Get.toNamed(RouteName.verifyMfa, arguments: {
            'mfaToken': info.mfaToken,
          });
          return;
        }
        // _firebaseService.handlePassToken();
        _authService.saveToken(info);
        if (info.changePasswordRequired == true) {
          Get.toNamed(RouteName.changePassword);
        } else {
          // await staffUserController.getUser();
          StaffUserModel staffUser = await staffUserService.getStaffUser(); 

          storage.write(StorageKeys.staffUser, jsonEncode(staffUser));
          if (staffUser.positionId ==
              PositionEnum.manager.value) {
            Get.offAllNamed(RouteName.houseKeeping);
          } else {
            Get.offAllNamed(RouteName.task);
          }
        }
        if (Get.isDialogOpen == true) {
          Get.back();
        }
      } else {
        Get.back();
        error.value = response.data['message'].toString().tr;
      }
    } on DioException catch (e) {
      Get.back();
      error.value =
          e.response?.data['message'].toString().tr ?? 'Something went wrong';
    }
  }

  logout() async {
    try {
      // final res = await _firebaseService.handleRemoveToken();
      // if (res.statusCode == 200) {
      handleLogout();
      // } else {
      //   handleLogout();
      // }
    } catch (e) {
      handleLogout();
    }
  }

  handleLogout() async {
    try {
      final res = await _authService.logout();
      if (res.statusCode == 200) {
        _authService.deleteFromLocalStorage(Const.authorized['Authorized']!);
        secureStorage.delete(key: Const.authorized['AccessToken']!);
        secureStorage.delete(key: Const.authorized['RefreshToken']!);
        Get.offAllNamed('/login');
      } else {
        handleLogoutError();
      }
    } catch (e) {
      handleLogoutError();
    }
  }

  handleLogoutError() {
    _authService.deleteFromLocalStorage(Const.authorized['Authorized']!);
    secureStorage.delete(key: Const.authorized['AccessToken']!);
    secureStorage.delete(key: Const.authorized['RefreshToken']!);
    Get.offAllNamed('/login');
  }
}
