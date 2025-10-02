import 'package:json_annotation/json_annotation.dart';

part 'housekeeping_model.g.dart';

@JsonSerializable()
class Housekeeping {
  String? roomNumber;
  String? blockName;
  String? description;
  int? roomTypeId;
  int? floorId;
  List<int>? tagIds;
  int? status;
  int? houseKeepingStatus;
  int? id;
  String? floorName;
  String? roomTypeName;
  String? roomClassNameKh;
  String? roomClassNameEn;
  String? statusNameEn;
  String? statusNameKh;
  String? statusImage;
  String? houseKeepingStatusNameEn;
  String? houseKeepingStatusNameKh;
  String? houseKeepingStatusImage;
  List<String>? tagNames;
  int? total;
  int? pending;

  Housekeeping(
      {this.roomNumber,
      this.description,
      this.blockName,
      this.roomTypeId,
      this.floorId,
      this.tagIds,
      this.status,
      this.houseKeepingStatus,
      this.id,
      this.floorName,
      this.roomTypeName,
      this.roomClassNameKh,
      this.roomClassNameEn,
      this.statusNameEn,
      this.statusNameKh,
      this.statusImage,
      this.houseKeepingStatusNameEn,
      this.houseKeepingStatusNameKh,
      this.houseKeepingStatusImage,
      this.tagNames,
      this.total,
      this.pending});

  factory Housekeeping.fromJson(Map<String, dynamic> json) =>
      _$HousekeepingFromJson(json);
  Map<String, dynamic> toJson() => _$HousekeepingToJson(this);
}
