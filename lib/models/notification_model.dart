import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  int? id;
  int? requestId;
  String? title;
  String? message;
  bool? isView;
  DateTime? viewDate;
  int? staffId;
  bool? isSentSuccessfully;
  String? staffName;
  String? serviceItem;
  String? serviceItemType;
  int? requestType;
  int? quantity;
  String? roomNumber;
  String? floorName;
  DateTime? createdDate;

  NotificationModel({
    this.id,
    this.requestId,
    this.title,
    this.message,
    this.isView,
    this.viewDate,
    this.staffId,
    this.isSentSuccessfully,
    this.staffName,
    this.serviceItem,
    this.serviceItemType,
    this.requestType,
    this.quantity,
    this.roomNumber,
    this.floorName,
    this.createdDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
