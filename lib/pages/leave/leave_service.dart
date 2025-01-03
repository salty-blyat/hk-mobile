import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';

class LeaveService {
  final dio = DioClient();
  Future<void> add(Map<String, dynamic> leave) async {
    var response = await dio.post('/leave', data: leave);
    print(response?.data);
    if (response?.statusCode == 200) {
      Get.back();
      return response?.data;
    }
    return null;
  }
}
