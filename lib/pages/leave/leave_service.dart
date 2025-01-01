import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/leave_type_model.dart';

class LeaveTypeService {
  final dio = DioClient();
  Future<List<LeaveType>> getLeaveType() async {
    final response = await dio
        .get('/leavetype', queryParameters: {'pageSize': 100, 'pageIndex': 1});
    print(response?.data);
    return (response?.data['results'] as List)
        .map((e) => LeaveType.fromJson(e))
        .toList();
  }
}
