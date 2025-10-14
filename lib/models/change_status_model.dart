import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';

part 'change_status_model.g.dart';

@JsonSerializable()
class ChangeStatusModel {
  int? id;
  String? note;
   ChangeStatusModel({
this.   id,
this.note,});

  factory ChangeStatusModel.fromJson(Map<String, dynamic> json) =>
      _$ChangeStatusModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChangeStatusModelToJson(this);
}
