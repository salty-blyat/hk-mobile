import 'package:json_annotation/json_annotation.dart';

part 'tenant_model.g.dart';

@JsonSerializable()
class Tenant {
  int? id;
  String? name;
  String? note;
  String? code;
  String? url;
  dynamic dbInfo;
  String? logo;
  String? tenantData;

  Tenant({this.id, this.name, this.note, this.code, this.url, this.dbInfo, this.logo, this.tenantData});

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
  Map<String, dynamic> toJson() => _$TenantToJson(this);
}

