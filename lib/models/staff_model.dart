import 'package:json_annotation/json_annotation.dart';

part 'staff_model.g.dart';

@JsonSerializable()
class Staff {
  final int? id;
  final int? tittleId;
  final int? scheduleId;
  final String? name;
  final String? latinName;
  final String? code;
  final String? sexName;
  final String? sexNameKh;
  final String? phone;
  final String? positionName;
  final String? departmentName;
  final String? branchName;
  final String? tittleName;
  final String? photo;

  Staff({
    this.id,
    this.tittleId,
    this.scheduleId,
    this.name,
    this.latinName,
    this.code,
    this.sexName,
    this.sexNameKh,
    this.phone,
    this.positionName,
    this.departmentName,
    this.branchName,
    this.tittleName,
    this.photo,
  });

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
  Map<String, dynamic> toJson() => _$StaffToJson(this);
}
