import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/notification_model.dart';
import 'package:staff_view_ui/pages/notification/notification_controller.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/theme.dart';
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
        clipBehavior: Clip.none, // Ensure shadows are not clipped
        children: [
          Material(
            elevation: 1, // Adds a shadow
            borderRadius: BorderRadius.circular(8),
            child: Calendar(date: item.createdDate!),
          ),
          if (item.isView == false)
            const Positioned(
              top: 0,
              left: -12,
              child: Icon(
                Icons.circle,
                size: 10,
                color: AppTheme.primaryColor,
              ),
            ),
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
          Expanded(
            child: Text(
              item.title!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: item.isView == false ? FontWeight.bold : null,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 10),
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
