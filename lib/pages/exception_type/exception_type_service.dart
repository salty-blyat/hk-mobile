import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/exception_type_model.dart';

class ExceptionTypeService {
  final dio = DioClient();
  Future<List<ExceptionTypeModel>> getExceptionType() async {
    final response = await dio.get('/staffexceptiontype',
        queryParameters: {'pageSize': 50, 'pageIndex': 1});
    return (response?.data['results'] as List)
        .map((e) => ExceptionTypeModel.fromJson(e))
        .toList();
  }
}
