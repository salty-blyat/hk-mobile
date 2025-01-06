import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leave_model.g.dart';

@JsonSerializable()
class Leave extends BaseModel {
  final String? requestNo;
  final int? staffId;
  final int? leaveTypeId;
  final double? totalDays;
  final DateTime? fromDate;
  final DateTime? toDate;
  final DateTime? requestedDate;
  final DateTime? approvedDate;
  final String? reason;
  final List<Attachment>? attachments;
  final String? attachmentString;
  final int? approverId;
  final String? approvedBy;
  final int? status;
  final int? fromShiftId;
  final int? toShiftId;
  final double? balance;
  final double? totalHours;
  final String? leaveTypeName;
  final String? leaveTypeCode;
  final bool? leaveTypeTrackBalance;
  final String? staffName;
  final String? staffCode;
  final int? positionId;
  final String? positionName;
  final int? branchId;
  final String? branchCode;
  final String? branchName;
  final int? departmentId;
  final int? deductDay;
  final String? statusName;
  final String? statusNameKh;

  Leave({
    this.leaveTypeName,
    this.leaveTypeCode,
    this.leaveTypeTrackBalance,
    this.staffName,
    this.staffCode,
    this.positionId,
    this.positionName,
    this.branchId,
    this.branchCode,
    this.branchName,
    this.departmentId,
    this.deductDay,
    this.statusName,
    this.statusNameKh,
    this.requestNo,
    this.staffId,
    this.leaveTypeId,
    this.totalDays,
    this.fromDate,
    this.toDate,
    this.requestedDate,
    this.approvedDate,
    this.reason,
    this.attachments,
    this.attachmentString,
    this.approverId,
    this.approvedBy,
    this.status,
    this.fromShiftId,
    this.toShiftId,
    this.balance,
    this.totalHours,
  });

  factory Leave.fromJson(Map<String, dynamic> json) => _$LeaveFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveToJson(this);
}
