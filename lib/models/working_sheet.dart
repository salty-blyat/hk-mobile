import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';

part 'working_sheet.g.dart';

@JsonSerializable()
class Worksheets extends BaseModel {
  final DateTime? date;
  final String? day;
  final double? expectedWorkingHour;
  final double? absentAuthHour;
  final double? absentAvailableAuthHour;
  final double? absentUnAuthHour;
  final double? adrWorkingHour;
  final int? type;
  final double? dutyRated;
  final String? holiday;
  final int? holidayId;
  final int? missionId;
  final String? missionObjective;
  final String? leaveReason;
  final String? leaveType;
  final int? leaveId;
  final int? leaveTypeId;
  final String? shiftClockIn;
  final String? shiftClockOut;
  final double? actualWorkingHour;
  final String? actualIn;
  final String? actualOut;
  final double? workingHour;
  final String? extData;
  final int? exceptionId;
  final int? absentType;
  final String? absentTypeNameKh;
  final String? absentTypeNameEn;
  final int? exceptionTypeId;
  final String? exceptionTypeName;
  final int? scanType;
  final String? scanTypeNameEn;
  final String? scanTypeNameKh;
  final String? exceptionNote;

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
    this.exceptionId,
    this.absentType,
    this.absentTypeNameKh,
    this.absentTypeNameEn,
    this.exceptionTypeId,
    this.exceptionTypeName,
    this.scanType,
    this.scanTypeNameEn,
    this.scanTypeNameKh,
    this.exceptionNote,
  });

  factory Worksheets.fromJson(Map<String, dynamic> json) =>
      _$WorksheetsFromJson(json);
  Map<String, dynamic> toJson() => _$WorksheetsToJson(this);
}
