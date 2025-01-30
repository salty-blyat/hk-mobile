import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/working_sheet.dart';

class WorkingService {
  final dio = DioClient();

  Future<List<Worksheets>> getWorking(
      {required String fromDate, required String toDate}) async {
    final response = await dio.get('/worksheet', queryParameters: {
      'fromDate': fromDate,
      'toDate': toDate,
    });
    return (response?.data['results'] as List)
        .map((e) => Worksheets.fromJson(e))
        .toList();
  }
}
