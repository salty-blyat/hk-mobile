import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/leave_model.dart';

class LeaveService {
  final dio = DioClient();
  Future<void> add(Leave leave) async {
    final response = await dio.post('/leave', data: leave.toJson());
    print(response);
  }
}
