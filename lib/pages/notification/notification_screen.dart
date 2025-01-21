import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/notification_model.dart';
import 'package:staff_view_ui/pages/notification/notification_controller.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';

class NotificationScreen extends BaseList<NotificationModel> {
  NotificationScreen({super.key});

  final NotificationController controller = Get.put(NotificationController());

  @override
  String get title => 'Notification';

  @override
  bool get isLoading => controller.loading.value;

  @override
  bool get isLoadingMore => controller.isLoadingMore.value;

  @override
  bool get canLoadMore => controller.canLoadMore.value;

  @override
  bool get fabButton => false;

  @override
  Future<void> onLoadMore() async {
    await controller.onLoadMore();
  }

  @override
  bool get showHeader => false;

  @override
  Future<void> onRefresh() async {
    controller.queryParameters.value.pageIndex = 1;
    controller.search();
  }

  @override
  Map<String, List<NotificationModel>> groupItems(
      List<NotificationModel> items) {
    return items.fold<Map<String, List<NotificationModel>>>({},
        (grouped, notification) {
      final month = getMonth(notification.createdDate!);
      grouped.putIfAbsent(month, () => []).add(notification);
      return grouped;
    });
  }

  @override
  Widget headerWidget() {
    return YearSelect(
      onYearSelected: (year) {
        controller.year.value = year;
        onRefresh();
      },
    );
  }

  @override
  Widget buildItem(NotificationModel item) {
    return ListTile(
      onTap: () => controller.viewNotification(item),
      titleAlignment: ListTileTitleAlignment.center,
      leading: Stack(
        children: [
          Calendar(date: item.createdDate!),
        ],
      ),
      subtitle: Text(
        item.message!,
        style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 12,
          color: Colors.black,
        ),
        maxLines: 2,
      ),
      title: Row(
        children: [
          Text(
            item.title!,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: item.isView == false ? FontWeight.bold : null,
            ),
            maxLines: 1,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('hh:mm a').format(item.createdDate!),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: item.isView == false ? FontWeight.bold : null,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  RxList<NotificationModel> get items => controller.lists;
}
