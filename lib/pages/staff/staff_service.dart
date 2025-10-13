import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/user_info_model.dart';

class StaffService {
  final DioClient dio = DioClient();
  Future<List<Staff>> search({Map<String, dynamic>? queryParameters}) async {
    var response = await dio.get('staff', queryParameters: queryParameters);
    if (response?.statusCode == 200) {
      return (response?.data['results'] as List)
          .map((e) => Staff.fromJson(e))
          .toList();
    }
    return [];
  }
}
