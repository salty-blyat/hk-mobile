import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';

part 'attendance_terminal_model.g.dart';

@JsonSerializable()
class AttendanceTerminalModel extends BaseModel {
  String? name;
  int? terminalTypeId;
  int? branchId;
  String? settingData;
  bool? customEnrollment;
  String? latitude;
  String? longitude;
  bool? isCheckIn;
  bool? isCheckOut;
  String? address;
  String? username;
  String? password;
  DateTime? fromDate;
  DateTime? toDate;
  String? terminalTypeName;
  String? branchName;
  String? key;
  String? statusName;
  String? statusNameKh;
  int? status;
  DateTime? statusDate;

  AttendanceTerminalModel(
    this.name,
    this.terminalTypeId,
    this.branchId,
    this.settingData,
    this.customEnrollment,
    this.latitude,
    this.longitude,
    this.isCheckIn,
    this.isCheckOut,
    this.address,
    this.username,
    this.password,
    this.fromDate,
    this.toDate,
    this.terminalTypeName,
    this.branchName,
    this.key,
    this.statusName,
    this.statusNameKh,
    this.status,
    this.statusDate,
  );

  factory AttendanceTerminalModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceTerminalModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceTerminalModelToJson(this);
}
