import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/task/task_op_screen.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';
import 'package:staff_view_ui/route.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';
import 'package:staff_view_ui/utils/widgets/network_img.dart';

class TaskScreen extends BaseList<TaskModel> {
  TaskScreen({super.key});
  final TaskController controller = Get.put(TaskController());
  final LookupController lookupController = Get.put(LookupController());
  Timer? _debounce;

  @override
  RxList<TaskModel> get items => controller.list;

  @override
  String get title => (Get.arguments != null && Get.arguments['title'] != null)
      ? Get.arguments['title']
      : "Tasks";

  @override
  bool get fabButton => false;

  @override
  bool get isLoading => controller.loading.value;

  @override
  bool get isLoadingMore => controller.isLoadingMore.value;

  @override
  bool get canLoadMore => controller.canLoadMore.value;

  @override
  Color get backgroundColor => AppTheme.greyBg;

  void dispose() {
    _debounce?.cancel();
  }

  @override
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
    controller.search();
    lookupController.fetchLookups(LookupTypeEnum.requestStatuses.value);
    controller.formGroup.reset();
  }

  @override
  Map<String, List<TaskModel>> groupItems(List<TaskModel> items) {
    return {"All": items};
  }

  @override
  Widget buildStickyList(List<TaskModel> items) {
    final groupedItems = groupItems(items);
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 0),
      child: CustomScrollView(
        slivers: groupedItems.entries.map((entry) {
          final section = entry.key;
          final items = entry.value;
          bool isLastSection(String section) {
            return section == groupedItems.entries.last.key;
          }

          return SliverStickyHeader(
            header: const SizedBox.shrink(),
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                if (index < items.length) {
                  return buildItem(items[index]);
                } else if (isLoadingMore && isLastSection(section)) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return null;
                }
              },
              itemCount: items.length +
                  (isLoadingMore && isLastSection(section) ? 1 : 0),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget buildItem(TaskModel item) {
    String? requestTime = item.requestTime != null
        ? DateFormat("dd-MM-yyyy hh:mm a").format(item.requestTime!)
        : null;
    final AuthController authController = Get.find<AuthController>();
    final HousekeepingController housekeepingController =
        Get.find<HousekeepingController>();

    setRoom() {
      Housekeeping selected = housekeepingController.list
          .firstWhere((r) => r.roomId == item.roomId);
      housekeepingController.selected.assignAll([selected]);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: AppTheme.borderRadius, color: Colors.white),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: AppTheme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            print('item with id: ${item.id}');
            Get.toNamed(RouteName.requestLog, arguments: {'id': item.id});
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(item.requestNo ?? '',
                              style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(item.serviceItemName ?? '',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 14),  
                      if (item.note != null && item.note!.isNotEmpty)
                        Row(
                          children: [
                            Text(item.note!,
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                          ],
                        ),

                      Row(
                        children: [
                          item.roomNo != null
                              ? const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey)
                              : const SizedBox.shrink(),
                          const SizedBox(width: 4),
                          item.roomNo != null
                              ? Text("${item.roomNo ?? ''}, Floor 001",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))
                              : const SizedBox.shrink(),
                        ],
                      ),
                      // TODO: GUEST NAME ( change to house staff name later, now use guest as placeholder )
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              color: Colors.grey, size: 12),
                          const SizedBox(width: 4),
                          Text(item.guestName ?? '',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),

                      Row(
                        children: [
                          item.requestTime != null
                              ? const Icon(Icons.access_time,
                                  color: Colors.grey, size: 12)
                              : const SizedBox.shrink(),
                          const SizedBox(width: 4),
                          item.requestTime != null
                              ? Text(requestTime!,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey))
                              : const SizedBox.shrink(),
                        ],
                      )
                    ],
                  ),
                ),
                Column( 
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                        children: [
                          NetworkImg(height: 16, src: item.statusImage),
                          const SizedBox(width: 4),
                          Text(item.statusNameEn ?? '',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                   
                    const SizedBox(height: 60), 

                    item.status == RequestStatus.pending.value &&
                            authController.role.value == RoleEnum.manager.value
                        // && item.staffId == null
                        ? GestureDetector(
                            onTap: () {
                              setRoom();
                              controller.formGroup.patchValue({'id': item.id});
                              Modal.showFormDialog(TaskOpScreen(), height: 525);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person_add_alt_1,
                                    size: 12, color: Colors.blue),
                                const SizedBox(width: 4),
                                Text(
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue),
                                  "Assign".tr,
                                )
                              ],
                            ))
                        : const SizedBox.shrink(),

                    // Assigned task
                    item.status == RequestStatus.pending.value &&
                            authController.role.value != RoleEnum.manager.value
                        // && item.staffId == null
                        ? _buildActionButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.play_arrow,
                                  size: 14,
                                  color: Color.fromARGB(255, 40, 95, 42),
                                ),
                                const SizedBox(width: 4),
                                Text("Start".tr)
                              ],
                            ),
                            outlined: true,
                            color: const Color.fromARGB(255, 40, 95, 42),
                            onPressed: () {
                              // housekeepingController.selected
                              setRoom();
                              //  Housekeeping selected = housekeepingController.list.firstWhere((r) => r.roomId == item.roomId);
                              //     housekeepingController.selected.assignAll([selected]);
                              controller.formGroup.patchValue({'id': item.id});
                              Modal.showFormDialog(TaskOpScreen(), height: 525);
                            })
                        : const SizedBox.shrink(),
                    // task started
                    item.status == RequestStatus.inProgress.value
                        ? _buildActionButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_box_outlined,
                                  size: 14,
                                  color: Color.fromARGB(255, 58, 136, 61),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Complete".tr,
                                )
                              ],
                            ),
                            outlined: true,
                            color: const Color.fromARGB(255, 58, 136, 61),
                            onPressed: () {
                              setRoom();
                              controller.formGroup.patchValue({'id': item.id});
                              Modal.showFormDialog(TaskOpScreen(), height: 525);
                            })
                        : const SizedBox.shrink(),
                    // task completed
                    // item.status == RequestStatus.done.value  ||
                    item.status == RequestStatus.cancel.value
                        ? _buildActionButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.restart_alt_outlined,
                                  size: 14,
                                  color: Color.fromARGB(255, 236, 150, 21),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Reopen".tr,
                                )
                              ],
                            ),
                            color: const Color.fromARGB(255, 236, 150, 21),
                            outlined: true,
                            onPressed: () {
                              setRoom();
                              controller.formGroup.patchValue({'id': item.id});
                              Modal.showFormDialog(TaskOpScreen(), height: 525);
                            })
                        : const SizedBox.shrink()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget headerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildFilterButtons()],
    );
  }

  Widget _buildFilterButtons() {
    // final LookupController lookupController = Get.put(LookupController());
    return Obx(() {
      if (lookupController.isLoading.value) {
        return Skeletonizer(
          child: SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadius,
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text('All'.tr),
                ),
              ),
            ),
          ),
        );
      }

      if (lookupController.taskStatusList.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        height: 32,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lookupController.taskStatusList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Obx(() {
                  final isSelected =
                      controller.taskStatus.value == 0; // assume 0 means all
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      shadowColor: Colors.transparent,
                      backgroundColor: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                      // side: BorderSide(
                      //   color: Theme.of(context).colorScheme.primary,
                      // ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                    ),
                    onPressed: () {
                      controller.taskStatus.value = 0; // reset filter
                      controller.search();
                    },
                    child: Text("${"All".tr} (${controller.list.length})"),
                  );
                }),
              );
            }

            final lookupItem = lookupController.taskStatusList[index - 1];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                final isSelected =
                    controller.taskStatus.value == lookupItem.valueId;
                final count = controller.list
                    .where((req) => req.status == lookupItem.valueId)
                    .length;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    shadowColor: Colors.transparent,
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    // side: BorderSide(
                    //   color: Theme.of(context).colorScheme.primary,
                    // ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                  ),
                  onPressed: () {
                    controller.taskStatus.value = lookupItem.valueId!;
                    controller.search();
                  },
                  child: Row(
                    children: [
                      NetworkImg(height: 18, src: lookupItem.image),
                      SizedBox(width: 4),
                      Text("${lookupItem.nameEn ?? ''} (${count})"),
                    ],
                  ),
                );
              }),
            );
          },
        ),
      );
    });
  }

  Widget _buildBottomSheet() {
    return Column(children: [Text("Bottom Sheet")]);
  }

  Widget _buildActionButton(
      {required Widget child,
      required VoidCallback onPressed,
      required Color color,
      bool outlined = false}) {
    final ButtonStyle style = outlined
        ? OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color, width: 1.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )
        : ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );

    return SizedBox(
      height: 32,
      width: 100,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: style,
              child: child,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: style,
              child: child,
            ),
    );
  }

  @override
  Widget buildHeaderWidget() {
    return Container(
      width: double.infinity,
      // height: 35,
      decoration: BoxDecoration(
        borderRadius: AppTheme.borderRadius,
      ),
      padding: const EdgeInsets.only(left: 8, top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: headerWidget(),
      ),
    );
  }
}
