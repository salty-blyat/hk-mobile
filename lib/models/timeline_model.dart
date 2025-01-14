import 'package:json_annotation/json_annotation.dart';
part 'timeline_model.g.dart';

@JsonSerializable()
class TimelineModel {
  int? id;
  int? status;
  String? statusNameKh;
  String? statusName;
  String? note;
  int? approverId;
  String? approverName;
  String? positionName;
  String? departmentName;
  String? branchName;
  DateTime? createdDate;
  String? createdBy;

  TimelineModel({
    this.id,
    this.status,
    this.statusNameKh,
    this.statusName,
    this.note,
    this.approverId,
    this.approverName,
    this.positionName,
    this.departmentName,
    this.branchName,
    this.createdDate,
    this.createdBy,
  });

  factory TimelineModel.fromJson(Map<String, dynamic> json) =>
      _$TimelineModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimelineModelToJson(this);
}
