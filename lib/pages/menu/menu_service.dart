import 'package:staff_view_ui/helpers/token_interceptor.dart';

class MenuService {
  final dio = DioClient();

  // https://latest.sgx.bz/hr/api/mobile/setting
  // https://latest.sgx.bz/hr/api/mobile/request/total
  Future<int> getTotal() async {
    final response = await dio.get('/request/total');
    return response?.data['totalLeave'] +
        response?.data['totalOT'] +
        response?.data['totalException'];
  }
}
