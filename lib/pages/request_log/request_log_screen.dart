import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/models/attachment_model.dart';
import 'package:staff_view_ui/models/log_model.dart';
import 'package:staff_view_ui/pages/request_log/request_log_controller.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/network_img.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestLogScreen extends StatelessWidget {
  final RequestLogController controller = Get.put(RequestLogController());

  RequestLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() => controller.loading.value
          ? const Center(child: CircularProgressIndicator())
          : _buildBody()),
      // ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(() => controller.loading.value
          ? const Text('-')
          : Text(
              controller.model.value.serviceItemName ?? '',
            )),
      actions: actions(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProfileCard(),
          const SizedBox(height: 16),
          _buildTaskDetailCard(),
          // if (controller.model.value.attachments != null &&
          //     controller.model.value.attachments!.isNotEmpty)
          //   _buildRequestDetailsCard(),
          const SizedBox(height: 16),
          _actionButton(status: RequestStatusEnum.inProgress),
          const SizedBox(height: 16),
          _buildTimeline( ),
        ],
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
          _buildProfileAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: _buildProfileDetails(),
          )
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return
        // controller.model.value.photo != null
        false
            ? CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    "  controller.model.value.photo ?? ''",
                    fit: BoxFit.cover,
                    height: 64,
                    width: 64,
                  ),
                ),
              )
            : CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                child: Text(
                  "controller.model.value.staffNameKh?.substring(0, 1) ?? ''",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
  }

  Widget _buildTaskDetailCard() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppTheme.borderRadius,
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(children: [
          SizedBox(
              width: 32,
              child: NetworkImg(
                  src: controller.model.value.statusImage, height: 32)),
          const SizedBox(width: 12),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("roomnumber ?? '', floornumber"),
                Text(
                  "controller.model.value.serviceItemName, controller.model.value.serviceTypeName",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                  softWrap: true,
                ),
              ])
        ]));
  }

  Widget _buildTimeline( ) {
    final logs = controller.model.value.requestLogs ?? [];

    if (logs.isEmpty) {
      return const SizedBox.shrink();
    }
    return Expanded(
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
          nodePosition: 0,
          // color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
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
                      Text(
                        logs[index].statusNameEn ?? '',
                        
                        style: Get.textTheme.bodyLarge?.copyWith(fontSize: 16)
                      ),
                      const SizedBox(width: 8),
                      Text(
                        convertToKhmerTimeAgo(logs[index].createdDate),
                        style: Get.textTheme.bodySmall?.copyWith(
                              fontSize: 16.0,
                              color: Colors.black54,
                            ),
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
          // connectorBuilder: (_, index, ___) => SolidLineConnector(
          //   color: logs[index].status == LeaveStatus.approved.value
          //       ? AppTheme.primaryColor
          //       : null,
          // ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(Color color, IconData icon, double? position) {
    return OutlinedDotIndicator(
      position: position,
      borderWidth: 1.3,
      size: 16,
      color: color,
      child: Icon(
        icon,
        color: color,
        size: 12.0,
      ),
    );
  }

  List<Widget> actions() =>
      [IconButton(onPressed: () {}, icon: Icon(Icons.person_add))];

  Widget _buildTimelineContent(Log log) {
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
          SizedBox(width: 110, child: Text(title.tr)),
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
        Text(" staff name en kh"),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "controller.model.value.positionName ?? '',",
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

  Widget _buildRequestDetailsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadius,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: [
          _buildRequestDetails(),
          const SizedBox(height: 8),
          ...controller.model.value.attachments!
              .map(
                (Attachment attachment) => GestureDetector(
                  child: Column(
                    children: [
                      _buildInfo(
                        CupertinoIcons.doc,
                        '${'Attachment'.tr}:  ${attachment.name} ',
                        isLink: true,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  onTap: () async {
                    final Uri uri = Uri.parse(attachment.url);

                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode
                            .externalApplication, // Use external browser
                      );
                    } else {
                      throw 'Could not launch $uri';
                    }
                  },
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _actionButton(
      {required RequestStatusEnum status, bool isTaskUnassigned = false}) {
    if (isTaskUnassigned) {
      return ElevatedButton(
        child: Row(
          children: [const Icon(Icons.person_add_alt_1), Text("Assign".tr)],
        ),
        onPressed: () {},
      );
    }
    switch (status) {
      case RequestStatusEnum.pending:
        return ElevatedButton(
          child: Row(
            children: [const Icon(Icons.check), Text("Start task".tr)],
          ),
          onPressed: () {},
        );
      case RequestStatusEnum.inProgress:
        return ElevatedButton(
          child: Row(
            children: [const Icon(Icons.check), Text("Mark as complete".tr)],
          ),
          onPressed: () {},
        );
      case RequestStatusEnum.done:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRequestDetails() {
    final requestStatus = controller.model.value.status ?? 0;

    switch (requestStatus) {
      case RequestStatusEnum.pending:
        return _buildPendingInfo();
      // case RequestType.ot:

      //     _buildOtInfo();
      // case RequestType.exception:

      //   return _buildExceptionInfo();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPendingInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // _buildInfo(
            //   CupertinoIcons.bookmark,
            //   "controller.requestData.value?['leaveTypeName'] ",
            // ),

            Tag(
              text: controller.model.value.statusNameKh ?? '',
              color: Colors.red,
            ),

            //
            // Tag(
            //   text: controller.model.value.statusNameKh ?? '',
            //   color: Style.getStatusColor(controller.model.value.status ?? 0),
            // ),
          ],
        ),
        const SizedBox(height: 8),
        // Row(
        //   children: [
        //     Row(
        //       children: [
        //         const Icon(CupertinoIcons.calendar, size: 16),
        //         const SizedBox(width: 4),
        //         controller.requestData.value?['totalDays'] != null
        //             ? Tag(
        //                 color: Colors.black,
        //                 text: controller.requestData.value?['totalDays'] < 1
        //                     ? '${Const.numberFormat(controller.requestData.value?['totalHours']) ?? ''} ${'Hour'.tr}'
        //                     : '${Const.numberFormat(controller.requestData.value?['totalDays']) ?? ''} ${'Day'.tr}',
        //               )
        //             : const SizedBox(),
        //       ],
        //     ),
        //     const SizedBox(width: 4),
        //     Text(
        //       controller.requestData.value?['totalDays'] > 1
        //           ? '${convertToKhmerDate(DateTime.parse(controller.requestData.value?['fromDate'] ?? ''))} - ${convertToKhmerDate(DateTime.parse(controller.requestData.value?['toDate'] ?? ''))}'
        //           : convertToKhmerDate(DateTime.parse(
        //               controller.requestData.value?['fromDate'] ?? '')),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 8),
        // _buildInfo(CupertinoIcons.macwindow,
        // '${Const.numberFormat(controller.requestData.value?['balance'])} = ${Const.numberFormat(controller.requestData.value?['balance'] + controller.requestData.value?['totalDays'])} - ${Const.numberFormat(controller.requestData.value?['totalDays'])}'),
        const SizedBox(height: 8),
        // _buildInfo(CupertinoIcons.doc_plaintext,
        //     controller.requestData.value?['reason'] ?? ''),
      ],
    );
  }

  // Widget _buildOtInfo() {
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           _buildInfo(
  //             CupertinoIcons.bookmark,
  //             controller.requestData.value?['overTimeName'] ?? '',
  //           ),
  //           Tag(
  //             text: controller.model.value.statusNameKh ?? '',
  //             color: Style.getStatusColor(controller.model.value.status ?? 0),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 8),
  //       Row(
  //         children: [
  //           _buildInfo(
  //             CupertinoIcons.calendar,
  //             convertToKhmerDate(
  //               DateTime.parse(controller.requestData.value?['date']),
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 8),
  //       Row(
  //         children: [
  //           Row(
  //             children: [
  //               const Icon(CupertinoIcons.clock, size: 16),
  //               const SizedBox(width: 4),
  //               Tag(
  //                 color: Colors.black,
  //                 text:
  //                     '${Const.numberFormat(controller.requestData.value?['overtimeHour']!)} ${'Hour'.tr}',
  //               )
  //             ],
  //           ),
  //           const SizedBox(width: 8),
  //           Text(
  //             '${DateFormat('hh:mma').format(DateTime.parse(controller.requestData.value?['fromTime']))} - ${DateFormat('hh:mma').format(DateTime.parse(controller.requestData.value?['toTime']))}',
  //           ),
  //         ],
  //       ),
  //       if (controller.requestData.value?['note'] != null &&
  //           controller.requestData.value!['note'].toString().isNotEmpty) ...[
  //         const SizedBox(height: 8),
  //         _buildInfo(CupertinoIcons.doc_plaintext,
  //             controller.requestData.value?['note'] ?? ''),
  //       ],
  //     ],
  //   );
  // }

  // Widget _buildExceptionInfo() {
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Row(
  //             children: [
  //               controller.requestData.value?['exceptionTypeId'] ==
  //                       ExceptionType.absentException.value
  //                   ? _buildInfo(
  //                       CupertinoIcons.bookmark,
  //                       controller.requestData.value?['absentTypeNameKh'] ?? '',
  //                     )
  //                   : _buildInfo(
  //                       CupertinoIcons.bookmark,
  //                       controller.requestData.value?['exceptionTypeName'] ??
  //                           '',
  //                     ),
  //               const SizedBox(width: 8),
  //               controller.requestData.value?['exceptionTypeId'] ==
  //                       ExceptionType.missScan.value
  //                   ? Tag(
  //                       color: Colors.black,
  //                       text: controller.requestData.value?['scanTypeNameKh'] ??
  //                           '',
  //                     )
  //                   : const SizedBox.shrink(),
  //             ],
  //           ),
  //           Tag(
  //             text: controller.model.value.statusNameKh ?? '',
  //             color: Style.getStatusColor(controller.model.value.status ?? 0),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 8),
  //       controller.requestData.value?['exceptionTypeId'] ==
  //               ExceptionType.missScan.value
  //           ? Row(
  //               children: [
  //                 _buildInfo(
  //                     CupertinoIcons.calendar,
  //                     convertToKhmerDateTime(DateTime.parse(
  //                         controller.requestData.value?['requestedDate'] ??
  //                             ''))),
  //               ],
  //             )
  //           : Row(
  //               children: [
  //                 Row(
  //                   children: [
  //                     const Icon(CupertinoIcons.calendar, size: 16),
  //                     const SizedBox(width: 4),
  //                     Tag(
  //                       color: Colors.black,
  //                       text: controller.requestData.value?['totalDays'] < 1
  //                           ? '${Const.numberFormat(controller.requestData.value?['totalHours'])} ${'Hour'.tr}'
  //                           : '${Const.numberFormat(controller.requestData.value?['totalDays'])} ${'Day'.tr}',
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(width: 4),
  //                 Text(
  //                   controller.requestData.value?['totalDays'] > 1
  //                       ? '${convertToKhmerDate(DateTime.parse(controller.requestData.value?['fromDate'] ?? ''))} - ${convertToKhmerDate(DateTime.parse(controller.requestData.value?['toDate'] ?? ''))}'
  //                       : convertToKhmerDate(DateTime.parse(
  //                           controller.requestData.value?['fromDate'] ?? '')),
  //                 ),
  //               ],
  //             ),
  //       if (controller.requestData.value?['note'] != null &&
  //           controller.requestData.value!['note'].toString().isNotEmpty) ...[
  //         const SizedBox(height: 8),
  //         _buildInfo(CupertinoIcons.doc_plaintext,
  //             controller.requestData.value!['note'].toString())
  //       ],
  //     ],
  //   );
  // }

  Widget _buildInfo(IconData icon, String value, {bool isLink = false}) {
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
}
