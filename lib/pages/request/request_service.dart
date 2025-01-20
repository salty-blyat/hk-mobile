import 'package:dio/dio.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/request_model.dart';

class RequestApproveService extends BaseService<RequestModel> {
  RequestApproveService() : super('request');
  Future<Response<dynamic>> findByReqType(int id, int reqType) async {
    return await dio.get<dynamic>('$apiUrl/requesttype/$id/$reqType');
  }

  Future<Response<bool>> canDoAction(int id) async {
    return await dio.get<bool>('$apiUrl/can-do-action/$id');
  }

  Future<Response<Map<String, dynamic>>> reject(
      Map<String, dynamic> model) async {
    return await dio.post<Map<String, dynamic>>('$apiUrl/reject', data: model);
  }

  Future<Response<Map<String, dynamic>>> approve(
      Map<String, dynamic> model) async {
    return await dio.post<Map<String, dynamic>>('$apiUrl/approve', data: model);
  }

  Future<Response<Map<String, dynamic>>> undo(
      Map<String, dynamic> model) async {
    return await dio.post<Map<String, dynamic>>('$apiUrl/undo', data: model);
  }

  Future<SearchResult<RequestModel>> all(QueryParam query,
      RequestModel Function(Map<String, dynamic>) fromJsonT) async {
    try {
      final response = await dio.get(
        '$apiUrl/all?pageIndex=${query.pageIndex}&pageSize=${query.pageSize}&sorts=${query.sorts}&filters=${query.filters}',
      );

      if (response.statusCode == 200) {
        return SearchResult<RequestModel>.fromJson(response.data, fromJsonT);
      }
      throw Exception('Failed to search.');
    } catch (e) {
      print(e);
      throw Exception('Failed to search.');
    }
  }
}
