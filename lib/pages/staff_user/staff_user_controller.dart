import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/storage.dart';
 import 'package:staff_view_ui/models/staff_user_model.dart';
import 'package:staff_view_ui/pages/staff_user/staff_user_service.dart';

class StaffUserController extends GetxController {
  Rx<StaffUserModel?> staffUser = Rx<StaffUserModel?>(null); 
  RxBool loading = false.obs;
  final storage = Storage();
  final StaffUserService service = StaffUserService();

  Future<void> getUser() async {
    try {
      loading.value = true;
      var res = await service.getStaffUser();
      staffUser.value = res;
      storage.write(StorageKeys.staffUser, jsonEncode(staffUser.value));
      storage.read(StorageKeys.staffUser);
      
      loading.value = false;
    } catch (e) {
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }
}
