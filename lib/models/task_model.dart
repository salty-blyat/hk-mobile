import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel extends BaseModel {
  String? statusNameKh;
  String? statusNameEn;
  String? statusImage;
  String? statusColor;
  String? guestName;
  String? roomNo;
  String? roomTypeName;
  String? staffName;
  String? serviceItemName;
  String? serviceItemImage;
  List<Attachment>? attachments;
  String? lastModifiedDate;
  String? lastModifiedBy;
  String? requestNo;
  DateTime? requestTime;
  int? guestId;
  int? roomId;
  int? reservationId;
  int? serviceTypeId;
  int? serviceItemId;
  int? quantity;
  int? status;
  TaskModel({
    this.statusNameKh,
    this.statusNameEn,
    this.statusImage,
    this.statusColor,
    this.guestName,
    this.roomNo,
    this.roomTypeName,
    this.staffName,
    this.serviceItemName,
    this.serviceItemImage,
    this.lastModifiedDate,
    this.lastModifiedBy,
    this.requestNo,
    this.requestTime,
    this.guestId,
    this.roomId,
    this.reservationId,
    this.serviceTypeId,
    this.serviceItemId,
    this.quantity,
    this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}
