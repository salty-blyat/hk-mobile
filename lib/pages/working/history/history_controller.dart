import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attendance_record_model.dart';
import 'package:staff_view_ui/pages/working/history/history_service.dart';

class HistoryController extends GetxController {
  final AttendanceRecordService attendanceRecordService =
      AttendanceRecordService();
  final lists = <AttendanceRecordModel>[].obs;
  final loading = false.obs;
  final isLoadingMore = false.obs;
  final canLoadMore = true.obs;
  final year = DateTime.now().year.obs;
  final queryParam = QueryParam(
    pageIndex: 1,
    pageSize: 10,
    sorts: '',
    filters: '[]',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    search();
  }

  Future<void> onLoadMore() async {
    if (!canLoadMore.value) return;

    isLoadingMore.value = true;
    queryParam.update((params) {
      params?.pageIndex = (params.pageIndex ?? 0) + 1;
    });

    try {
      final response = await attendanceRecordService.search(queryParam.value);
      lists.addAll(response.results as Iterable<AttendanceRecordModel>);
      canLoadMore.value = response.results.length == queryParam.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      print("Error during onLoadMore: $e");
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> search() async {
    loading.value = true;
    var filters = [];
    filters.add({
      'field': 'time',
      'operators': 'contains',
      'value': '${year.value}-01-01 ~ ${year.value}-12-31'
    });
    final result = await attendanceRecordService.search(queryParam.value);
    lists.value = result.results as List<AttendanceRecordModel>;
    loading.value = false;
  }
}
