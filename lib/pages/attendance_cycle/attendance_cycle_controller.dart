import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attendance_cycle_model.dart';
import 'package:staff_view_ui/pages/attendance_cycle/attendance_cycle_service.dart';

class AttendanceCycleController extends GetxController {
  final AttendanceCycleService service = AttendanceCycleService();
  final selected = 0.obs;
  final lists = <AttendanceCycleModel>[].obs;
  final loading = false.obs;
  final params = QueryParam(
    pageIndex: 1,
    pageSize: 25,
    sorts: 'start-',
    filters: '[]',
  );

  @override
  void onInit() {
    super.onInit();
    search();
  }

  search() async {
    try {
      loading.value = true;
      var result = await service.search(params);
      lists.value =
          result.results.map((e) => AttendanceCycleModel.fromJson(e)).toList();
      selected.value = lists.first.id ?? 0;
    } finally {
      loading.value = false;
    }
  }
}
