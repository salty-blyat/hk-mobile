import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/models/attachment_model.dart';
import 'package:staff_view_ui/models/log_model.dart';
import 'package:staff_view_ui/pages/request_log/request_log_controller.dart';
import 'package:staff_view_ui/pages/task/operation/change_status_screen.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';
import 'package:staff_view_ui/route.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/network_img.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestLogScreen extends StatelessWidget {
  final RequestLogController controller = Get.put(RequestLogController());
  final TaskController taskController = Get.put(TaskController());
  RequestLogScreen({super.key});
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
    return AppBar(title: Text("Task".tr));
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        if (Get.arguments['id'] != 0) {
         await controller.find(Get.arguments['id'] as int);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${'Task from'.tr} ${Const.getRequestType(controller.model.value.requestType ?? 0)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            _buildTaskDetailCard(),
            controller.model.value.staffId != 0
                ? const SizedBox(height: 16)
                : const SizedBox.shrink(),
            controller.model.value.staffId != 0
                ? _buildProfileCard()
                : const SizedBox.shrink(),
            controller.model.value.status != RequestStatusEnum.done.value
                ? const SizedBox(height: 16)
                : const SizedBox.shrink(),
            const SizedBox(height: 16),
            Column(
              children: [
                if (controller.model.value.attachments != null &&
                    controller.model.value.attachments!.isNotEmpty)
                  ...controller.model.value.attachments!.asMap().entries.map(
                        (entry) => GestureDetector(
                          key: Key(entry.key.toString()),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAttachment(CupertinoIcons.doc,
                                  '${'Attachment'.tr} ${entry.key + 1}',
                                  isLink: true),
                              const SizedBox(height: 8),
                            ],
                          ),
                          onTap: () async {
                            final Uri uri = Uri.parse(entry.value.url);

                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              throw 'Could not launch $uri';
                            }
                          },
                        ),
                      )
                else
                  const SizedBox.shrink(),
                // if (controller.model.value.attachments != null &&
                //     controller.model.value.attachments!.isNotEmpty)
                //   const SizedBox(height: 16)
              ],
            ),
            _actionButton(
                status: controller.model.value.status ?? 0,
                isTaskUnassigned: controller.model.value.staffId == 0,
                staffId: controller.model.value.staffId ?? 0,
                taskId: controller.model.value.id ?? 0),
            const SizedBox(height: 16),
            _buildTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadius,
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildProfileDetails(),
          )
        ],
      ),
    );
  }

  Widget _buildTaskDetailCard() {
    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppTheme.borderRadius,
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(children: [
              SizedBox(
                  width: 42,
                  child: NetworkImg(
                      src: controller.model.value.serviceItemImage,
                      height: 42)),
              const SizedBox(width: 12),
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          controller.model.value.serviceItemName ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 8),
                        controller.model.value.quantity != null &&
                                controller.model.value.quantity! > 0
                            ? Text(
                                "x${controller.model.value.quantity.toString()}")
                            : const SizedBox.shrink()
                      ],
                    ),
                    Text(
                      "${controller.model.value.roomNumber ?? ''}, ${controller.model.value.floorName ?? ''}",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                      softWrap: true,
                    ),
                  ])
            ])),
        Positioned(
          right: 12,
          top: 8,
          child: Row(
            children: [
              NetworkImg(height: 14, src: controller.model.value.statusImage),
              const SizedBox(width: 4),
              Text(Get.locale?.languageCode == 'en'
                  ? controller.model.value.statusNameEn ?? ''
                  : controller.model.value.statusNameKh ?? '', style: TextStyle(fontSize: 12),),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachment(IconData icon, String value, {bool isLink = false}) {
    return Container(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
            fontFamilyFallback: ['Gilroy', 'Kantumruy'],
          ),
          children: [
            WidgetSpan(
              child: Icon(
                icon,
                size: 16,
              ),
            ),
            const WidgetSpan(
              child: SizedBox(width: 4),
            ),
            TextSpan(
              text: value,
              style: isLink
                  ? const TextStyle(
                      color: AppTheme.primaryColor,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final logs = controller.model.value.requestLogs ?? [];

    if (logs.isEmpty) {
      return const SizedBox.shrink();
    }
    return Expanded(
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          color: AppTheme.primaryColor,
        ),
        builder: TimelineTileBuilder(
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          itemCount: logs.length,
          contentsBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(logs[index].statusNameEn ?? '',
                          style:
                              Get.textTheme.bodyLarge?.copyWith(fontSize: 14)),
                      const SizedBox(width: 8),
                      Text(
                        convertToKhmerTimeAgo(logs[index].createdDate),
                        style: Get.textTheme.bodySmall?.copyWith(),
                      ),
                    ],
                  ),
                  _buildTimelineContent(logs[index]),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
          indicatorBuilder: (_, index) {
            return OutlinedDotIndicator(
                position: 0.05,
                borderWidth: 1.3,
                size: 16,
                color: Colors.transparent,
                child:
                    NetworkImg(height: 18, src: logs[index].statusImage ?? ''));
          },
        ),
      ),
    );
  }

  Widget _buildTimelineContent(LogModel log) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _info('Created Date'.tr,
            '${convertToKhmerDate(log.createdDate ?? DateTime.now())} ${getTime(log.createdDate ?? DateTime.now())}'),
        log.createdBy != null
            ? _info('Created By'.tr, log.createdBy ?? '')
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 110,
              child: Text(title.tr,
                  style: const TextStyle(
                    fontSize: 12,
                  ))),
          Expanded(
            child: Text(': $value',
                style: const TextStyle(
                  fontSize: 12,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(controller.model.value.staffName ?? '',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.model.value.positionName ?? '',
              style: const TextStyle(
                fontSize: 12,
              ),
              softWrap: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionButton(
      {required int status,
      bool isTaskUnassigned = false,
      required int staffId,
      required int taskId}) {
    if (isTaskUnassigned && status == RequestStatusEnum.pending.value) {
      return ElevatedButton(
        child: Row(
          children: [const Icon(Icons.person_add_alt_1), Text("Assign".tr)],
        ),
        onPressed: () {
          Get.toNamed(RouteName.taskOp, arguments: {'id': taskId});
        },
      );
    } else if (!isTaskUnassigned &&
        status == RequestStatusEnum.pending.value &&
        taskController.staffUser.value?.staffId == staffId) {
      return ElevatedButton(
        child: Row(
          children: [const Icon(Icons.check), Text("Start task".tr)],
        ),
        onPressed: () {
          Get.dialog(Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.borderRadius,
            ),
            child: SizedBox(
              height: 230,
              width: double.infinity,
              child: ChangeStatusScreen(
                title: "Start Task",
                id: taskId,
                submit: () async {
                  await taskController.updateTaskStatus(
                      taskId, RequestStatusEnum.pending.value);
                  await controller.find(taskId);
                  await taskController.search();
                },
              ),
            ),
          ));
        },
      );
    } else if (status == RequestStatusEnum.inProgress.value &&
        taskController.staffUser.value?.staffId == staffId) {
      return ElevatedButton(
        child: Row(
          children: [const Icon(Icons.check), Text("Mark as complete".tr)],
        ),
        onPressed: () {
          Get.dialog(Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.borderRadius,
            ),
            child: SizedBox(
              height: 230,
              width: double.infinity,
              child: ChangeStatusScreen(
                title: "Mark done",
                id: taskId,
                submit: () async {
                  await taskController.updateTaskStatus(
                      taskId, RequestStatusEnum.inProgress.value);
                  await controller.find(taskId);
                },
              ),
            ),
          ));
        },
      );
    } else if (status == RequestStatusEnum.done.value) {
      return const SizedBox.shrink();
    } else {
      return const SizedBox.shrink();
    }
  }
}
