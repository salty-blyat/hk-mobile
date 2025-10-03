import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel extends BaseModel {
  String? requestNo;
  DateTime? requestTime;
  int? requestType;
  int? guestId;
  int? roomId;
  int? reservationId;
  int? serviceTypeId;
  int? serviceItemId;
  int? quantity;
  int? status;
  String? statusNameKh;
  String? statusNameEn;
  String? statusImage;
  String? statusColor;
  String? guestName;
  String? roomNo;
  String? roomTypeName;
  int? staffId;
  String? staffName;
  String? serviceItemName;
  String? serviceItemImage;
  List<Attachment>? attachments;
  DateTime? lastModifiedDate;
  String? lastModifiedBy;
 
  TaskModel({
    this.requestNo,
    this.requestTime,
    this.requestType,
    this.guestId,
    this.roomId,
    this.reservationId,
    this.serviceTypeId,
    this.serviceItemId,
    this.quantity,
    this.status,
    this.statusNameKh,
    this.statusNameEn,
    this.statusImage,
    this.statusColor,
    this.guestName,
    this.roomNo,
    this.roomTypeName,
    this.staffId,
    this.staffName,
    this.serviceItemName,
    this.serviceItemImage,
    this.attachments,
    this.lastModifiedDate,
    this.lastModifiedBy,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);
}
