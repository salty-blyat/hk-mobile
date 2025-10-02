import 'package:json_annotation/json_annotation.dart';

part 'staff_user_model.g.dart';

@JsonSerializable()
class StaffUserModel {
  int? staffId;
  int? positionId;
  String? staffCode;
  String? staffName;
  String? staffPhone;
  String? positionName;

  StaffUserModel({
    this.staffId,
    this.positionId,
    this.staffCode,
    this.staffName,
    this.staffPhone,
    this.positionName,
  });

  factory StaffUserModel.fromJson(Map<String, dynamic> json) =>
      _$StaffUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$StaffUserModelToJson(this);
}
