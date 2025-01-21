import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';

part 'overtime_model.g.dart';

@JsonSerializable()
class Overtime extends BaseModel {
  final int? staffId;
  final String? requestNo;
  final int? overtimeTypeId;
  final DateTime? requestedDate;
  final DateTime? date;
  final DateTime? fromTime;
  final DateTime? toTime;
  final int? overtimeHour;
  @override
  final String? note;
  final List<Attachment>? attachments;
  final String? attachmentString;
  @override
  final int? id;
  final String? overtimeTypeName;
  final String? staffName;
  final String? staffCode;
  final int? positionId;
  final String? positionName;
  final int? branchId;
  final String? branchName;
  final String? branchCode;
  final int? departmentId;
  final String? departmentName;
  final int? status;
  final String? approvedBy;
  final DateTime? approvedDate;
  final DateTime? createdDate;
  final String? statusName;
  final String? statusNameKh;
  Overtime(
      {this.requestNo,
      this.staffId,
      this.overtimeTypeId,
      this.requestedDate,
      this.date,
      this.fromTime,
      this.toTime,
      this.overtimeHour,
      this.note,
      this.attachments,
      this.attachmentString,
      this.id,
      this.overtimeTypeName,
      this.staffName,
      this.staffCode,
      this.positionId,
      this.positionName,
      this.branchId,
      this.branchName,
      this.branchCode,
      this.departmentId,
      this.departmentName,
      this.status,
      this.approvedBy,
      this.approvedDate,
      this.createdDate,
      this.statusName,
      this.statusNameKh});

  factory Overtime.fromJson(Map<String, dynamic> json) =>
      _$OvertimeFromJson(json);
  Map<String, dynamic> toJson() => _$OvertimeToJson(this);
}
