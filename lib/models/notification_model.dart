import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel extends BaseModel {
  final int? requestId;
  final int? staffId;
  final String? title;
  final String? message;
  final bool? isView;
  final DateTime? viewDate;
  final DateTime? createdDate;

  NotificationModel(
      {this.requestId,
      this.staffId,
      this.title,
      this.message,
      this.isView,
      this.viewDate,
      this.createdDate});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
