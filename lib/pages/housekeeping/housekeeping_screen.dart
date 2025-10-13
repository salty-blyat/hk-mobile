import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_controller.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/models/lookup_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/staff_user/staff_user_controller.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';
import 'package:staff_view_ui/route.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/network_img.dart';

class HousekeepingScreen extends BaseList<Housekeeping> {
  HousekeepingScreen({super.key});

  final HousekeepingController controller = Get.put(HousekeepingController());
  final LookupController lookupController = Get.put(LookupController());
  final StaffUserController staffUserController =
      Get.put(StaffUserController());
  Timer? _debounce;

  @override
  RxBool get showDrawer => true.obs;

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

  Color bgColor = const Color.fromARGB(255, 240, 240, 240);

  void dispose() {
    _debounce?.cancel();
  }

  @override
  RxList<Housekeeping> get items => controller.list;

  @override
  Widget titleWidget() {
    return Obx(() {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          staffUserController.staffUser.value?.staffName ?? '-',
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
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
    await controller.search();
  }

  Widget buildStickyHeader(String section, int itemCount, int sectionId) {
    List<Housekeeping> select =
        controller.list.where((e) => e.floorId == sectionId).toList();
    List<Housekeeping> selected =
        controller.selected.where((e) => e.floorId == sectionId).toList();
    void onTap() {
      if (controller.searchText.value.isNotEmpty) {
        return;
      }
      if (selected.length == itemCount) {
        controller.selected.removeWhere((e) => e.floorId == sectionId);
      } else {
        final merged = [...controller.selected, ...select];
        final unique = merged
            .fold<Map<int, Housekeeping>>({}, (map, item) {
              map[item.id!] = item;
              return map;
            })
            .values
            .toList();
        controller.selected.assignAll(unique);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Color.fromARGB(255, 250, 250, 250),
            blurRadius: 4,
            spreadRadius: 1)
      ]),
      child: Row(
        children: [
          Obx(() {
            return controller.searchText.value.isEmpty
                ? Checkbox(
                    tristate: true,
                    value: selected.isEmpty
                        ? false
                        : (selected.length == itemCount ? true : null),
                    onChanged: (value) => onTap())
                : const SizedBox.shrink();
          }),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTap(),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  "${'Selected'.tr} ${selected.length} / $itemCount",
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
      color: bgColor,
      child: CustomScrollView(
        slivers: groupedItems.entries.map((entry) {
          final section = "${entry.key} | ${entry.value.first.blockName ?? ''}";
          final items = entry.value;
          bool isLastSection(String section) {
            return section == groupedItems.entries.last.key;
          }

          var floorId = items.isNotEmpty && items.first.floorId != null
              ? items.first.floorId
              : 0;

          return SliverStickyHeader(
            header: buildStickyHeader(section, items.length, floorId!),
            sliver: SliverPadding(
              padding:
                  const EdgeInsets.only(top: 8, left: 4, right: 4, bottom: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 1.3,
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
      padding: const EdgeInsets.only(top: 8),
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
        minHeight: 42,
        maxHeight: 42,
      ),
      padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 0, horizontal: 12)),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          // color: Colors.black,
          fontFamilyFallback: ['Gilroy', 'Kantumruy'],
          fontSize: 18,
        ),
      ),
      // hintText: 'Search'.tr,
      hintText: 'Search',
      hintStyle: WidgetStateProperty.all(
        const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamilyFallback: ['Gilroy', 'Kantumruy']),
      ),
      leading: Icon(
        Icons.search,
        size: 18,
        color: Colors.grey.withOpacity(0.5),
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
        _debounce = Timer(const Duration(milliseconds: 500), () async {
          controller.searchText.value = value;
          controller.list.clear();
          controller.currentPage = 1;
          await controller.search();
        });
      },
      trailing: [
        Builder(
          builder: (context) {
            return Stack(
              children: [
                Obx(() {
                  return controller.houseKeepingStatus.value != 0
                      ? Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                        )
                      : const SizedBox.shrink();
                }),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () async {
                    final RenderBox button =
                        context.findRenderObject() as RenderBox;
                    final RenderBox overlay = Overlay.of(context)
                        .context
                        .findRenderObject() as RenderBox;

                    final RelativeRect position = RelativeRect.fromRect(
                      Rect.fromPoints(
                        button.localToGlobal(Offset.zero, ancestor: overlay),
                        button.localToGlobal(
                            button.size.bottomRight(Offset.zero),
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
                          onTap: () async {
                            controller.houseKeepingStatus.value = 0;
                            await controller.search();
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
                                style: TextStyle(fontSize: 12),
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
                ),
              ],
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
      onTap: () async {
        controller.houseKeepingStatus.value = item.valueId!;
        await controller.search();
      },
      value: item.valueId,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
    final AuthController authController = Get.put(AuthController());
    return Obx(() {
      if (authController.position.value == PositionEnum.manager.value) {
        return Container(
          color: bgColor,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: MyButton(
            disabled: controller.selected.isEmpty,
            label: '',
            onPressed: () { 
              Get.toNamed(RouteName.taskOp, arguments: {'id': 0}); 
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, size: 14),
                SizedBox(width: 4),
                Text("Task"),
              ],
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  @override
  List<Widget> actions() {
    final TaskController taskController = Get.put(TaskController());
    return [
      IconButton(
          onPressed: () {
            taskController.roomId.value = 0;
            Get.toNamed(RouteName.task, arguments: {'roomId': 0, 'title': ""});
            controller.selected.clear();
          },
          icon: const Icon(Icons.task_outlined)),
    ];
  }

  Widget _buildBadge(
      {String? src, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          // border: Border.all(color: Colors.grey.shade50),
          // color: color.withOpacity(0.3),
          color: Colors.grey.shade50),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NetworkImg(src: src, height: 14),
          const SizedBox(
            width: 4,
          ),
          Text(
            label,
            style: const TextStyle(
                fontSize: 12,
                // color: Colors.grey.shade700,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildItem(Housekeeping item) {
    var selected = controller.selected.any((e) => e.id == item.id);
    var selectedTextColor = selected ? Colors.black : Colors.black;
    final TaskController taskController = Get.put(TaskController());

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: selected
                ? AppTheme.primaryColor.withOpacity(0.5)
                : Colors.transparent,
            blurRadius: 2,
            spreadRadius: 0.04,
            offset: const Offset(0, 1), // shadow position
          ),
        ],
        color: selected ? Colors.white : Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            splashColor: AppTheme.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              if (selected) {
                controller.selected.value =
                    controller.selected.where((x) => x.id != item.id).toList();
              } else {
                controller.selected.add(item);
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.roomNumber ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selectedTextColor),
                        ),
                        Checkbox(
                          value: selected,
                          onChanged: (value) {
                            if (selected) {
                              controller.selected.remove(item);
                            } else {
                              controller.selected.add(item);
                            }
                          },
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -4),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: const CircleBorder(),
                        )
                      ]),
                  // const SizedBox(height: 4),
                  Text(
                    item.roomTypeName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 180,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildBadge(
                            src: item.houseKeepingStatusImage,
                            color: Colors.red,
                            label: item.houseKeepingStatusNameEn!,
                          ),
                          const SizedBox(width: 4),
                          _buildBadge(
                            src: item.statusImage,
                            color: Colors.grey,
                            label: item.statusNameEn!,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 32,
                    width: double.infinity,
                    child: Material(
                        // elevation: 0.8,
                        child: OutlinedButton(
                            onPressed: () async {
                              taskController.roomId.value = item.id ?? 0;
                              Get.toNamed(RouteName.task, arguments: {
                                'roomId': item.id,
                                'title': item.roomNumber
                              });
                              await taskController.search();

                              controller.selected.clear();
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 1,
                                color: selected
                                    ? AppTheme.primaryColor.withOpacity(0.5)
                                    : const Color.fromARGB(255, 223, 223, 223),
                              ),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Obx(() {
                              RxInt total = (item.total ?? 0).obs;
                              RxInt pending = (item.pending ?? 0).obs;
                              return Text(
                                  "${"View tasks".tr} ${total > 0 ? "($pending/$total)" : ''}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500));
                            }))),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
