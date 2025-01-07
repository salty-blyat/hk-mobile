import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';

class QueryParam {
  int? pageCount;
  int? pageIndex;
  int? pageSize;
  int? rowCount;
  String? sorts;
  String? filters;

  QueryParam({
    this.pageCount,
    this.pageIndex,
    this.pageSize,
    this.rowCount,
    this.sorts,
    this.filters,
  });

  factory QueryParam.fromJson(Map<String, dynamic> json) {
    return QueryParam(
      pageCount: json['pageCount'],
      pageIndex: json['pageIndex'],
      pageSize: json['pageSize'],
      rowCount: json['rowCount'],
      sorts: json['sorts'],
      filters: json['filters'].toString(),
    );
  }
}

class SearchResult<T> {
  List results = [];
  QueryParam param = QueryParam();

  SearchResult({
    required this.results,
    required this.param,
  });

  // A generic fromJson constructor
  factory SearchResult.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return SearchResult<T>(
      results:
          (json['results'] as List).map((item) => fromJsonT(item)).toList(),
      param: QueryParam.fromJson(json['param']),
    );
  }
}

class BaseModel {
  int? id;
}

class BaseService<T extends BaseModel> {
  final dio = DioClient().dio;
  final String endpoint;
  final String baseUrl = '${AppSetting.setting['BASE_API_URL']}/mobile';
  late String apiUrl = '$baseUrl/$endpoint';

  BaseService(this.endpoint);

  Future<SearchResult<T>> search(
      QueryParam query, T Function(Map<String, dynamic>) fromJsonT) async {
    final response = await dio.get(
      '$apiUrl?pageIndex=${query.pageIndex}&pageSize=${query.pageSize}&sort=${query.sorts}&filters=${query.filters}',
    );

    if (response.statusCode == 200) {
      return SearchResult<T>.fromJson(response.data, fromJsonT);
    }
    throw Exception('Failed to search.');
  }

  Future<dynamic> find(int id) async {
    final response = await dio.get(
      '$apiUrl/$id',
    );

    if (response.statusCode == 200) {
      return response.data;
    }
    throw Exception('Failed to find.');
  }

  Future<T> add(T model) async {
    final response = await dio.post(
      apiUrl,
      data: model,
    );

    if (response.statusCode == 200) {
      return response.data;
    }
    throw Exception('Failed to add item');
  }

  Future<T> edit(T model) async {
    final response = await dio.put(
      '$apiUrl/${model.id}',
      data: model,
    );

    if (response.statusCode == 200) {
      return response.data;
    }
    throw Exception('Failed to edit item');
  }

  Future<T> delete(T model) async {
    final response = await dio.delete(
      '$apiUrl/${model.id}',
      data: model,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
    return response.data;
  }
}
