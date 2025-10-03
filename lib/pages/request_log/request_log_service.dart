import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/request_log_model.dart';

class RequestLogService {
  final dio = DioClient();

  Future<RequestLogModel> find(int id) async {
    try {
      var res = await dio.get('request/$id/mobile');
      if (res!.statusCode == 200) {
        return RequestLogModel.fromJson(res.data);
      } 
      throw Exception('Cannot find requestlog $id');
      
    } catch (e) {
      throw Exception(e);
    }
  }
}
