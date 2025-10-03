import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';

part 'task_summary_model.g.dart';

@JsonSerializable()
class TaskSummaryModel {
  int? id;
  String? name;
  String? nameEn;
  int? value;

  TaskSummaryModel({
    this.id,
    this.name,
    this.value,
  });

  factory TaskSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$TaskSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskSummaryModelToJson(this);
}
