import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_model.g.dart';

@JsonSerializable()
class RefreshTokenMobile {
  String? accessToken;
  String? refreshToken;
  List<int>? permissions;

  RefreshTokenMobile({this.accessToken, this.refreshToken, this.permissions});

  factory RefreshTokenMobile.fromJson(Map<String, dynamic> json) => _$RefreshTokenMobileFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshTokenMobileToJson(this);
}