import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/attendance_cycle_model.dart';

class AttendanceCycleService {
  var dio = DioClient();

  Future<SearchResult<AttendanceCycleModel>> search(QueryParam params) async {
    var response = await dio.dio.get(
        '${dio.baseUrl}/attendancecycle?pageIndex=${params.pageIndex}&pageSize=${params.pageSize}&sorts=${params.sorts}&filters=${params.filters}');
    return SearchResult<AttendanceCycleModel>(
      results: response.data['results'],
      param: QueryParam.fromJson(response.data['param']),
    );
  }
}
