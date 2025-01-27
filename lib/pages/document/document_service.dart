import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/document_model.dart';

class DocumentService {
  final dio = DioClient().dio;
  Future<SearchResult<DocumentModel>> search(QueryParam params) async {
    final response = await dio.get(
        '${AppSetting.setting['BASE_API_URL']}/document?pageSize=${params.pageSize}&pageIndex=${params.pageIndex}&sorts=${params.sorts}&filters=${params.filters}');
    return SearchResult.fromJson(response.data, DocumentModel.fromJson);
  }

  Future<int> getContentLength(String url) async {
    try {
      final response = await dio.head(url);
      if (response.headers.value('content-length') != null) {
        final contentLength =
            int.parse(response.headers.value('content-length')!);
        return contentLength;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }
}
