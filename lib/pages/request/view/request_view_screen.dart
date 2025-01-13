import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/pages/leave/leave_screen.dart';
import 'package:staff_view_ui/pages/request/view/request_view_controller.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';
import 'package:timelines/timelines.dart';

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

class RequestViewScreen extends StatelessWidget {
  final RequestViewController controller = Get.put(RequestViewController());

  RequestViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() => controller.loading.value
          ? const Center(child: CircularProgressIndicator())
          : _buildBody()),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(() => controller.loading.value
          ? const Text('-')
          : Text(
              '${controller.model.value.requestNo ?? ''} - ${controller.model.value.requestTypeName?.tr ?? ''}',
            )),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileCard(),
          const SizedBox(height: 16),
          _buildRequestDetailsCard(),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildProfileAvatar(),
          const SizedBox(width: 16),
          _buildProfileDetails(),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return controller.model.value.photo != null
        ? CircleAvatar(
            child: ClipOval(
              child: Image.network(
                controller.model.value.photo ?? '',
                fit: BoxFit.cover,
                height: 64,
                width: 64,
              ),
            ),
          )
        : CircleAvatar(
            backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
            child: Text(
              controller.model.value.staffNameKh?.substring(0, 1) ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            '${controller.model.value.staffNameKh ?? ''} ${controller.model.value.staffNameEn ?? ''}'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.model.value.positionName ?? '',
                style: const TextStyle(fontSize: 12)),
            Text(
              controller.model.value.departmentName ?? '',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequestDetailsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: _buildRequestDetails(),
    );
  }

  Widget _buildRequestDetails() {
    final requestType =
        RequestType.fromValue(controller.model.value.requestType);

    switch (requestType) {
      case RequestType.leave:
        return _buildLeaveInfo();
      case RequestType.ot:
        return _buildOtInfo();
      case RequestType.exception:
        return _buildExceptionInfo();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLeaveInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfo(
              CupertinoIcons.bookmark,
              controller.requestData.value?['leaveTypeName'] ?? '',
            ),
            Tag(
              text: controller.model.value.statusNameKh ?? '',
              color: _getStatusColor(controller.model.value.status ?? 0),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildInfo(
              CupertinoIcons.calendar,
              controller.requestData.value?['totalDays'] < 1
                  ? '${Const.numberFormat(controller.requestData.value?['totalHours'])} ${'Hour'.tr}'
                  : '${Const.numberFormat(controller.requestData.value?['totalDays'])} ${'Day'.tr}',
            ),
            const SizedBox(width: 8),
            Text(
              controller.requestData.value?['totalDays'] > 1
                  ? '${convertToKhmerDate(DateTime.parse(controller.requestData.value?['fromDate'] ?? ''))} - ${convertToKhmerDate(DateTime.parse(controller.requestData.value?['toDate'] ?? ''))}'
                  : convertToKhmerDate(DateTime.parse(
                      controller.requestData.value?['fromDate'] ?? '')),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildInfo(CupertinoIcons.macwindow,
            '${Const.numberFormat(controller.requestData.value?['balance'])} = ${Const.numberFormat(controller.requestData.value?['balance'] + controller.requestData.value?['totalDays'])} - ${Const.numberFormat(controller.requestData.value?['totalDays'])}'),
        const SizedBox(height: 8),
        _buildInfo(CupertinoIcons.doc_plaintext,
            controller.requestData.value?['reason'] ?? ''),
      ],
    );
  }

  Widget _buildOtInfo() {
    return Column(
      children: [
        _buildInfo(
          CupertinoIcons.calendar,
          controller.requestData.value?['totalDays'] < 1
              ? '${Const.numberFormat(controller.requestData.value?['totalHours'])} ${'Hour'.tr}'
              : '${Const.numberFormat(controller.requestData.value?['totalDays'])} ${'Day'.tr}',
        ),
      ],
    );
  }

  Widget _buildExceptionInfo() {
    return Column(
      children: [
        _buildInfo(
          CupertinoIcons.clock,
          controller.requestData.value?['absentTime'] ?? '',
        ),
      ],
    );
  }

  Widget _buildInfo(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Text(value),
      ],
    );
  }

  Color _getStatusColor(int status) {
    if (LeaveStatus.approved.value == status) {
      return AppTheme.successColor;
    } else if (LeaveStatus.rejected.value == status) {
      return AppTheme.dangerColor;
    } else if (LeaveStatus.processing.value == status) {
      return AppTheme.primaryColor;
    } else {
      return AppTheme.warningColor;
    }
  }
}
