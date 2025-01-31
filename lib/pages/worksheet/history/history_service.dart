import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/attendance_record_model.dart';

class AttendanceRecordService {
  final dio = DioClient();
  Future<SearchResult<AttendanceRecordModel>> search(QueryParam params) async {
    final response = await dio.get('/attendancerecord', queryParameters: {
      'pageIndex': params.pageIndex,
      'pageSize': params.pageSize,
      'sorts': params.sorts,
      'filters': params.filters,
    });
    return SearchResult<AttendanceRecordModel>.fromJson(
        response?.data, AttendanceRecordModel.fromJson);
  }
}
