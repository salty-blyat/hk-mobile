import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/pages/leave/operation/leave_operation_screen.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';

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
        onPressed: () {
          Get.to(() => LeaveOperationScreen());
        },
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add),
      ),
      appBar: AppBar(
        title: Text(
          'Leave'.tr,
          style: context.textTheme.titleLarge!.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(
        () => controller.loading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return Container(
                    color: Colors.grey.shade300,
                    width: double.infinity,
                    height: 1,
                  );
                },
                itemBuilder: (context, index) {
                  var lists = controller.lists[index];
                  return Slidable(
                    key: Key(lists.id.toString()),
                    enabled: lists.status == LeaveStatus.pending.value,
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            Get.to(() => LeaveOperationScreen(id: lists.id!));
                          },
                          icon: Icons.edit_square,
                          label: 'Edit'.tr,
                          backgroundColor: AppTheme.primaryColor,
                        ),
                        SlidableAction(
                          onPressed: (context) {},
                          icon: CupertinoIcons.delete_solid,
                          label: 'Delete'.tr,
                          backgroundColor: AppTheme.dangerColor,
                        ),
                      ],
                    ),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      leading: Calendar(
                        date: lists.requestedDate!,
                      ),
                      subtitle: Text(
                        lists.reason!,
                        overflow: TextOverflow.ellipsis,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(lists.leaveTypeName!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                              const SizedBox(width: 10),
                              Tag(
                                color: Colors.black,
                                text: lists.totalDays! >= 1
                                    ? '${lists.totalDays.toString()} ${'Day'.tr}'
                                    : '${lists.totalHours.toString()} ${'Hour'.tr}',
                              )
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(lists.requestNo!,
                              style: context.textTheme.bodySmall!
                                  .copyWith(color: Colors.black)),
                          Tag(
                            color: lists.status == LeaveStatus.approved.value
                                ? AppTheme.successColor
                                : lists.status == LeaveStatus.rejected.value
                                    ? AppTheme.dangerColor
                                    : lists.status ==
                                            LeaveStatus.processing.value
                                        ? AppTheme.primaryColor
                                        : AppTheme.warningColor,
                            text: lists.statusNameKh!.toString(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: controller.lists.length,
              ),
      ),
    );
  }
}
