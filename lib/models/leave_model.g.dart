// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Leave _$LeaveFromJson(Map<String, dynamic> json) => Leave(
      requestNo: json['requestNo'] as String?,
      leaveTypeId: (json['leaveTypeId'] as num?)?.toInt(),
      totalDays: (json['totalDays'] as num?)?.toInt(),
      fromDate: json['fromDate'] == null
          ? null
          : DateTime.parse(json['fromDate']),
      toDate: json['toDate'] == null
          ? null
          : DateTime.parse(json['toDate']),
      requestedDate: json['requestedDate'] == null
          ? null
          : DateTime.parse(json['requestedDate']),
      approvedDate: json['approvedDate'] == null
          ? null
          : DateTime.parse(json['approvedDate']),
      reason: json['reason'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      attachmentString: json['attachmentString'] as String?,
      approverId: (json['approverId'] as num?)?.toInt(),
      approvedBy: json['approvedBy'] as String?,
      status: (json['status'] as num?)?.toInt(),
      fromShiftId: (json['fromShiftId'] as num?)?.toInt(),
      toShiftId: (json['toShiftId'] as num?)?.toInt(),
      balance: (json['balance'] as num?)?.toInt(),
      totalHours: (json['totalHours'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LeaveToJson(Leave instance) => <String, dynamic>{
      'requestNo': instance.requestNo,
      'leaveTypeId': instance.leaveTypeId,
      'totalDays': instance.totalDays,
      'fromDate': instance.fromDate?.toIso8601String(),
      'toDate': instance.toDate?.toIso8601String(),
      'requestedDate': instance.requestedDate?.toIso8601String(),
      'approvedDate': instance.approvedDate?.toIso8601String(),
      'reason': instance.reason,
      'attachments': instance.attachments,
      'attachmentString': instance.attachmentString,
      'approverId': instance.approverId,
      'approvedBy': instance.approvedBy,
      'status': instance.status,
      'fromShiftId': instance.fromShiftId,
      'toShiftId': instance.toShiftId,
      'balance': instance.balance,
      'totalHours': instance.totalHours,
    };
