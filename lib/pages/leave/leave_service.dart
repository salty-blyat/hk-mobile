// import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/leave_model.dart';
// import 'package:staff_view_ui/models/leave_model.dart';

class LeaveService extends BaseService<Leave> {
  LeaveService() : super('leave');

  Future<double> getLeaveBalance(int id) async {
    var response = await dio.get('$baseUrl/leavebalance/$id');
    return response.data['balance'];
  }

  Future<double> getActualLeaveDay(
      int id, DateTime fromDate, DateTime toDate) async {
    var response =
        await dio.get('$baseUrl/actual/leave/day/$id/$fromDate/$toDate');
    return response.data['totalDays'];
  }
}
