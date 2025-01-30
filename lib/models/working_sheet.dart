import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';

part 'working_sheet.g.dart';

@JsonSerializable()
class Worksheets extends BaseModel {
  DateTime? date;
  String? day;
  double? expectedWorkingHour;
  double? absentAuthHour;
  double? absentAvailableAuthHour;
  double? absentUnAuthHour;
  double? adrWorkingHour;
  int? type;
  double? dutyRated;
  String? holiday;
  int? holidayId;
  int? missionId;
  String? missionObjective;
  String? leaveReason;
  String? leaveType;
  int? leaveId;
  int? leaveTypeId;
  String? shiftClockIn;
  String? shiftClockOut;
  double? actualWorkingHour;
  String? actualIn;
  String? actualOut;
  double? workingHour;
  String? extData;

  Worksheets({
    this.date,
    this.day,
    this.expectedWorkingHour,
    this.absentAuthHour,
    this.absentAvailableAuthHour,
    this.absentUnAuthHour,
    this.adrWorkingHour,
    this.type,
    this.dutyRated,
    this.holiday,
    this.holidayId,
    this.missionId,
    this.missionObjective,
    this.leaveReason,
    this.leaveType,
    this.leaveId,
    this.leaveTypeId,
    this.shiftClockIn,
    this.shiftClockOut,
    this.actualWorkingHour,
    this.actualIn,
    this.actualOut,
    this.workingHour,
    this.extData,
  });

  factory Worksheets.fromJson(Map<String, dynamic> json) =>
      _$WorksheetsFromJson(json);
  Map<String, dynamic> toJson() => _$WorksheetsToJson(this);
}
