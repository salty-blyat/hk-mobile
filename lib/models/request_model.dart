import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/models/timeline_model.dart';

part 'request_model.g.dart';

@JsonSerializable()
class RequestModel extends BaseModel {
  int? staffId;
  String? requestNo;
  DateTime? requestedDate;
  int? requestType;
  int? requestTypeId;
  String? title;
  String? requestData;
  int? approvalRuleId;
  int? lastStepId;
  String? nextApproverIds;
  String? photo;
  int? status;
  String? staffNameKh;
  String? staffNameEn;
  String? staffCode;
  String? statusName;
  String? statusNameKh;
  String? requestTypeName;
  int? positionId;
  String? positionCode;
  String? positionName;
  int? departmentId;
  String? departmentCode;
  String? departmentName;
  DateTime? createdDate;
  bool? canDoAction;
  int? delegatorId;
  List<TimelineModel>? requestLogs;

  RequestModel({
    this.requestLogs,
    this.staffId,
    this.photo,
    this.requestNo,
    this.requestedDate,
    this.requestType,
    this.requestTypeId,
    this.title,
    this.requestData,
    this.approvalRuleId,
    this.lastStepId,
    this.nextApproverIds,
    this.status,
    this.staffNameKh,
    this.staffNameEn,
    this.staffCode,
    this.statusName,
    this.statusNameKh,
    this.requestTypeName,
    this.positionId,
    this.positionCode,
    this.positionName,
    this.departmentId,
    this.departmentCode,
    this.departmentName,
    this.createdDate,
    this.canDoAction,
    this.delegatorId,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) =>
      _$RequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RequestModelToJson(this);
}

@JsonSerializable()
class TotalModel {
  final int? totalLeave;
  final int? totalOT;
  final int? totalException;

  TotalModel({
    this.totalLeave,
    this.totalOT,
    this.totalException,
  });

  factory TotalModel.fromJson(Map<String, dynamic> json) =>
      _$TotalModelFromJson(json);

  Map<String, dynamic> toJson() => _$TotalModelToJson(this);
}
