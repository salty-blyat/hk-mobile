import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/models/timeline_model.dart';
import 'package:staff_view_ui/pages/leave/leave_screen.dart';
import 'package:staff_view_ui/pages/request/view/request_view_controller.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';
import 'package:staff_view_ui/utils/style.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';
import 'package:timelines/timelines.dart';

class RequestViewScreen extends StatelessWidget {
  final RequestViewController controller = Get.put(RequestViewController());

  RequestViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() => controller.loading.value
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(context)),
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

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileCard(),
          const SizedBox(height: 16),
          _buildRequestDetailsCard(),
          const SizedBox(height: 16),
          _buildTimeline(context),
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
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final logs = controller.model.value.requestLogs ?? [];
    logs.insert(
        0,
        TimelineModel(
          status: 0,
          statusNameKh: 'Request',
          createdDate: DateTime.now(),
        ));

    if (logs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Expanded(
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          indicatorTheme: const IndicatorThemeData(
            position: 0,
            size: 18.0,
          ),
          connectorTheme: const ConnectorThemeData(
            thickness: 2.5,
          ),
        ),
        // padding: const EdgeInsets.symmetric(vertical: 20.0),
        builder: TimelineTileBuilder(
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          itemCount: logs.length,
          contentsBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      if (index == 0 &&
                          logs[index + 1].status != LeaveStatus.pending.value)
                        _actionButton(
                            const Color.fromARGB(221, 22, 22, 22),
                            CupertinoIcons.arrowshape_turn_up_left,
                            'Undo'.tr,
                            () => controller.showApproveDialog(
                                context,
                                RequestStatus.undo.value,
                                controller.model.value.id ?? 0)),
                      if (index == 0 &&
                          logs[index + 1].status == LeaveStatus.pending.value)
                        _actionButton(AppTheme.successColor,
                            CupertinoIcons.checkmark, 'Approve'.tr, () {
                          controller.showApproveDialog(
                              context,
                              RequestStatus.approve.value,
                              controller.model.value.id ?? 0);
                        }),
                      if (index == 0 &&
                          logs[index + 1].status == LeaveStatus.pending.value)
                        const SizedBox(width: 16),
                      if (index == 0 &&
                          logs[index + 1].status == LeaveStatus.pending.value)
                        _actionButton(AppTheme.dangerColor,
                            CupertinoIcons.xmark, 'Reject'.tr, () {
                          controller.showApproveDialog(
                              context,
                              RequestStatus.reject.value,
                              controller.model.value.id ?? 0);
                        }),
                      if (index != 0)
                        Text(
                          logs[index].statusNameKh ?? '',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 16.0,
                                  ),
                        ),
                      const SizedBox(width: 8),
                      if (index != 0)
                        Text(
                          convertToKhmerTimeAgo(
                              logs[index].createdDate ?? DateTime.now()),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                  ),
                        ),
                    ],
                  ),
                  if (index != 0) _buildTimelineContent(logs[index]),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
          indicatorBuilder: (_, index) {
            if (index == 0) {
              if (logs[index + 1].status == LeaveStatus.pending.value) {
                return const Icon(
                  CupertinoIcons.clock,
                  color: AppTheme.warningColor,
                  size: 20.0,
                );
              } else if (logs[index + 1].status == LeaveStatus.approved.value) {
                return const Icon(
                  CupertinoIcons.arrow_uturn_left_circle,
                  color: Colors.black,
                  size: 20.0,
                );
              } else {
                return const SizedBox.shrink();
              }
            }
            if (logs[index].status == LeaveStatus.approved.value) {
              return const OutlinedDotIndicator(
                size: 18.0,
                color: AppTheme.successColor,
                child: Icon(
                  Icons.check,
                  color: AppTheme.successColor,
                  size: 12.0,
                ),
              );
            } else if (logs[index].status == LeaveStatus.pending.value) {
              return const OutlinedDotIndicator(
                size: 18.0,
                color: AppTheme.primaryColor,
                child: Icon(
                  CupertinoIcons.circle_fill,
                  color: AppTheme.primaryColor,
                  size: 12.0,
                ),
              );
            } else if (logs[index].status == LeaveStatus.rejected.value) {
              return const OutlinedDotIndicator(
                color: AppTheme.dangerColor,
                size: 18.0,
                child: Icon(
                  CupertinoIcons.xmark,
                  color: AppTheme.dangerColor,
                  size: 12.0,
                ),
              );
            } else if (logs[index].status == LeaveStatus.processing.value) {
              return const OutlinedDotIndicator(
                size: 18.0,
                color: AppTheme.primaryColor,
                child: Icon(
                  CupertinoIcons.arrow_2_circlepath,
                  color: AppTheme.primaryColor,
                  size: 12.0,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
          // connectorBuilder: (_, index, ___) => SolidLineConnector(
          //   color: logs[index].status == LeaveStatus.approved.value
          //       ? Theme.of(context).colorScheme.primary
          //       : null,
          // ),
        ),
      ),
    );
  }

  Widget _actionButton(
      Color color, IconData icon, String title, Function() onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 16.0,
          ),
          const SizedBox(width: 4),
          Text(title.tr),
        ],
      ),
    );
  }

  Widget _buildTimelineContent(TimelineModel log) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _info('Request date',
            '${convertToKhmerDate(log.createdDate ?? DateTime.now())} ${getTime(log.createdDate ?? DateTime.now())}'),
        log.departmentName != null
            ? _info('Department', log.departmentName ?? '')
            : const SizedBox.shrink(),
        log.positionName != null
            ? _info('Position', log.positionName ?? '')
            : const SizedBox.shrink(),
        log.createdBy != null
            ? _info('Created by', log.createdBy ?? '')
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(title.tr)),
          Text(': $value'),
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
              color: Style.getStatusColor(controller.model.value.status ?? 0),
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
    return const Column(
      children: [],
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
}
