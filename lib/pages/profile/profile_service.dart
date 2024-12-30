import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/user_info_model.dart';

class ProfileService {
  final dio = DioClient();
  final AuthService authService = AuthService();

  Future<Staff> getUser() async {
    final response = await dio.get('/user-info');
    return Staff.fromJson(response?.data['staff'] ?? {});
  }

  Future<String> downloadReport(String reportName) async {
    final response = await dio.get('/report/download/$reportName');
    return response?.data['url'] ?? '';
  }
}
