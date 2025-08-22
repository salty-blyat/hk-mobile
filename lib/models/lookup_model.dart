import 'package:json_annotation/json_annotation.dart';

part 'lookup_model.g.dart';

@JsonSerializable()
class LookupModel {
  final int? id;
  final int? lookupTypeId;
  final String? name;
  final String? nameEn;
  final int? ordering;
  final String? note;
  final dynamic image;
  final int? valueId;
  final String? color;
  final String? lookupTypeName;

  LookupModel({
    this.id,
    this.lookupTypeId,
    this.name,
    this.nameEn,
    this.ordering,
    this.note,
    this.valueId,
    this.image,
    this.color,
    this.lookupTypeName,
  });

  factory LookupModel.fromJson(Map<String, dynamic> json) =>
      _$LookupModelFromJson(json);

  Map<String, dynamic> toJson() => _$LookupModelToJson(this);
}
