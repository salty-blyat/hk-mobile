import 'package:json_annotation/json_annotation.dart';

part 'overtime_type_model.g.dart';

@JsonSerializable()
class OvertimeType {
  int? id;
  String? name;
  int? rate;
  OvertimeType({
    this.id,
    this.name,
    this.rate,
  });

  factory OvertimeType.fromJson(Map<String, dynamic> json) =>
      _$OvertimeTypeFromJson(json);
  Map<String, dynamic> toJson() => _$OvertimeTypeToJson(this);
}
