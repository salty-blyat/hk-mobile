import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/request_model.dart';
import 'package:staff_view_ui/pages/request/history/request_history_controller.dart';
import 'package:staff_view_ui/pages/request/request_controller.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/style.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';

class RequestHistoryScreen extends BaseList<RequestModel> {
  RequestHistoryScreen({super.key});

  final RequestHistoryController controller =
      Get.put(RequestHistoryController());

  @override
  String get title => 'Request/Approve History'.tr;

  @override
  bool get isLoading => controller.loading.value;

  @override
  bool get canLoadMore => controller.canLoadMore.value;

  @override
  bool get isLoadingMore => controller.isLoadingMore.value;

  @override
  bool get fabButton => false;

  @override
  Future<void> onLoadMore() async {
    await controller.onLoadMore();
  }

  @override
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
    await controller.refreshData();
  }

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
        YearSelect(
          onYearSelected: (year) {
            controller.year.value = year;
            controller.lists.value = [];
            onRefresh();
          },
        ),
        Container(
          height: 45,
          margin: const EdgeInsets.only(top: 0, bottom: 10),
          child: _buildRequestTypeSelect(),
        ),
      ],
    );
  }

  @override
  Widget buildItem(RequestModel item) {
    var requestData = jsonDecode(item.requestData ?? '');
    return ListTile(
      onTap: () => Get.toNamed('/request-view', arguments: {
        'id': item.id,
        'reqType': 0,
      }),
      titleAlignment: ListTileTitleAlignment.center,
      leading: Calendar(date: item.requestedDate!),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title!,
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.bodyMedium!.copyWith(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          Text(
            requestData['reason'] ?? requestData['note'] ?? '',
            overflow: TextOverflow.ellipsis,
            style: Get.textTheme.bodyMedium!.copyWith(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
      title: Row(
        children: [
          Text(
            item.staffNameKh ?? item.staffNameEn ?? '',
            style: Get.textTheme.titleMedium!.copyWith(
              fontSize: 14,
              color: Colors.black,
              fontFamilyFallback: ['Gilroy', 'Kantumruy'],
            ),
          ),
          Text(
            '  ${item.requestTypeName!.tr}',
            style: Get.textTheme.titleMedium!.copyWith(
              fontSize: 14,
              color: Get.theme.colorScheme.primary,
              fontFamilyFallback: const ['Gilroy', 'Kantumruy'],
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
            color: Style.getStatusColor(item.status ?? 0),
            text: item.statusName!.tr,
          ),
        ],
      ),
    );
  }

  @override
  RxList<RequestModel> get items => controller.lists;

  Widget _buildRequestTypeSelect() {
    List<int> requestValues = [
      0,
      ...REQUEST_TYPE.values.map((type) => type.value)
    ];

    return Obx(() => ListView(
          scrollDirection: Axis.horizontal,
          children: requestValues.map((value) {
            String title = value == 0
                ? "All"
                : REQUEST_TYPE.values
                    .firstWhere((type) => type.value == value)
                    .name;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton(
                onPressed: () {
                  controller.selectedRequestType.value = value;

                  onRefresh();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  backgroundColor: controller.selectedRequestType.value == value
                      ? AppTheme.primaryColor
                      : Colors.white,
                  foregroundColor: controller.selectedRequestType.value == value
                      ? Colors.white
                      : Colors.black,
                  side: const BorderSide(
                    color: AppTheme.primaryColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.borderRadius,
                  ),
                ),
                child: Text(
                  title.tr,
                ),
              ),
            );
          }).toList(),
        ));
  }
}
