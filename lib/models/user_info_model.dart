import 'package:json_annotation/json_annotation.dart';

part 'user_info_model.g.dart';

@JsonSerializable()
class Staff {
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

  Staff(
      {
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

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
  Map<String, dynamic> toJson() => _$StaffToJson(this);
}
