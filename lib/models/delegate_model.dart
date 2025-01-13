import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart';

part 'delegate_model.g.dart';

@JsonSerializable()
class Delegate extends BaseModel {
  int? staffId;
  int? delegateStaffId;
  String? fromDate;
  String? toDate;
  @override
  String? note;
  String? staffName;
  String? staffDelegateName;
  String? delegatePhoto;
  String? delegateTitle;
  String? delegateTitleKh;
  String? delegatePosition;
  Delegate({
    this.staffId,
    this.delegateStaffId,
    this.fromDate,
    this.toDate,
    this.note,
    this.staffName,
    this.staffDelegateName,
    this.delegatePhoto,
    this.delegateTitle,
    this.delegateTitleKh,
    this.delegatePosition,
  });

  factory Delegate.fromJson(Map<String, dynamic> json) =>
      _$DelegateFromJson(json);

  Map<String, dynamic> toJson() => _$DelegateToJson(this);
}
