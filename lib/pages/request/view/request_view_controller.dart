import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/models/request_model.dart';
import 'package:staff_view_ui/pages/request/request_service.dart';

class RequestViewController extends GetxController {
  final RequestApproveService service = RequestApproveService();
  final model = RequestModel().obs;
  final requestData = Rxn<Map<String, dynamic>>();
  final canDoAction = false.obs;
  final loading = false.obs;
  int id = 0;
  int reqType = 0;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    reqType = Get.arguments['reqType'];
    checkCanDoAction();
    if (reqType != 0) {
      findByReqType(reqType);
    } else {
      findById();
    }
  }

  void findByReqType(int reqType) async {
    loading.value = true;
    final response = await service.findByReqType(id, reqType);
    if (response.statusCode == 200) {
      model.value = response.data!;
    }
    loading.value = false;
  }

  void checkCanDoAction() async {
    final response = await service.canDoAction(id);
    if (response.statusCode == 200) {
      canDoAction.value = response.data!;
    }
  }

  void findById() async {
    loading.value = true;
    model.value = RequestModel.fromJson(await service.find(id));
    requestData.value = jsonDecode(model.value.requestData ?? '');
    loading.value = false;
  }
}
