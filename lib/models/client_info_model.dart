import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/models/app_model.dart';

part 'client_info_model.g.dart';

@JsonSerializable()
class ClientInfo {
  int? id;
  String? name;
  String? fullName;
  String? email;
  String? phone;
  String? token;
  String? branchId;
  String? refreshToken;
  bool? changePasswordRequired;
  bool? isEnabled2FA;
  int? verifyMethod2FA;
  List<int>? permissions;
  String? profile;
  List<App>? apps;
  ClientInfo({this.id, this.name, this.fullName, this.email, this.phone, this.token, this.branchId, this.refreshToken, this.changePasswordRequired, this.isEnabled2FA, this.verifyMethod2FA, this.permissions, this.profile, this.apps});

  factory ClientInfo.fromJson(Map<String, dynamic> json) => _$ClientInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ClientInfoToJson(this);
}