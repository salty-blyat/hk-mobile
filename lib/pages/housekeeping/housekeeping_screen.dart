import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/models/lookup_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/task/create_task_screen.dart';
import 'package:staff_view_ui/route.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';
import 'package:staff_view_ui/utils/widgets/network_img.dart';

class HousekeepingScreen extends BaseList<Housekeeping> {
  HousekeepingScreen({super.key});

  final HousekeepingController controller = Get.put(HousekeepingController());
  final LookupController lookupController = Get.put(LookupController());

  Timer? _debounce;

  @override
  String get title => 'Housekeeping';
  @override
  bool get fabButton => false;
  @override
  bool get isCenterTitle => false;

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
  RxList<Housekeeping> get items => controller.list;
  @override
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
    controller.selected.clear();
    controller.search();
  }

  Widget buildStickyHeader(String section, int itemCount, int sectionId) {
    List<Housekeeping> select =
        controller.list.where((e) => e.floorId == sectionId).toList();
    List<Housekeeping> selected =
        controller.selected.where((e) => e.floorId == sectionId).toList();
    Function? onTap() {
      if (select.length == selected.length) {
        controller.selected.removeWhere((e) => e.floorId == sectionId);
      } else {
        controller.selected.assignAll({
          ...controller.selected,
          ...select,
        });
      }
      return null;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      // color: Colors.white,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey.shade100, blurRadius: 4, spreadRadius: 1)
      ]),
      child: Row(
        children: [
          Checkbox(
              value: selected.length == itemCount,
              onChanged: (value) => onTap()),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: Colors.transparent, // keep background transparent
                child: InkWell(
                  onTap: () => onTap(),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      section.tr,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  "Selected ${selected.length} of $itemCount",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildStickyList(List<Housekeeping> items) {
    final groupedItems = groupItems(items);

    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: groupedItems.entries.map((entry) {
          final section = "${entry.key} | ${entry.value.first.blockName!}";
          final items = entry.value;
          bool isLastSection(String section) {
            return section == groupedItems.entries.last.key;
          }

          var floorId = items.isNotEmpty ? items.first.floorId : 0;

          return SliverStickyHeader(
            header: buildStickyHeader(section, items.length, floorId!),
            sliver: SliverPadding(
              padding: const EdgeInsets.all(4),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 3.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < items.length) {
                      return buildItem(items[index]);
                    } else if (isLoadingMore && isLastSection(section)) {
                      // Add a loading indicator as the last item only for the last section
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Map<String, List<Housekeeping>> groupItems(List<Housekeeping> items) {
    final distinctFloorNames =
        items.map((e) => e.floorName ?? "Unknown").toSet().toList();

    return {
      for (var floorName in distinctFloorNames)
        floorName:
            items.where((e) => (e.floorName ?? "Unknown") == floorName).toList()
    };
  }

  @override
  Widget buildHeaderWidget() {
    return Container(
      width: double.infinity,
      // height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadius,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: headerWidget(),
      ),
    );
  }

  @override
  Widget headerWidget() {
    return SearchBar(
      constraints: const BoxConstraints(
        minHeight: 36,
        maxHeight: 36,
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          color: AppTheme.primaryColor,
          fontFamilyFallback: ['Gilroy', 'Kantumruy'],
          fontSize: 18,
        ),
      ),
      // hintText: 'Search'.tr,
      hintText: 'Search',
      hintStyle: WidgetStateProperty.all(
        TextStyle(
            color: AppTheme.primaryColor.withOpacity(0.5),
            fontSize: 12,
            fontFamilyFallback: const ['Gilroy', 'Kantumruy']),
      ),
      leading: Icon(
        Icons.search,
        size: 18,
        color: AppTheme.primaryColor.withOpacity(0.5),
      ),
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: const BorderSide(
            color: Color.fromARGB(255, 241, 241, 241),
            width: 1,
          ),
        ),
      ),
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () {
          controller.searchText.value = value;
          controller.list.clear();
          controller.currentPage = 1;
          controller.search();
        });
      },
      trailing: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () async {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;

                final RelativeRect position = RelativeRect.fromRect(
                  Rect.fromPoints(
                    button.localToGlobal(Offset.zero, ancestor: overlay),
                    button.localToGlobal(button.size.bottomRight(Offset.zero),
                        ancestor: overlay),
                  ),
                  Offset.zero & overlay.size,
                );

                final result = await showMenu(
                  context: context,
                  position: position,
                  items: [
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      height: 35,
                      value: 0,
                      onTap: () {
                        controller.houseKeepingStatus.value = 0;
                        controller.search();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        width: 110,
                        child: const Row(children: [
                          Icon(
                            Icons.layers_outlined,
                            size: 16,
                            color: AppTheme.primaryColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "All",
                            style: const TextStyle(fontSize: 12),
                          )
                        ]),
                      ),
                    ),
                    ...lookupController.lookups.map((LookupModel item) {
                      return _buildPopoverItem(item);
                    })
                  ],
                );

                if (result != null) {
                  print("Selected: $result");
                }
              },
            );
          },
        ),
      ],
    );
  }

  PopupMenuItem _buildPopoverItem(LookupModel item) {
    return PopupMenuItem(
      padding: EdgeInsets.zero,
      height: 35,
      onTap: () {
        controller.houseKeepingStatus.value = item.valueId!;
        controller.search();
      },
      value: item.valueId,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        width: 110,
        child: Row(children: [
          NetworkImg(
            src: item.image,
            height: 16,
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: Text(item.nameEn ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(
            width: 4,
          ),
          controller.houseKeepingStatus.value == item.valueId
              ? const Icon(Icons.check,
                  size: 16, textDirection: TextDirection.rtl)
              : const SizedBox()
        ]),
      ),
    );
  }

  @override
  Widget buildBottomNavigationBar() {
    return Container(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Obx(() => MyButton(
            disabled: controller.selected.isEmpty,
            label: '',
            onPressed: () => Modal.showFormDialog(
                  CreateTaskScreen(),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_rounded,
                  size: 14,
                ),
                Text("Task".tr)
              ],
            ))));
  }

  @override
  List<Widget> actions() {
    return [
      IconButton(
          onPressed: () => Get.toNamed(RouteName.task),
          icon: const Icon(Icons.task_outlined)),
    ];
  }

  @override
  Widget buildItem(Housekeeping item) {
    var selected = controller.selected.any((e) => e.roomId == item.roomId);
    var selectedTextColor = selected ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        color: selected ? AppTheme.primaryColor.withOpacity(0.7) : Colors.white,
      ),
      child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () {
            if (selected) {
              controller.selected.remove(item);
            } else {
              controller.selected.add(item);
            }
          },
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  child:
                      NetworkImg(src: item.houseKeepingStatusImage, height: 18),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item.roomNumber ?? ''}, ${item.roomTypeName ?? ''}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, color: selectedTextColor),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              NetworkImg(src: item.statusImage, height: 14),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                item.statusNameEn!,
                                style: TextStyle(
                                    fontSize: 11, color: selectedTextColor),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Transform.scale(
                    //   scale: 0.9,
                    //   child:
                    //    Row(
                    //     children: [
                    //       NetworkImg(src: item.statusImage, height: 18),
                    //       const SizedBox(
                    //         width: 2,
                    //       ),
                    //       Text(
                    //         item.statusNameEn!,
                    //         style: TextStyle(
                    //             fontSize: 11, color: selectedTextColor),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
