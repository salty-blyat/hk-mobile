import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/leave_balance_model.dart';
import 'package:staff_view_ui/models/leave_type_model.dart';

class LeaveBalanceService {
  final dio = DioClient();

  Future<Map<String, dynamic>> getLeaveBalance(int year) async {
    final response = await dio.get(
      '/leavebalance/by-year/${year.toString()}',
    );

    if (response?.data != null) {
      // Parse the "result" field into LeaveBalanceModel
      final leaveBalance = LeaveBalanceModel.fromJson(response?.data['result']);

      // Parse the "leaveTypes" field into a List<LeaveType>
      final leaveTypes = (response?.data['leaveTypes'] as List)
          .map((e) => LeaveType.fromJson(e))
          .toList();

      // Return both the leave balance and leave types
      return {
        'result': leaveBalance,
        'leaveTypes': leaveTypes,
      };
    } else {
      throw Exception('Failed to load leave balance data');
    }
  }
}
