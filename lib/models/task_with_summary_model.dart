import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/models/task_summary_model.dart';

part 'task_with_summary_model.g.dart';

@JsonSerializable()
class TaskWithSummaryModel {
  List<TaskSummaryModel>? summaryByStatuses;
  List<TaskModel>? results;
  
  TaskWithSummaryModel({
    this.summaryByStatuses,
    this.results,
    
  });

  factory TaskWithSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$TaskWithSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskWithSummaryModelToJson(this);
}
