import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/models/task_op_multi_model.dart';
import 'package:staff_view_ui/models/task_res_model.dart';
import 'package:staff_view_ui/models/task_summary_model.dart';
import 'package:staff_view_ui/models/task_with_summary_model.dart';

class SearchTaskResult {
  List<TaskSummaryModel> summaryByStatuses;
  List<TaskModel> results;
  QueryParam param;

  SearchTaskResult({
    required this.summaryByStatuses,
    required this.results,
    required this.param,
  });

  factory SearchTaskResult.fromJson(Map<String, dynamic> json) {
    return SearchTaskResult(
      summaryByStatuses: (json['summaryByStatuses'] as List)
          .map((item) => TaskSummaryModel.fromJson(item))
          .toList(),
      results: (json['results'] as List)
          .map((item) => TaskModel.fromJson(item))
          .toList(),
      param: QueryParam.fromJson(json['param']),
    );
  }
}

class TaskService {
  final dio = DioClient();

  Future<SearchTaskResult> searchTaskSummary(QueryParam query,
      SearchTaskResult Function(Map<String, dynamic>) fromJsonT) async {
    try {
      final response = await dio.get(
        'request/mobile/task?pageIndex=${query.pageIndex}&pageSize=${query.pageSize}&sorts=${query.sorts}&filters=${query.filters}',
      );

      if (response!.statusCode == 200) {
        return SearchTaskResult.fromJson(response.data);
      }
      throw Exception('Failed to search.');
    } catch (e) {
      print(e);
      throw Exception('Failed to search.');
    }
  }

  Future<dynamic> find(int id) async {
    final response = await dio.get(
      '$id',
    );

    if (response!.statusCode == 200) {
      return response.data;
    }
    throw Exception('Failed to find.');
  }

  Future<List<TaskResModel>> add(TaskOPMultiModel model,
      TaskResModel Function(Map<String, dynamic>) fromJsonT) async {
    final response =
        await dio.post("request/mobile/multi", data: model.toJson());

    if (response?.statusCode == 200) {
      return (response?.data as List).map((d) => fromJsonT(d)).toList();
    } else {
      throw Exception('Failed with status: ${response?.statusCode}');
    }
    // throw Exception('Failed to add task');
  }
}
