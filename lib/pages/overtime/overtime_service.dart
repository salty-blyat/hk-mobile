import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/overtime_type_model.dart';

class OvertimeTypeService {
  final dio = DioClient();
  Future<List<OvertimeType>> getOvertimeType() async {
    final response = await dio.get('/overtimetype',
        queryParameters: {'pageSize': 100, 'pageIndex': 1});
    print(response?.data);
    return (response?.data['results'] as List)
        .map((e) => OvertimeType.fromJson(e))
        .toList();
  }
}
