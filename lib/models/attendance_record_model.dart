import 'package:json_annotation/json_annotation.dart';

part 'attendance_record_model.g.dart';

@JsonSerializable()
class AttendanceRecordModel {
  int? id;
  String? fileName;
  String? staffNameLatin;
  String? terminalName;
  String? staffName;
  String? staffCode;
  int? scanType;
  String? checkInOutTypeNameKh;
  String? checkInOutTypeName;
  int? uploadId;
  int? terminalId;
  String? enrollmentNo;
  DateTime? time;
  int? staffId;

  AttendanceRecordModel(
      this.id,
      this.fileName,
      this.staffNameLatin,
      this.terminalName,
      this.staffName,
      this.staffCode,
      this.scanType,
      this.checkInOutTypeNameKh,
      this.checkInOutTypeName,
      this.uploadId,
      this.terminalId,
      this.enrollmentNo,
      this.time,
      this.staffId);

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceRecordModelToJson(this);
}
