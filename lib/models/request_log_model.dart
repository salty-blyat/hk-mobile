import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/attachment_model.dart';
import 'package:staff_view_ui/models/log_model.dart';

part 'request_log_model.g.dart';

@JsonSerializable()
class RequestLog extends BaseModel {
  String? serviceItemName;
  String? statusNameKh;
  String? statusNameEn;
  String? statusImage;
  List<Attachment>? attachments;
  String? requestNo;
  String? requestTime;
  int? guestId;
  int? roomId;
  int? reservationId;
  int? serviceTypeId;
  int? serviceItemId;
  int? quantity;
  int? status;
  List<Log>? requestLogs;
  RequestLog({
    
this.serviceItemName,
this.statusNameKh,
this.statusNameEn,
this.statusImage,
this.attachments,
this.requestNo,
this.requestTime,
this.guestId,
this.roomId,
this.reservationId,
this.serviceTypeId,
this.serviceItemId,
this.quantity,
this.status,
this.requestLogs,

  });

  factory RequestLog.fromJson(Map<String, dynamic> json) =>
      _$RequestLogFromJson(json);
  Map<String, dynamic> toJson() => _$RequestLogToJson(this);
}
