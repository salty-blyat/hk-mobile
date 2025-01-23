import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/attendance_terminal_model.dart';

class AttendanceTerminalService {
  final dio = DioClient();
  Future<List<AttendanceTerminalModel>> search() async {
    final response = await dio.get('/attendanceterminal', queryParameters: {
      'pageSize': 50,
      'pageIndex': 1,
      'sorts': '',
      'filters': '[]'
    });
    return (response?.data['results'] as List)
        .map((e) => AttendanceTerminalModel.fromJson(e))
        .toList();
  }
}
