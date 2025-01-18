import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/models/request_model.dart';
import 'package:staff_view_ui/pages/leave/leave_screen.dart';
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
    if (reqType == 0) {
      checkCanDoAction();
    }
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

  bool isCurrentApprover() {
    return false;
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

  void showAttachments() async {
    final controller = WebViewController();
    var url = requestData.value?['attachments'].first['url'];

    controller.loadRequest(Uri.parse(url));

    Get.dialog(Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              Text('Attachment'.tr, style: const TextStyle(fontSize: 16)),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(CupertinoIcons.clear),
              ),
            ],
          ),
          Expanded(
              child: Const.isImage(url)
                  ? WebViewWidget(controller: controller)
                  : PDFView(
                      filePath: url,
                    )),
        ],
      ),
    ));
  }

  @override
  void onClose() {
    Get.delete<RequestOperationController>();
    super.onClose();
  }
}
