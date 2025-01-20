import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/working_sheet.dart';

class WorkingService {
  final dio = DioClient();
  Future<List<Worksheets>> getWorking() async {
    final date = DateTime.now().toLocal();
    final response = await dio.get('/worksheet', queryParameters: {
      'fromDate': '${date.year}-${date.month}-01',
      'toDate': '${date.year}-${date.month}-31',
    });
    return (response?.data['results'] as List)
        .map((e) => Worksheets.fromJson(e))
        .toList();
  }
}
