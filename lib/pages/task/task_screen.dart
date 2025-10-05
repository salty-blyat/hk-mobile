import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/staff_user/staff_user_controller.dart';
import 'package:staff_view_ui/pages/task/operation/task_op_controller.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';
import 'package:staff_view_ui/route.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/network_img.dart';

class TaskScreen extends BaseList<TaskModel> {
  TaskScreen({super.key});
  final TaskController controller = Get.put(TaskController());
  final LookupController lookupController = Get.put(LookupController());
  final StaffUserController staffUserController = Get.put(StaffUserController());
  final TaskOPController taskOpController = Get.put(TaskOPController());
  Rx<ClientInfo?> auth = Rxn<ClientInfo>();
  Timer? _debounce;

  @override
  RxList<TaskModel> get items => controller.list;

  @override
  RxBool get showDrawer => (staffUserController.staffUser.value?.positionId != PositionEnum.manager.value)
      .obs;

  @override
  List<Widget> actions() => [
        if (Get.arguments != null &&
            Get.arguments['title'] != null &&
            Get.arguments['title'] != '')
          Container(
              margin: const EdgeInsets.only(right: 12),
              child: Text(
                "${Get.arguments['title']}",
                style: Get.textTheme.titleLarge!.copyWith(color: Colors.white),
              )),
      ];

  @override
  bool get isCenterTitle => false;

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
    await controller.search();
    // await lookupController.fetchLookups(LookupTypeEnum.requestStatuses.value);
    taskOpController.formGroup.reset();

  }

  @override
  Widget titleWidget() {
    return Obx(() {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          (staffUserController.staffUser.value != null
                  ? staffUserController.staffUser.value?.staffName
                  : controller.auth.value.fullName) ??
              '-',
          style: Get.textTheme.titleLarge!.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          children: [
            staffUserController.staffUser.value != null
                ? Text(
                    "${'Position'.tr}: ${staffUserController.staffUser.value?.positionName}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.normal))
                : const SizedBox.shrink(),
            staffUserController.staffUser.value != null
                ? const SizedBox(
                    width: 8,
                  )
                : const SizedBox.shrink(),
          ],
        )
      ]);
    });
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.requestNo ?? '',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 11)),
                          Row(children: [
                            NetworkImg(height: 16, src: item.statusImage),
                            const SizedBox(width: 4),
                            Text(
                                Get.locale?.languageCode == 'en'
                                    ? item.statusNameEn ?? ''
                                    : item.statusNameKh ?? '',
                                style: const TextStyle(fontSize: 12)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.serviceItemName ?? '',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      if (item.note != null && item.note!.isNotEmpty)
                        Row(
                          children: [
                            Text(item.note!,
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          item.roomNo != null
                              ? const Icon(Icons.location_on_outlined,
                                  size: 12, color: Colors.grey)
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
                      item.staffId != 0
                          ? Row(
                              children: [
                                const Icon(Icons.person_outline,
                                    color: Colors.grey, size: 12),
                                const SizedBox(width: 4),
                                Text(item.staffName ?? 'Unassigned'.tr,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            )
                          : const SizedBox.shrink(),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Colors.grey, size: 12),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(requestTime!,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                                _buildButton(item)
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(TaskModel task) {
    if (task.status == RequestStatusEnum.done.value ||
        task.status == RequestStatusEnum.cancel.value) {
      return const SizedBox.shrink();
    }

    if (task.status == RequestStatusEnum.inProgress.value) {
      return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            minimumSize: const Size(0, 28),
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          onPressed: () {
            print('asdf');
          },
          child: Row(
            children: [
              const Icon(
                Icons.play_arrow_rounded,
                size: 12,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text("Start".tr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ))
            ],
          ));
    }

    return GestureDetector(
        onTap: () => {print('asdfdasfdas')},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.person_add,
                color: AppTheme.primaryColor, size: 12),
            const SizedBox(width: 4),
            Text("Assign".tr,
                style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                    color: AppTheme.primaryColor))
          ],
        ));
  }

  @override
  Widget headerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildFilterButtons()],
    );
  }

  Widget _buildFilterButtons() {
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
      return SizedBox(
        height: 32,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: lookupController.taskStatusList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Obx(() {
                  final isSelected = controller.taskStatus.value == 0;
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
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                    ),
                    onPressed: () async {
                      controller.taskStatus.value = 0;
                      await controller.search();
                    },
                    child: Text("All".tr),
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
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                  ),
                  onPressed: () async {
                    controller.taskStatus.value = lookupItem.valueId!;
                    await controller.search();
                  },
                  child: Row(
                    children: [
                      NetworkImg(height: 18, src: lookupItem.image),
                      const SizedBox(width: 4),
                      Text(Get.locale?.languageCode == 'en'
                          ? lookupItem.nameEn ?? ''
                          : lookupItem.name ?? ''),
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
  // Widget _buildTaskStatusBadge(Lookup)

  @override
  Widget buildHeaderWidget() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(color: AppTheme.primaryColor),
          child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.5, color: Colors.grey.shade50),
                color: const Color(0xff177b80),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Task Overview'.tr,
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade50,
                          fontWeight: FontWeight.w500)),
                  Obx(
                    () => Text(
                      controller.taskSummary.value,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  )
                ],
              )),
        ),
        Container(
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
        )
      ],
    );
  }
}
