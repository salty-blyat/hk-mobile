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
    required this.requestNo,
    required this.leaveTypeId,
    required this.totalDays,
    required this.fromDate,
    required this.toDate,
    required this.requestedDate,
    required this.approvedDate,
    required this.reason,
    required this.attachments,
    required this.attachmentString,
    required this.approverId,
    required this.approvedBy,
    required this.status,
    required this.fromShiftId,
    required this.toShiftId,
    required this.balance,
    required this.totalHours,
  });

  factory Leave.fromJson(Map<String, dynamic> json) => _$LeaveFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveToJson(this);
}
