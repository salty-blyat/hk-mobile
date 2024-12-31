import 'package:json_annotation/json_annotation.dart';

part 'leave_type_model.g.dart';

@JsonSerializable()
class LeaveType {
  int? id;
  String? name;
  String? code;
  bool? trackBalance;
  int? entitleType;
  bool? isAllowHour;
  String? note;
  String? entitleTypeName;
  LeaveType({
    this.id,
    this.name,
    this.code,
    this.trackBalance,
    this.entitleType,
    this.isAllowHour,
    this.note,
    this.entitleTypeName,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) =>
      _$LeaveTypeFromJson(json);
  Map<String, dynamic> toJson() => _$LeaveTypeToJson(this);
}
