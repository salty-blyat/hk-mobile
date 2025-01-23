import 'package:json_annotation/json_annotation.dart';

part 'exception_type_model.g.dart';

@JsonSerializable()
class ExceptionTypeModel {
  String? name;
  String? code;
  bool? autoApprove;
  String? note;
  int? id;

  ExceptionTypeModel(
      {this.name, this.code, this.autoApprove, this.note, this.id});

  factory ExceptionTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ExceptionTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExceptionTypeModelToJson(this);
}
