import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/leave_model.dart';

class LeaveService {
  final dio = DioClient();
  Future<void> add(Map<String, dynamic> leave) async {
    var response = await dio.post('leave', data: leave);
    if (response?.statusCode == 200) {
      Get.back();
      return response?.data;
    }
    return;
  }

  Future<void> edit(Map<String, dynamic> leave) async {
    var response = await dio.put('leave/${leave['id']}', data: leave);
    if (response.statusCode == 200) {
      Get.back();
      return response.data;
    }
    return;
  }

  Future<List<Leave>> get({Map<String, dynamic>? queryParameters}) async {
    var response = await dio.get('leave', queryParameters: queryParameters);
    return (response?.data['results'] as List)
        .map((e) => Leave.fromJson(e))
        .toList();
  }

  Future<Leave> find(int id) async {
    var response = await dio.get('leave/$id');
    return Leave.fromJson(response?.data);
  }

  Future<double> getLeaveBalance(int id) async {
    var response = await dio.get('leavebalance/$id');
    print(response?.data);
    return response?.data['balance'];
  }
}
