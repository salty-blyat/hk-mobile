import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';

part 'task_op_multi_model.g.dart';

@JsonSerializable()
class TaskOPMultiModel {
  List<int>? roomIds;
  int? staffId;
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
  String? note;
  List<Attachment>? attachments;

  TaskOPMultiModel({
    this.roomIds,
    this.staffId,
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
    this.note,
    this.attachments,
  });

  factory TaskOPMultiModel.fromJson(Map<String, dynamic> json) =>
      _$TaskOPMultiModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskOPMultiModelToJson(this);
}
