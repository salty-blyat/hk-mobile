// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delegate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delegate _$DelegateFromJson(Map<String, dynamic> json) => Delegate(
      staffId: (json['staffId'] as num?)?.toInt(),
      delegateStaffId: (json['delegateStaffId'] as num?)?.toInt(),
      fromDate: json['fromDate'] == null
          ? null
          : DateTime.parse(json['fromDate'] as String),
      toDate: json['toDate'] == null
          ? null
          : DateTime.parse(json['toDate'] as String),
      note: json['note'] as String?,
      staffName: json['staffName'] as String?,
      staffDelegateName: json['staffDelegateName'] as String?,
      delegatePhoto: json['delegatePhoto'] as String?,
      delegateTitle: json['delegateTitle'] as String?,
      delegateTitleKh: json['delegateTitleKh'] as String?,
      delegatePosition: json['delegatePosition'] as String?,
    )..id = (json['id'] as num?)?.toInt();

Map<String, dynamic> _$DelegateToJson(Delegate instance) => <String, dynamic>{
      'id': instance.id,
      'staffId': instance.staffId,
      'delegateStaffId': instance.delegateStaffId,
      'fromDate': instance.fromDate,
      'toDate': instance.toDate,
      'note': instance.note,
      'staffName': instance.staffName,
      'staffDelegateName': instance.staffDelegateName,
      'delegatePhoto': instance.delegatePhoto,
      'delegateTitle': instance.delegateTitle,
      'delegateTitleKh': instance.delegateTitleKh,
      'delegatePosition': instance.delegatePosition,
    };
