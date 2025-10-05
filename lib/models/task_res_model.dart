import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';
import 'package:staff_view_ui/models/log_model.dart';

part 'task_res_model.g.dart';

@JsonSerializable()
class TaskResModel extends BaseModel {
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
  String? staffName;
  String? positionName;
  String? serviceItemName;
  String? statusNameKh;
  String? statusNameEn;
  String? statusImage;
  List<Attachment>? attachments;
  List<LogModel>? requestLogs;

  TaskResModel(
      {this.requestNo,
      this.requestTime,
      this.requestType,
      this.guestId,
      this.roomId,
      this.reservationId,
      this.serviceTypeId,
      this.serviceItemId,
      this.quantity,
      this.status,
      this.staffName,
      this.positionName,
      this.serviceItemName,
      this.statusNameKh,
      this.statusNameEn,
      this.statusImage,
      this.attachments,
      this.requestLogs});

  factory TaskResModel.fromJson(Map<String, dynamic> json) =>
      _$TaskResModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskResModelToJson(this);
}
