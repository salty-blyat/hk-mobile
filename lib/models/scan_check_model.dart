import 'package:json_annotation/json_annotation.dart';

part 'scan_check_model.g.dart';

@JsonSerializable()
class ScanCheckModel {
  String? message;
  String? staffCode;
  String? staffName;
  DateTime? dateTime;
  int? type;
  String? terminalName;

  ScanCheckModel(this.message, this.staffCode, this.staffName, this.dateTime,
      this.type, this.terminalName);

  factory ScanCheckModel.fromJson(Map<String, dynamic> json) =>
      _$ScanCheckModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScanCheckModelToJson(this);
}
