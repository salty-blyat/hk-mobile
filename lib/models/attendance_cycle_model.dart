import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';

part 'attendance_cycle_model.g.dart';

@JsonSerializable()
class AttendanceCycleModel extends BaseModel {
  String? name;
  DateTime? start;
  DateTime? end;

  AttendanceCycleModel({this.name, this.start, this.end});

  factory AttendanceCycleModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceCycleModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceCycleModelToJson(this);
}
