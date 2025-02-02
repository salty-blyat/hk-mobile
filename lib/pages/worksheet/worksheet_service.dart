import 'dart:math';

import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/storage.dart';
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

  downloadReport({required String reportName, required String dateRange}) {
    final storage = Storage();
    final response = dio.dio.get(
        '${dio.baseUrl}/report/process?reportName=$reportName&staffId=${storage.read(Const.staffId)}&dateRange=$dateRange&format=pdf&requestId=${generateUUID()}');
    return response;
  }

  String generateUUID() {
    final Random random = Random();

    String randomHex(int length) {
      const chars = '0123456789abcdef';
      return List.generate(length, (_) => chars[random.nextInt(16)]).join();
    }

    return '${randomHex(8)}-${randomHex(4)}-4${randomHex(3)}-${[
      '8',
      '9',
      'a',
      'b'
    ][random.nextInt(4)]}${randomHex(3)}-${randomHex(12)}';
  }
}
