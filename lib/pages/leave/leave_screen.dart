import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/pages/leave/operation/leave_operation_screen.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/style.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';

enum LeaveStatus {
  pending(74),
  approved(75),
  rejected(76),
  processing(77),
  removed(78);

  final int value;
  const LeaveStatus(this.value);
}

class LeaveScreen extends StatelessWidget {
  LeaveScreen({super.key});

  final LeaveController controller = Get.put(LeaveController());

  @override
  Widget build(BuildContext context) {
    controller.search();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => LeaveOperationScreen()),
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add),
      ),
      appBar: AppBar(
        title: Text(
          'Leave'.tr,
          style: context.textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _buildYearSelector(),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.lists.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.clear_circled,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Not found'.tr,
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              }

              return _buildStickyLeaveList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelector() {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.only(left: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: YearSelect(
          onYearSelected: (year) {
            controller.year.value = year;
            controller.search();
          },
        ),
      ),
    );
  }

  Widget _buildStickyLeaveList() {
    // Group the leave requests by month
    final groupedLeaves = _groupLeavesByMonth(controller.lists);

    return RefreshIndicator(
      onRefresh: () async {
        controller.search();
      },
      child: CustomScrollView(
        slivers: groupedLeaves.entries.map((entry) {
          final month = entry.key;
          final leaves = entry.value;

          return SliverStickyHeader(
            header: _buildStickyHeader(month),
            sliver: SliverList.separated(
              itemBuilder: (context, index) {
                final leave = leaves[index];
                return _buildLeaveItem(leave);
              },
              separatorBuilder: (context, index) => Container(
                color: Colors.grey.shade300,
                width: double.infinity,
                height: 1,
              ),
              itemCount: leaves.length,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStickyHeader(String month) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        month.tr,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildLeaveItem(leave) {
    return Slidable(
      key: Key(leave.id.toString()),
      enabled: leave.status == LeaveStatus.pending.value,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          _CustomSlideButton(
            onPressed: () {
              Get.to(() => LeaveOperationScreen(id: leave.id));
            },
            label: 'Edit',
            icon: Icons.edit_square,
            color: AppTheme.primaryColor,
          ),
          _CustomSlideButton(
            onPressed: () {
              controller.delete(leave.id!);
            },
            label: 'Delete',
            icon: CupertinoIcons.delete_solid,
            color: AppTheme.dangerColor,
          ),
        ],
      ),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        leading: Calendar(date: leave.fromDate!),
        subtitle: Text(
          leave.reason!,
          overflow: TextOverflow.ellipsis,
        ),
        title: Row(
          children: [
            Text(
              leave.leaveTypeName!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: Get.theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Tag(
              color: Colors.black,
              text: leave.totalDays! >= 1
                  ? '${Const.numberFormat(leave.totalDays ?? 0)} ${'Day'.tr}'
                  : '${Const.numberFormat(leave.totalHours ?? 0)} ${'Hour'.tr}',
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              leave.requestNo!,
              style: Get.textTheme.bodySmall!.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 12),
            Tag(
              color: Style.getStatusColor(leave.status),
              text: leave.statusNameKh!,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<dynamic>> _groupLeavesByMonth(List<dynamic> leaves) {
    final Map<String, List<dynamic>> grouped = {};

    for (var leave in leaves) {
      final month = getMonth(leave.fromDate!);
      grouped.putIfAbsent(month, () => []).add(leave);
    }

    return grouped;
  }
}

class _CustomSlideButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  const _CustomSlideButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SizedBox.expand(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Text(
                label.tr,
                style: Get.textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
