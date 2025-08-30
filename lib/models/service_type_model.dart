import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';

part 'service_type_model.g.dart';

@JsonSerializable()
class ServiceType extends BaseModel {
  int? valueId;
  String? lookupTypeName;
  bool? canRemove;
  int? lookupTypeId;
  String? name;
  String? nameEn;
  int? ordering;
  String? image;
  String? color;

  ServiceType({
    this.valueId,
    this.lookupTypeName,
    this.canRemove,
    this.lookupTypeId,
    this.name,
    this.nameEn,
    this.ordering,
    this.image,
    this.color,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) =>
      _$ServiceTypeFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceTypeToJson(this);
}
