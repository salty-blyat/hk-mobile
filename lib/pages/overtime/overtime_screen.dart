import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/overtime_model.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/pages/overtime/operation/overtime_operation_screen.dart';
import 'package:staff_view_ui/pages/overtime/overtime_controller.dart';
import 'package:staff_view_ui/pages/overtime/overtime_type/overtime_type_controller.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/style.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/custom_slide_button.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';

// ignore: must_be_immutable
class OvertimeScreen extends BaseList<Overtime> {
  OvertimeScreen({super.key});

  final OvertimeController controller = Get.put(OvertimeController());
  final OvertimeTypeController overtimeTypeController =
      Get.put(OvertimeTypeController());

  @override
  String get title => 'Overtime';

  @override
  bool get isLoading => controller.loading.value;

  @override
  bool get isLoadingMore => controller.isLoadingMore.value;

  @override
  bool get canLoadMore => controller.canLoadMore.value;

  @override
  bool get fabButton => true;

  @override
  void onFabPressed() {
    Get.to(() => OvertimeOperationScreen());
  }

  @override
  RxList<Overtime> get items => controller.lists;

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
  Map<String, List<Overtime>> groupItems(List<Overtime> items) {
    return items.fold<Map<String, List<Overtime>>>({}, (grouped, overtime) {
      final month = getMonth(overtime.fromTime!); // Seem Wrong
      grouped.putIfAbsent(month, () => []).add(overtime);
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
        // _buildOvertimeTypeButtons()
      ],
    );
  }

  @override
  Widget buildItem(Overtime item) {
    return Slidable(
      key: Key(item.id.toString()),
      enabled: item.status == LeaveStatus.pending.value,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          CustomSlideButton(
            onPressed: () {
              print(item.id);
              Get.to(() => OvertimeOperationScreen(id: item.id ?? 0));
            },
            label: 'Edit',
            icon: Icons.edit_square,
            color: AppTheme.primaryColor,
          ),
          CustomSlideButton(
            onPressed: () {
              // controller.delete(item.id!);
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
          'reqType': 2,
        }),
        titleAlignment: ListTileTitleAlignment.center,
        leading: Calendar(date: item.date!),
        subtitle: Text(
          item.note ?? "",
          overflow: TextOverflow.ellipsis,
        ),
        title: Row(
          children: [
            Text(
              item.overtimeTypeName!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: Get.theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Tag(
              color: Colors.black,
              text: '${Const.numberFormat(item.overtimeHour!)} ${'Hour'.tr}',
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

  Widget _buildOvertimeTypeButtons() {
    return Obx(() {
      if (overtimeTypeController.isLoading.value) {
        return Skeletonizer(
          child: SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    // controller.calculateTotalDays();
                  },
                  child: const Text('Leave'),
                ),
              ),
            ),
          ),
        );
      }

      if (overtimeTypeController.lists.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        height: 45,
        margin: const EdgeInsets.only(top: 0, bottom: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: overtimeTypeController.lists.length,
          itemBuilder: (context, index) {
            final overtimeType = overtimeTypeController.lists[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                final isSelected =
                    controller.overtimeType.value == overtimeType.id;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  // onPressed: () => controller.updateLeaveType(overtimeType.id!),
                  onPressed: () {},
                  child: Text(overtimeType.name ?? ''),
                );
              }),
            );
          },
        ),
      );
    });
  }
}
