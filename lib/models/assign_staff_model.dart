import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';

part 'assign_staff_model.g.dart';

@JsonSerializable()
class AssignStaffModel {
  int? requestId;
  int? staffId;
  String? note;
  AssignStaffModel({
    this.requestId,
    this.staffId,
    this.note,
  });

  factory AssignStaffModel.fromJson(Map<String, dynamic> json) =>
      _$AssignStaffModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssignStaffModelToJson(this);
}
