import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/leave_model.dart';
import 'package:staff_view_ui/pages/leave_balance/leave_balace_controller.dart';
import 'package:staff_view_ui/pages/leave_balance/leave_balace_select.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/pages/leave/operation/leave_operation_screen.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/style.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/custom_slide_button.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';

class LeaveScreen extends BaseList<Leave> {
  LeaveScreen({super.key});

  final LeaveController controller = Get.put(LeaveController());
  final LeaveBalanceController leaveBalanceController =
      Get.put(LeaveBalanceController());

  @override
  String get title => 'Leave';

  @override
  bool get isLoading => controller.loading.value;

  @override
  bool get isLoadingMore => controller.isLoadingMore.value;

  @override
  bool get canLoadMore => controller.canLoadMore.value;

  @override
  RxList<Leave> get items => controller.lists;

  @override
  Future<void> onLoadMore() async {
    await controller.onLoadMore();
  }

  @override
  void onFabPressed() {
    Get.to(() => LeaveOperationScreen(), arguments: {
      'id': 0,
    });
  }

  @override
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
    controller.search();
  }

  @override
  Map<String, List<Leave>> groupItems(List<Leave> items) {
    return items.fold<Map<String, List<Leave>>>({}, (grouped, leave) {
      final month = getMonth(leave.fromDate!);
      grouped.putIfAbsent(month, () => []).add(leave);
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
            leaveBalanceController.year.value = year;
            leaveBalanceController.getLeaveBalance();
            onRefresh();
          },
        ),
        LeaveBalaceSelect(
          selectedId: controller.leaveTypeId,
          onPressed: (leaveTypeId) {
            controller.leaveTypeId.value = leaveTypeId;
            onRefresh();
          },
        ),
      ],
    );
  }

  @override
  Widget buildItem(Leave item) {
    return Slidable(
      key: Key(item.id.toString()),
      enabled: item.status == LeaveStatus.pending.value,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          CustomSlideButton(
            onPressed: () {
              Get.to(() => LeaveOperationScreen(), arguments: {
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
          'reqType': 1,
        }),
        titleAlignment: ListTileTitleAlignment.center,
        leading: Calendar(date: item.fromDate!),
        subtitle: Text(
          item.reason!,
          overflow: TextOverflow.ellipsis,
        ),
        title: Row(
          children: [
            Text(
              item.leaveTypeName!,
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
}
