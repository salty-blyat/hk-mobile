import 'package:json_annotation/json_annotation.dart';

part 'company_info_model.g.dart';

@JsonSerializable()
class CompanyInfo {
  String? name;
  String? logo;
  String? phone;
  String? address;

  CompanyInfo({this.name, this.logo, this.phone, this.address});

  factory CompanyInfo.fromJson(Map<String, dynamic> json) => _$CompanyInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyInfoToJson(this);
}