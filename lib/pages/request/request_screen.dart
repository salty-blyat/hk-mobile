import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/request_model.dart';
import 'package:staff_view_ui/pages/request/history/request_history_screen.dart';
import 'package:staff_view_ui/pages/request/request_controller.dart';
import 'package:staff_view_ui/pages/request/view/request_view_screen.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/style.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';

class RequestApproveScreen extends BaseList<RequestModel> {
  RequestApproveScreen({super.key});

  final RequestApproveController controller =
      Get.put(RequestApproveController());

  @override
  String get title => 'Request/Approve';

  @override
  bool get isLoading => controller.loading.value;

  @override
  bool get isLoadingMore => controller.isLoadingMore.value;

  @override
  bool get canLoadMore => controller.canLoadMore.value;

  @override
  bool get fabButton => false;

  @override
  RxList<RequestModel> get items => controller.lists;

  @override
  Future<void> onLoadMore() async {
    await controller.onLoadMore();
  }

  @override
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
    controller.search();
  }

  @override
  List<Widget> actions() => [
        IconButton(
          onPressed: () {
            Get.to(() => RequestHistoryScreen());
          },
          icon: const Icon(Icons.history),
        ),
      ];

  @override
  Map<String, List<RequestModel>> groupItems(List<RequestModel> items) {
    return items.fold<Map<String, List<RequestModel>>>({}, (grouped, request) {
      final month = getMonth(request.requestedDate!);
      grouped.putIfAbsent(month, () => []).add(request);
      return grouped;
    });
  }

  @override
  Widget headerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.borderRadius,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Pending'.tr.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamilyFallback: ['Gilroy', 'Kantumruy'],
            ),
          ),
        ),
        Container(
          height: 65,
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildRequestTypeItem(),
        ),
      ],
    );
  }

  @override
  Widget buildItem(RequestModel item) {
    var requestData = jsonDecode(item.requestData ?? '');
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      titleTextStyle: Get.textTheme.titleMedium!.copyWith(
        color: Colors.black,
        fontSize: 14,
      ),
      subtitleTextStyle: Get.textTheme.bodyMedium!.copyWith(
        color: Colors.black,
        fontSize: 12,
      ),
      leading: Calendar(date: item.requestedDate!),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title!,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          Text(
            requestData['reason'] ?? requestData['note'] ?? '',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
      title: Row(
        children: [
          Text(
            item.staffNameKh ?? item.staffNameEn!,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.requestTypeName!.tr,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.titleMedium!.copyWith(
              color: Get.theme.colorScheme.primary,
              fontSize: 14,
            ),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.requestNo!,
            style: Get.textTheme.bodySmall!.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 12),
          Tag(
            color: Style.getStatusColor(item.status!),
            text: item.statusNameKh!,
          ),
        ],
      ),
      onTap: () {
        Get.to(() => RequestViewScreen(),
            arguments: {'id': item.id!, 'reqType': 0});
      },
    );
  }

  Widget _buildRequestTypeItem() {
    return Obx(() {
      List<int> requestValues = [
        0, // This will represent the "Total" button
        ...REQUEST_TYPE.values.map((type) => type.value)
      ];

      // Total counts for the "Total" button
      int totalCount = controller.totalLeave.value +
          controller.totalOT.value +
          controller.totalException.value;

      return ListView(
        scrollDirection: Axis.horizontal,
        children: requestValues.map((value) {
          String title = "";
          int count = 0;

          if (value == 0) {
            // Special case for "Total"
            title = "Total";
            count = totalCount;
          } else {
            // Standard request types (Leave, OT, Exception)
            title = REQUEST_TYPE.values
                .firstWhere((type) => type.value == value)
                .name;
            switch (
                REQUEST_TYPE.values.firstWhere((type) => type.value == value)) {
              case REQUEST_TYPE.Leave:
                count = controller.totalLeave.value;
                break;
              case REQUEST_TYPE.OT:
                count = controller.totalOT.value;
                break;
              case REQUEST_TYPE.Exception:
                count = controller.totalException.value;
                break;
            }
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () {
                controller.selectedRequestType.value = value;
                onRefresh();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: AppTheme.borderRadius,
                ),
                backgroundColor: controller.selectedRequestType.value == value
                    ? AppTheme.primaryColor
                    : AppTheme.secondaryColor,
                foregroundColor: controller.selectedRequestType.value == value
                    ? Colors.white
                    : Colors.black,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 70),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        count.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        title.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
