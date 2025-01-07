import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/leave_type_model.dart';

class LeaveTypeService {
  final dio = DioClient();
  Future<List<LeaveType>> getLeaveType() async {
    final response = await dio
        .get('/leavetype', queryParameters: {'pageSize': 50, 'pageIndex': 1});
    return (response?.data['results'] as List)
        .map((e) => LeaveType.fromJson(e))
        .toList();
  }
}
