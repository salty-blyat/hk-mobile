import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';

part 'service_item_model.g.dart';

@JsonSerializable()
class ServiceItem extends BaseModel {
  bool? trackQty;
  String? departmentName;
  String? serviceTypeName;
  String? name;
  int? serviceTypeId;
  int? departmentId;
  int? maxQty;
  String? image;
  String? description;

  ServiceItem({
    this.trackQty,
    this.departmentName,
    this.serviceTypeName,
    this.name,
    this.serviceTypeId,
    this.departmentId,
    this.maxQty,
    this.image,
    this.description,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) =>
      _$ServiceItemFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceItemToJson(this);
}
