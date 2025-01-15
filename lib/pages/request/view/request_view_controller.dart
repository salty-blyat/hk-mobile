import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/models/request_model.dart';
import 'package:staff_view_ui/pages/request/operation/request_approve.dart';
import 'package:staff_view_ui/pages/request/operation/request_reject.dart';
import 'package:staff_view_ui/pages/request/request_service.dart';
import 'package:staff_view_ui/pages/request/operation/request_undo.dart';

enum RequestType {
  leave(1),
  ot(2),
  exception(3);

  final int value;
  const RequestType(this.value);

  static RequestType? fromValue(int? value) {
    return RequestType.values.firstWhereOrNull((type) => type.value == value);
  }
}

enum RequestStatus {
  approve(0),
  reject(1),
  undo(2);

  final int value;
  const RequestStatus(this.value);

  static RequestStatus? fromValue(int? value) {
    return RequestStatus.values
        .firstWhereOrNull((status) => status.value == value);
  }
}

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
      findById(id);
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

  void findById(int id) async {
    loading.value = true;
    model.value = RequestModel.fromJson(await service.find(id));
    requestData.value = jsonDecode(model.value.requestData ?? '');
    loading.value = false;
  }

  void showApproveDialog(BuildContext context, int requestStatus, int id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow resizing beyond default limits
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4, // Initial height (40% of screen)
          minChildSize: 0.2, // Minimum height (20% of screen)
          maxChildSize: 0.8, // Maximum height (80% of screen)
          expand: false, // Prevents full screen expansion
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Handle at the top center
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      child: requestStatus == RequestStatus.approve.value
                          ? ApproveRequest(id: id)
                          : requestStatus == RequestStatus.reject.value
                              ? RejectRequest(id: id)
                              : UndoRequest(id: id),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
