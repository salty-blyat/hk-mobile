import 'package:json_annotation/json_annotation.dart';

part 'housekeeping_model.g.dart';

@JsonSerializable()
class Housekeeping {
  String? roomNumber;
  String? roomTypeName;
  String? blockName;
  String? floorName;
  String? statusNameKh;
  String? statusNameEn;
  String? houseKeepingStatusNameKh;
  String? houseKeepingStatusNameEn;
  String? note;
  String? startDate;
  String? endDate;
  String? hkStaffName;
  String? activityDate;
  int? status;
  String? statusColor;
  String? statusImage;
  int? houseKeepingStatus;
  String? houseKeepingStatusColor;
  String? houseKeepingStatusImage;
  int? roomId;
  int? roomTypeId;
  int? blockId;
  int? floorId;
  int? staffId;
  int? hkStaffId;
  int? blockStaffId; 
  Housekeeping(
      {
this.roomNumber,
this.roomTypeName,
this.blockName,
this.floorName,
this.statusNameKh,
this.statusNameEn,
this.houseKeepingStatusNameKh,
this.houseKeepingStatusNameEn,
this.note,
this.startDate,
this.endDate,
this.hkStaffName,
this.activityDate,
this.status,
this.statusColor,
this.statusImage,
this.houseKeepingStatus,
this.houseKeepingStatusColor,
this.houseKeepingStatusImage,
this.roomId,
this.roomTypeId,
this.blockId,
this.floorId,
this.staffId,
this.hkStaffId,
this.blockStaffId,
     });

  factory Housekeeping.fromJson(Map<String, dynamic> json) =>
      _$HousekeepingFromJson(json);
  Map<String, dynamic> toJson() => _$HousekeepingToJson(this);
}
