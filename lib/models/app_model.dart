import 'package:json_annotation/json_annotation.dart';

part 'app_model.g.dart';

@JsonSerializable()
class App {
  int? id;
  String? code;
  String? name;
  int? appId;
  String? appName;
  String? appCode;
  dynamic language;
  String? url;
  dynamic dbInfo;
  String? iconUrl;

  App({this.id, this.code, this.name, this.appId, this.appName, this.language, this.url, this.dbInfo, this.iconUrl});

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);
  Map<String, dynamic> toJson() => _$AppToJson(this);
}

