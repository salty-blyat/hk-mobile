import 'package:json_annotation/json_annotation.dart';

part 'notification_mark_model.g.dart';


@JsonSerializable()
class NotificationMarkModel {
  int? requestId;
  String? title;
  String? message;
  bool? isView;
  DateTime? viewDate;
  int? staffId;
  bool? isSentSuccessfully;

  NotificationMarkModel({
    this.requestId,
    this.title,
    this.message,
    this.isView,
    this.viewDate,
    this.staffId,
    this.isSentSuccessfully,
  });

  factory NotificationMarkModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationMarkModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationMarkModelToJson(this);
}
