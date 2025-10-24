import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/notification_model.dart';
import 'package:staff_view_ui/pages/notification/notification_controller.dart';
import 'package:staff_view_ui/route.dart';
import 'package:staff_view_ui/utils/theme.dart';

class NotificationScreen extends BaseList<NotificationModel> {
  NotificationScreen({super.key});
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget leading() {
    return IconButton(
        icon: const Icon(Icons.arrow_back), onPressed: () => Get.back());
  }

  @override
  String get title => "Notifications".tr;

  @override
  RxList<NotificationModel> get items => controller.list;

  @override
  Map<String, List<NotificationModel>> groupItems(
      List<NotificationModel> items) {
    return {"All": items};
  }

  @override
  bool get isLoading => controller.loading.value;

  @override
  bool get fabButton => false;

  @override
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
    await controller.search();
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
      padding: const EdgeInsets.only(right: 12, bottom: 8, top: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: headerWidget(),
      ),
    );
  }

  @override
  Widget headerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
            onTap: () async => await controller.markAllRead(),
            child: const Text("Mark all read",
                style: TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline)))
      ],
    );
  }

  @override
  Widget buildStickyList(List<NotificationModel> items) {
    final groupedItems = groupItems(items);
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 0),
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
  Widget buildItem(NotificationModel item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
          borderRadius: AppTheme.borderRadius, color: Colors.white),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Color.fromARGB(255, 233, 233, 233), // border color
                width: 1.0, // border thickness
              ),
            ),
            color: Colors.transparent,
            child: InkWell(
              splashColor: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              onTap: () async {
                await controller.markRead(item.requestId ?? 0);
                Get.toNamed(RouteName.requestLog,
                    arguments: {'id': item.requestId});
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(item.title ?? '',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text(Const.getPrettyDate(item.createdDate))
                            ],
                          ),
                          Text(item.message ?? '',
                              style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (item.isView == false)
            Positioned(
                top: -2,
                right: -2,
                child: Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(99)),
                ))
        ],
      ),
    );
  }
}
