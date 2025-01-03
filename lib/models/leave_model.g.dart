// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Leave _$LeaveFromJson(Map<String, dynamic> json) => Leave(
      id: (json['id'] as num?)?.toInt(),
      leaveTypeName: json['leaveTypeName'] as String?,
      leaveTypeCode: json['leaveTypeCode'] as String?,
      leaveTypeTrackBalance: json['leaveTypeTrackBalance'] as bool?,
      staffName: json['staffName'] as String?,
      staffCode: json['staffCode'] as String?,
      positionId: (json['positionId'] as num?)?.toInt(),
      positionName: json['positionName'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      branchCode: json['branchCode'] as String?,
      branchName: json['branchName'] as String?,
      departmentId: (json['departmentId'] as num?)?.toInt(),
      deductDay: (json['deductDay'] as num?)?.toInt(),
      statusName: json['statusName'] as String?,
      statusNameKh: json['statusNameKh'] as String?,
      requestNo: json['requestNo'] as String?,
      staffId: (json['staffId'] as num?)?.toInt(),
      leaveTypeId: (json['leaveTypeId'] as num?)?.toInt(),
      totalDays: (json['totalDays'] as num?)?.toInt(),
      fromDate: json['fromDate'] == null
          ? null
          : DateTime.parse(json['fromDate'] as String),
      toDate: json['toDate'] == null
          ? null
          : DateTime.parse(json['toDate'] as String),
      requestedDate: json['requestedDate'] == null
          ? null
          : DateTime.parse(json['requestedDate'] as String),
      approvedDate: json['approvedDate'] == null
          ? null
          : DateTime.parse(json['approvedDate'] as String),
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
      'staffId': instance.staffId,
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
      'id': instance.id,
      'leaveTypeName': instance.leaveTypeName,
      'leaveTypeCode': instance.leaveTypeCode,
      'leaveTypeTrackBalance': instance.leaveTypeTrackBalance,
      'staffName': instance.staffName,
      'staffCode': instance.staffCode,
      'positionId': instance.positionId,
      'positionName': instance.positionName,
      'branchId': instance.branchId,
      'branchCode': instance.branchCode,
      'branchName': instance.branchName,
      'departmentId': instance.departmentId,
      'deductDay': instance.deductDay,
      'statusName': instance.statusName,
      'statusNameKh': instance.statusNameKh,
    };
