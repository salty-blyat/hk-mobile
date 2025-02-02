import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leave_balance_model.g.dart'; // This is the generated file

// Define the LeaveBalanceModel class
@JsonSerializable()
class LeaveBalanceModel extends BaseModel {
  final int? staffId;
  final String? staffName;
  final String? staffCode;
  final int? positionId;
  final String? positionName;
  final int? totalAvail;
  final int? totalEntitle;
  final int? departmentId;
  final String? departmentName;
  final List<LeaveBalances>? leaveBalances;

  LeaveBalanceModel({
    this.staffId,
    this.staffName,
    this.staffCode,
    this.positionId,
    this.positionName,
    this.totalAvail,
    this.totalEntitle,
    this.departmentId,
    this.departmentName,
    this.leaveBalances,
  });

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveBalanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveBalanceModelToJson(this);
}

// Define the LeaveBalances class
@JsonSerializable()
class LeaveBalances {
  final int? leaveTypeId;
  final int? totalAvail;
  final int? totalEntitle;

  LeaveBalances({
    this.leaveTypeId,
    this.totalAvail,
    this.totalEntitle,
  });

  factory LeaveBalances.fromJson(Map<String, dynamic> json) =>
      _$LeaveBalancesFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveBalancesToJson(this);

  where(bool Function(dynamic item) param0) {}
}
