import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staff_view_ui/helpers/base_list_screen.dart';
import 'package:staff_view_ui/models/attendance_record_model.dart';
import 'package:staff_view_ui/pages/working/history/history_controller.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';

class HistoryScreen extends BaseList<AttendanceRecordModel> {
  HistoryScreen({super.key});

  final HistoryController controller = Get.put(HistoryController());

  @override
  String get title => 'History Scan Log';

  @override
  bool get fabButton => false;

  @override
  bool get isLoading => controller.loading.value;

  @override
  bool get isLoadingMore => controller.isLoadingMore.value;

  @override
  bool get canLoadMore => controller.canLoadMore.value;

  @override
  RxList<AttendanceRecordModel> get items => controller.lists;

  @override
  Future<void> onLoadMore() async {
    await controller.onLoadMore();
  }

  @override
  void onFabPressed() {}

  @override
  Future<void> onRefresh() async {
    controller.queryParam.value.pageIndex = 1;
    controller.search();
  }

  @override
  Map<String, List<AttendanceRecordModel>> groupItems(
      List<AttendanceRecordModel> items) {
    return items.fold<Map<String, List<AttendanceRecordModel>>>({},
        (grouped, attendanceRecord) {
      final month = getMonth(attendanceRecord.time!);
      grouped.putIfAbsent(month, () => []).add(attendanceRecord);
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
  Widget buildItem(AttendanceRecordModel item) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      leading: Calendar(date: item.time!),
      subtitle: Text(
        item.terminalName!,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
        ),
      ),
      title: Row(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: convertToKhmerDate(item.time!),
                  style: const TextStyle(fontSize: 14),
                ),
                TextSpan(
                    text: ' ${DateFormat('h:mm a').format(item.time!)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Tag(
            color: Colors.black,
            text: item.checkInOutTypeNameKh!,
          ),
        ],
      ),
    );
  }
}
