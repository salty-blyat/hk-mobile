import 'package:staff_view_ui/models/attachment_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leave_model.g.dart';

@JsonSerializable()
class Leave {
  final String? requestNo;
  final int? leaveTypeId;
  final int? totalDays;
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
  final int? balance;
  final int? totalHours;
  Leave({
    this.requestNo,
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
