import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/models/lookup_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_controller.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/network_img.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';

class HousekeepingScreen extends BaseList<Housekeeping> {
  HousekeepingScreen({super.key});

  final HousekeepingController controller = Get.put(HousekeepingController());
  final LookupController lookupController = Get.find<LookupController>();

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

  @override
  RxList<Housekeeping> get items => controller.list;

  // @override
  // Future<void> onLoadMore() async {
  //   await controller.onLoadMore();
  // } 
  Widget buildStickyHeader(String section, int? itemCount) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        children: [
          Checkbox(
              value: false,
              onChanged: (value) {
                print(value);
              }),
            Text(
              section.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ), 
            Text(
             'asdfdasfasdfs',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
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

        return SliverStickyHeader(
          header: buildStickyHeader(section, items.length),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
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
            separatorBuilder: (context, index) =>
                Container(height: 1, color: Colors.grey.shade100),
            itemCount: items.length +
                (isLoadingMore && isLastSection(section) ? 1 : 0),
          ),
        );
      }).toList(),
    );
  }

  @override
  Map<String, List<Housekeeping>> groupItems(List<Housekeeping> items) {
    final roomTypeNames = items.map((e) => e.roomTypeName);
    final distinctRoomTypeNames = [];
    roomTypeNames.forEach((e) {
      if (!distinctRoomTypeNames.contains(e)) {
        distinctRoomTypeNames.add(e);
      }
    });
    return {
      // 'All': items, // one group with all items
      for (var roomType in distinctRoomTypeNames)
        roomType: items.where((e) => e.roomTypeName == roomType).toList(),
    };
  }

  @override
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBar(
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              color: AppTheme.primaryColor,
              fontFamilyFallback: ['Gilroy', 'Kantumruy'],
              fontSize: 18,
            ),
          ),
          hintText: 'Search'.tr,
          hintStyle: WidgetStateProperty.all(
            TextStyle(
                color: AppTheme.primaryColor.withOpacity(0.5),
                fontSize: 18,
                fontFamilyFallback: const ['Gilroy', 'Kantumruy']),
          ),
          leading: const Icon(Icons.search),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Color.fromARGB(255, 241, 241, 241),
                width: 1,
              ),
            ),
          ),
          onChanged: (value) {
            controller.searchText.value = value;
            controller.list.clear();
            controller.currentPage = 1;
            controller.search();
          },
        ),
        // _buildHousekeepingTypeButtons()
      ],
    );
  }

  @override
  Widget buildBottomNavigationBar() {
    return Obx(
      () => Row(
        children: lookupController.lookups.map((LookupModel item) {
          final lookupColor = item.color != null
              ? Color(int.parse(item.color!.replaceFirst('#', '0xFF')))
              : const Color.fromARGB(255, 8, 8, 8);
          final color = item.color != null
              ? (() {
                  final base =
                      Color(int.parse(item.color!.replaceFirst('#', '0xFF')));
                  final hsl = HSLColor.fromColor(base);
                  return hsl
                      .withLightness((hsl.lightness + 0.35).clamp(0.0, 1.0))
                      .toColor();
                })()
              : const Color.fromARGB(255, 8, 8, 8);

          if (item.image == null) return new Container();

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
                color: color,
                textColor: Colors.black,
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.zero, top: Radius.circular(12)),
                onPressed: () => print("${item.valueId} ${item.nameEn} tapped"),
                label: item.nameEn ?? "",
                child: SizedBox(
                  height: 40,
                  child: Column(
                    children: [
                      const SizedBox(height: 2),
                      NetworkImg(src: item.image, height: 18),
                      const SizedBox(height: 4),
                      Text(item.nameEn ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: lookupColor,
                              fontSize: Get.textTheme.bodySmall!.fontSize)),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
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
        onPressed: () {
          // more menu
        },
      ),
    ];
  }

  @override
  Widget buildItem(Housekeeping item) {
    return Obx(
      () => ListTile(
        onTap: () {
          if (controller.selected.contains(item)) {
            controller.selected.remove(item);
          } else {
            controller.selected.add(item);
          }
        },
        titleAlignment: ListTileTitleAlignment.center,
        leading: Checkbox(
          value: controller.selected.contains(item),
          onChanged: (bool? newValue) {
            if (newValue == true) {
              controller.selected.add(item);
            } else {
              controller.selected.remove(item);
            }
          },
        ),
        subtitle: Text(
          item.blockName ?? '',
          overflow: TextOverflow.ellipsis,
        ),
        title: Row(
          children: [
            Text(
              item.roomNumber!.tr,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: Get.theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.roomNumber!,
              style: Get.textTheme.bodySmall!.copyWith(color: Colors.black),
            ),
            const SizedBox(height: 12),
            Tag(
              // color: Style.getStatusColor(item.status ?? 0) ?? Colors.red,
              color: Colors.red,
              text: item.statusNameKh!,
            ),
          ],
        ),
      ),
    );
  }
}
