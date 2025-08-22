import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/setting_model.dart';

class MenuService {
  final dio = DioClient();

  // Future<int> getTotal() async {
  //   final response = await dio.get('request/total');
  //   return response?.data['totalLeave'] +
  //       response?.data['totalOT'] +
  //       response?.data['totalException'];
  // }

  Future<List<SettingModel>> getSetting() async {
    final response = await dio.get('setting');
    List<SettingModel> setting = [];
    if (response?.statusCode == 200) {
      for (var element in response?.data) {
        setting.add(SettingModel.fromJson(element));
      }
      return setting;
    }
    throw Exception('Failed to get setting');
  }

  Future<SettingModel> getSettingPrivate(String key) async {
    final response = await dio.get('setting/$key');
    return SettingModel.fromJson(response?.data);
  }
}
