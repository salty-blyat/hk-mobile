import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';

part 'exception_model.g.dart';

@JsonSerializable()
class ExceptionModel extends BaseModel {
  final String? requestNo;
  final int? staffId;
  final int? terminalId;
  final int? exceptionTypeId;
  final DateTime? requestedDate;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<Attachment>? attachments;
  final String? attachmentString;
  final int? scanType;
  final String? scanTime;
  final String? date;
  final int? duration;
  final int? totalDays;
  final int? absentType;
  final int? totalHours;
  final String? exceptionTypeName;
  final String? staffName;
  final String? staffCode;
  final int? positionId;
  final String? positionName;
  final String? departmentName;
  final int? departmentId;
  final int? branchId;
  final String? branchName;
  final int? status;
  final String? approvedBy;
  final DateTime? approvedDate;
  final DateTime? createdDate;
  final int? approverId;
  final String? statusName;
  final String? statusNameKh;
  final String? scanTypeName;
  final String? scanTypeNameKh;
  final String? absentTypeNameKh;
  final String? absentTypeNameEn;
  final String? terminalName;

  ExceptionModel(
      {this.requestNo,
      this.staffId,
      this.terminalId,
      this.exceptionTypeId,
      this.requestedDate,
      this.fromDate,
      this.toDate,
      this.attachments,
      this.attachmentString,
      this.scanType,
      this.scanTime,
      this.date,
      this.duration,
      this.totalDays,
      this.absentType,
      this.totalHours,
      this.exceptionTypeName,
      this.staffName,
      this.staffCode,
      this.positionId,
      this.positionName,
      this.departmentName,
      this.departmentId,
      this.branchId,
      this.branchName,
      this.status,
      this.approvedBy,
      this.approvedDate,
      this.createdDate,
      this.approverId,
      this.statusName,
      this.statusNameKh,
      this.scanTypeName,
      this.scanTypeNameKh,
      this.absentTypeNameKh,
      this.absentTypeNameEn,
      this.terminalName});

  factory ExceptionModel.fromJson(Map<String, dynamic> json) =>
      _$ExceptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExceptionModelToJson(this);
}
