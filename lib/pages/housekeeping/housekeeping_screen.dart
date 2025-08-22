import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:multiselect/multiselect.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/models/lookup_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/utils/style.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/network_img.dart';

class HousekeepingScreen extends BaseList<Housekeeping> {
  HousekeepingScreen({super.key});

  final HousekeepingController controller = Get.put(HousekeepingController());
  final LookupController lookupController = Get.find<LookupController>();

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

  Widget buildStickyHeader(String section, int itemCount, int sectionId) {
    List<Housekeeping> select =
        controller.list.where((e) => e.roomTypeId == sectionId).toList();
    List<Housekeeping> selected =
        controller.selected.where((e) => e.roomTypeId == sectionId).toList();
    Function? onTap() {
      if (select.length == selected.length) {
        controller.selected.removeWhere((e) => e.roomTypeId == sectionId);
      } else {
        controller.selected.assignAll({
          ...controller.selected,
          ...select,
        });
      }
      return null;
    }

    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 2), // makes ripple area bigger
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

    return CustomScrollView(
      slivers: groupedItems.entries.map((entry) {
        final section = entry.key;
        final items = entry.value;
        bool isLastSection(String section) {
          return section == groupedItems.entries.last.key;
        }

        var roomTypeId = items.isNotEmpty ? items.first.roomTypeId : 0;

        return SliverStickyHeader(
          header: buildStickyHeader(section, items.length, roomTypeId!),
          sliver: SliverPadding(
            padding: const EdgeInsets.all(4),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 4.0,
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
    );
  }

  @override
  Map<String, List<Housekeeping>> groupItems(List<Housekeeping> items) {
    final roomTypeNames = items.map((e) => e.roomTypeName);
    final distinctRoomTypeNames = [];
    for (var e in roomTypeNames) {
      if (!distinctRoomTypeNames.contains(e)) {
        distinctRoomTypeNames.add(e);
      }
    }
    return {
      // 'All': items, // one group with all items
      for (var roomType in distinctRoomTypeNames)
        roomType: items.where((e) => e.roomTypeName == roomType).toList(),
    };
  }

  @override
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
    controller.selected.clear();
    controller.search();
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
                      height: 35,
                      value: 0,
                      onTap: () {
                        controller.houseKeepingStatus.value = 0;
                        controller.search();
                      },
                      child: SizedBox(
                        width: 85,
                        child: Row(children: [
                          Text(
                            "All".tr,
                            style: const TextStyle(fontSize: 11),
                          )
                        ]),
                      ),
                    ),
                    ...lookupController.lookups.map((LookupModel item) {
                      return PopupMenuItem(
                        height: 35,
                        onTap: () {
                          controller.houseKeepingStatus.value = item.valueId!;
                          controller.search();
                        },
                        value: item.valueId,
                        child: SizedBox(
                          width: 85,
                          child: Row(children: [
                            NetworkImg(
                              src: item.image,
                              height: 16,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              item.nameEn ?? "",
                              style: TextStyle(fontSize: 11),
                            )
                          ]),
                        ),
                      );
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

  @override
  Widget buildBottomNavigationBar() {
    return Obx(() => Row(
          children: lookupController.lookups.map((LookupModel item) {
            if (item.image == null) return Container();
            return Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(66, 156, 156, 156),
                      blurRadius: 10,
                      spreadRadius: 0.03,
                      offset: Offset(0, -1),
                    ),
                  ],
                ),
                child: MyButton(
                  color: Style.getLookupColor(item.color),
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.zero, top: Radius.circular(12)),
                  onPressed: () =>
                      print("${item.valueId} ${item.nameEn} tapped"),
                  label: item.nameEn ?? "",
                  child: SizedBox(
                    height: 50,
                    child: Column(
                      children: [
                        const SizedBox(height: 2),
                        NetworkImg(src: item.image, height: 18),
                        const SizedBox(height: 4),
                        // TODO: Implement NAME KH ALSO
                        Text(item.nameEn ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Style.getLookupTextColor(item.color),
                                fontSize: Get.textTheme.bodySmall!.fontSize)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ));
  }

  @override
  List<Widget> actions() {
    return [
      // Row(children: [
      //   Text("20"),
      //   Column(children: [
      //     Text("21"),
      //     Text("22"),
      //   ]),
      // ],),
      IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {},
      ),
    ];
  }

  @override
  Widget buildItem(Housekeeping item) {
    var selected = controller.selected.any((e) => e.roomId == item.roomId);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: selected ? AppTheme.primaryColor : Colors.transparent,
          width: 1,
        ),
        color: selected ? AppTheme.primaryColor : Colors.white,
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
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.roomNumber ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        item.blockName!.tr,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9,
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.9,
                  child: Row(
                    children: [
                      NetworkImg(src: item.statusImage, height: 18),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        item.statusNameEn!,
                        style: TextStyle(
                          fontSize: 11,
                          color: selected ? Colors.white : Colors.black,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
