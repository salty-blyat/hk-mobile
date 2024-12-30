import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/working_sheet.dart';

class WorkingService {
  final dio = DioClient();
  Future<List<Worksheets>> getWorking() async {
    final response = await dio.get('/worksheet', queryParameters: {
      'fromDate': '2024-12-01',
      'toDate': '2024-12-31',
    });
    return (response?.data['results'] as List)
        .map((e) => Worksheets.fromJson(e))
        .toList();
  }
}
