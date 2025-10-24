 
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/notification_mark_model.dart';
import 'package:staff_view_ui/models/notification_model.dart';
 
class NotificationService {
  final dio = DioClient(); 
  Future<List<NotificationModel>> search(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      var response =
          await dio.get('notification', queryParameters: queryParameters);
      if (response?.statusCode == 200) {
        return (response?.data['results'] as List)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<NotificationMarkModel>> markRead(int id) async {
    try {
      var response = await dio.post('notification/$id/mark-read');
      if (response?.statusCode == 200) {
        return (response?.data['results'] as List)
            .map((e) => NotificationMarkModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<NotificationMarkModel>> markAllRead() async {
    try {
      var response = await dio.get('notification/mark-all-read');
      if (response?.statusCode == 200) {
        return (response?.data['results'] as List)
            .map((e) => NotificationMarkModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}
