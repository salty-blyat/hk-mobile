import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/models/request_model.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/pages/request/operation/request_approve.dart';
import 'package:staff_view_ui/pages/request/operation/request_operation_controller.dart';
import 'package:staff_view_ui/pages/request/operation/request_reject.dart';
import 'package:staff_view_ui/pages/request/request_service.dart';
import 'package:staff_view_ui/pages/request/operation/request_undo.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  final storage = Storage();
  final model = RequestModel().obs;
  final requestData = Rxn<Map<String, dynamic>>();
  final canDoAction = false.obs;
  final loading = false.obs;
  final showUndo = false.obs;
  final showApprove = false.obs;
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
      model.value = RequestModel.fromJson(response.data!);
      requestData.value = jsonDecode(model.value.requestData ?? '');
      bool oneDayPassed = model.value.requestLogs![0].createdDate!
          .isBefore(DateTime.now().subtract(const Duration(days: 1)));
      showApprove.value = model.value.status == LeaveStatus.pending.value ||
          model.value.status == LeaveStatus.processing.value;
      showUndo.value = ((model.value.status == LeaveStatus.approved.value ||
              model.value.status == LeaveStatus.rejected.value) &&
          model.value.requestLogs![0].approverId ==
              int.parse(storage.read(Const.staffId) ?? '0') &&
          !oneDayPassed);
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
    try {
      loading.value = true;
      model.value = RequestModel.fromJson(await service.find(id));
      requestData.value = jsonDecode(model.value.requestData ?? '');
      loading.value = false;
      bool oneDayPassed = model.value.requestLogs![0].createdDate!
          .isBefore(DateTime.now().subtract(const Duration(days: 1)));
      showApprove.value = model.value.status == LeaveStatus.pending.value ||
          model.value.status == LeaveStatus.processing.value;
      showUndo.value = ((model.value.status == LeaveStatus.approved.value ||
              model.value.status == LeaveStatus.rejected.value) &&
          model.value.requestLogs![0].approverId ==
              int.parse(storage.read(Const.staffId) ?? '0') &&
          !oneDayPassed);
    } catch (e) {
      loading.value = false;
    }
  }

  bool isCurrentApprover() {
    return false;
  }

  void showApproveDialog(BuildContext context, int requestStatus, int id) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Enables full-screen height adjustments
      backgroundColor: Colors
          .transparent, // Makes the modal background match the top rounded corners
      builder: (BuildContext context) {
        return Padding(
          // Adjusts padding for the keyboard
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.4, // Initial height (40% of screen)
              minChildSize: 0.2, // Minimum height (20% of screen)
              maxChildSize: 0.8, // Maximum height (80% of screen)
              expand: false, // Prevents full screen expansion
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        child: requestStatus == RequestStatus.approve.value
                            ? ApproveRequest(id: id)
                            : requestStatus == RequestStatus.reject.value
                                ? RejectRequest(id: id)
                                : UndoRequest(id: id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void onClose() {
    Get.delete<RequestOperationController>();
    super.onClose();
  }
}
