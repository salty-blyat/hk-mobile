import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';
import 'package:staff_view_ui/models/log_model.dart';

part 'request_log_model.g.dart';

@JsonSerializable()
class RequestLogModel extends BaseModel {
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
  int? staffId;
  String? staffName;
  String? positionName;
  String? serviceItemName;
  String? statusNameKh;
  String? statusNameEn;
  String? statusImage;
  List<Attachment>? attachments;
  String? roomNumber;
  String? serviceItemImage;
  String? floorName;
  List<Log>? requestLogs;
  RequestLogModel({
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
    this.staffName,
    this.positionName,
    this.serviceItemName,
    this.statusNameKh,
    this.statusNameEn,
    this.statusImage,
    this.attachments,
    this.staffId,
    this.roomNumber,
    this.serviceItemImage,
    this.floorName,
    this.requestLogs,
  });

  factory RequestLogModel.fromJson(Map<String, dynamic> json) =>
      _$RequestLogModelFromJson(json);
  Map<String, dynamic> toJson() => _$RequestLogModelToJson(this);
}
