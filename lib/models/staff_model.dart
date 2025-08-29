import 'package:json_annotation/json_annotation.dart';

part 'staff_model.g.dart';

@JsonSerializable()
class StaffModel {
  int? id;
  String? positionNameEn;
  String? positionNameKh;
  String? sexNameKh;
  String? sexNameEn;
  String? code;
  String? name;
  int? sexId;
  int? positionId;
  String? phone;
  String? address;

  StaffModel({
    this.id,
    this.positionNameEn,
    this.positionNameKh,
    this.sexNameKh,
    this.sexNameEn,
    this.code,
    this.name,
    this.sexId,
    this.positionId,
    this.phone,
    this.address,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) => _$StaffModelFromJson(json);
  Map<String, dynamic> toJson() => _$StaffModelToJson(this);
}
