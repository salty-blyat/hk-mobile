import 'package:json_annotation/json_annotation.dart';

part 'lookup_model.g.dart';

@JsonSerializable()
class LookupModel {
  final int? id;
  final int? lookupTypeId;
  final String? name;
  final String? nameKh;
  final int? ordering;
  final String? note;
  final dynamic image;
  final String? lookupTypeName;

  LookupModel({
    this.id,
    this.lookupTypeId,
    this.name,
    this.nameKh,
    this.ordering,
    this.note,
    this.image,
    this.lookupTypeName,
  });

  factory LookupModel.fromJson(Map<String, dynamic> json) =>
      _$LookupModelFromJson(json);

  Map<String, dynamic> toJson() => _$LookupModelToJson(this);
}
