import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/exception_model.dart';
import 'package:staff_view_ui/pages/exception/exception_controller.dart';
import 'package:staff_view_ui/pages/exception_type/exception_type_controller.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/style.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/custom_slide_button.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';

class ExceptionScreen extends BaseList<ExceptionModel> {
  ExceptionScreen({super.key});

  final ExceptionController controller = Get.put(ExceptionController());
  final ExceptionTypeController exceptionTypeController =
      Get.put(ExceptionTypeController());

  @override
  String get title => 'Exception';

  @override
  bool get isLoading => controller.loading.value;

  @override
  bool get isLoadingMore => controller.isLoadingMore.value;

  @override
  bool get canLoadMore => controller.canLoadMore.value;

  @override
  RxList<ExceptionModel> get items => controller.lists;

  @override
  Future<void> onLoadMore() async {
    await controller.onLoadMore();
  }

  @override
  void onFabPressed() {
    Get.toNamed('/exception-operation', arguments: {
      'id': 0,
    });
  }

  @override
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
    controller.search();
  }

  @override
  Map<String, List<ExceptionModel>> groupItems(List<ExceptionModel> items) {
    return items.fold<Map<String, List<ExceptionModel>>>({},
        (grouped, exception) {
      final month = getMonth(exception.fromDate!);
      grouped.putIfAbsent(month, () => []).add(exception);
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
            onRefresh();
          },
        ),
        _buildExceptionTypeButtons()
      ],
    );
  }

  @override
  Widget buildItem(ExceptionModel item) {
    return Slidable(
      key: Key(item.id.toString()),
      enabled: item.status == LeaveStatus.pending.value,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          CustomSlideButton(
            onPressed: () {
              Get.toNamed('/exception-operation', arguments: {
                'id': item.id,
              });
            },
            label: 'Edit',
            icon: Icons.edit_square,
            color: AppTheme.primaryColor,
          ),
          CustomSlideButton(
            onPressed: () {
              controller.delete(item.id!);
            },
            label: 'Delete',
            icon: CupertinoIcons.delete_solid,
            color: AppTheme.dangerColor,
          ),
        ],
      ),
      child: ListTile(
        onTap: () => Get.toNamed('/request-view', arguments: {
          'id': item.id,
          'reqType': 3,
        }),
        titleAlignment: ListTileTitleAlignment.center,
        leading: Calendar(date: item.fromDate!),
        subtitle: Text(
          item.absentTypeNameKh ?? '',
          overflow: TextOverflow.ellipsis,
        ),
        title: Row(
          children: [
            Text(
              item.exceptionTypeName!.tr,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: Get.theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Tag(
              color: Colors.black,
              text: item.totalDays! >= 1
                  ? '${Const.numberFormat(item.totalDays ?? 0)} ${'Day'.tr}'
                  : '${Const.numberFormat(item.totalHours ?? 0)} ${'Hour'.tr}',
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
              text: item.statusNameKh!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExceptionTypeButtons() {
    return Obx(() {
      if (exceptionTypeController.isLoading.value) {
        return Skeletonizer(
          child: SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('Exception'),
                ),
              ),
            ),
          ),
        );
      }

      if (exceptionTypeController.exceptionTypes.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        height: 45,
        margin: const EdgeInsets.only(top: 0, bottom: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: exceptionTypeController.exceptionTypes.length,
          itemBuilder: (context, index) {
            final exceptionType = exceptionTypeController.exceptionTypes[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                final isSelected =
                    controller.exceptionType.value == exceptionType.id;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    controller.exceptionType.value = exceptionType.id!;
                    controller.search();
                  },
                  child: Text(exceptionType.name ?? ''),
                );
              }),
            );
          },
        ),
      );
    });
  }
}
