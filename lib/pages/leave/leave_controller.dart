import 'package:get/get.dart';
import 'package:staff_view_ui/models/leave_model.dart';
import 'package:staff_view_ui/pages/leave/leave_service.dart';

class LeaveController extends GetxController {
  final loading = false.obs;
  final leaveService = LeaveService();
  final formValid = false.obs;
  final lists = <Leave>[].obs;
  final queryParameters = <String, dynamic>{
    'pageIndex': 1,
    'pageSize': 10,
    'sorts': 'fromDate-',
    'filters': '[]',
  }.obs;

  Future<void> search() async {
    var leave = await leaveService.get(queryParameters: queryParameters);
    lists.assignAll(leave);
  }
}
