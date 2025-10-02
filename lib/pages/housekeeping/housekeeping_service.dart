

import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';

class HousekeepingService  {
  final dio = DioClient() ; 
  Future<List<Housekeeping>> search({  Map<String, dynamic>? queryParameters}) async {
    var response = await dio.get('request/mobile/room', queryParameters: queryParameters);
    if (response?.statusCode == 200) {
      return (response?.data['results'] as List)
          .map((e) => Housekeeping.fromJson(e))
          .toList();
    }
    return [];
  }
}
