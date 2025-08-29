import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/network_img.dart';

class TaskScreen extends BaseList<TaskModel> {
  TaskScreen({super.key});
  final TaskController controller = Get.put(TaskController());
  Timer? _debounce;

  @override
  RxList<TaskModel> get items => controller.list;

  @override
  String get title => 'Tasks';

  @override
  bool get fabButton => false;

  @override
  bool get isLoading => controller.loading.value;

  @override
  bool get isLoadingMore => controller.isLoadingMore.value;

  @override
  bool get canLoadMore => controller.canLoadMore.value;

  void dispose() {
    _debounce?.cancel();
  }

  @override
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
    controller.search();
  }

  @override
  Map<String, List<TaskModel>> groupItems(List<TaskModel> items) {
    return {"All": items};
  }

  @override
  Widget buildStickyList(List<TaskModel> items) {
    final groupedItems = groupItems(items);

    return Container(
      color: AppTheme.greyBg,
      padding: const EdgeInsets.only(top: 12),
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
              // separatorBuilder: (context, index) =>
              //     Container(height: 1, color: Colors.grey.shade100),
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
      child: InkWell(
        onTap: () {
          print(requestTime);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(item.requestNo ?? '',
                            style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(item.serviceItemName ?? '',
                            style: const TextStyle(fontSize: 14)),
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
                    Row(
                      children: [
                        item.roomNo != null
                            ? const Icon(Icons.location_on_outlined,
                                color: Colors.grey, size: 11)
                            : const SizedBox.shrink(),
                        const SizedBox(width: 4),
                        item.roomNo != null
                            ? Text((item.roomNo ?? '') + ", " + "Floor 001",
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey))
                            : const SizedBox.shrink(),
                      ],
                    ),
                    // TODO: GUEST NAME ( change to house staff name later, now use guest as placeholder )
                    Row(
                      children: [
                        const Icon(Icons.person_outline,
                            color: Colors.grey, size: 11),
                        const SizedBox(width: 4),
                        Text(item.guestName ?? '',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey)),
                      ],
                    ),

                    // REQUEST TIME
                    Row(
                      children: [
                        item.requestTime != null
                            ? const Icon(Icons.access_time,
                                color: Colors.grey, size: 11)
                            : const SizedBox.shrink(),
                        const SizedBox(width: 4),
                        item.requestTime != null
                            ? Text(requestTime!,
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey))
                            : const SizedBox.shrink(),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      NetworkImg(height: 16, src: item.statusImage),
                      const SizedBox(width: 4),
                      Text(item.statusNameEn ?? '',
                          style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // MyButton(
                  //   child: Row(
                  //     children: [
                  //       Icon(Icons.person_add_alt_1, size: 11),
                  //       SizedBox(width: 4),
                  //       Text("Assign".tr, style: TextStyle(fontSize: 11)),
                  //     ],
                  //   ),
                  //   label: '',
                  //   onPressed: () {},
                  //   width: 50,
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  // ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      minimumSize: const Size(30, 20),
                      tapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // shrink Material hitbox
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person_add_alt_1,
                            size: 11, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          "Assign".tr,
                          style:
                              const TextStyle(fontSize: 11), // shrink text too
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
