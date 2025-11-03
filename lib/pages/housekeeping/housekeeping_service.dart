import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';

class HousekeepingService {
  final dio = DioClient();
  Future<SearchResult<Housekeeping>> search(QueryParam query) async {
    try {
      final response = await dio.get('request/mobile/room?pageIndex=${query.pageIndex}&pageSize=${query.pageSize}&sorts=${query.sorts}&filters=${query.filters}');
      if (response?.statusCode == 200) {
        return SearchResult<Housekeeping>.fromJson(
          response!.data,
          (json) => Housekeeping.fromJson(json),
        );
      }

      throw Exception('Failed to search.');
    } catch (e) {
      print('Search error: $e');
      throw Exception('Failed to search.');
    }
  }
}
