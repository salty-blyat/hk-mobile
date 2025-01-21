// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overtime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Overtime _$OvertimeFromJson(Map<String, dynamic> json) => Overtime(
      requestNo: json['requestNo'] as String?,
      staffId: (json['staffId'] as num?)?.toInt(),
      overtimeTypeId: (json['overtimeTypeId'] as num?)?.toInt(),
      requestedDate: json['requestedDate'] == null
          ? null
          : DateTime.parse(json['requestedDate'] as String),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      fromTime: json['fromTime'] == null
          ? null
          : DateTime.parse(json['fromTime'] as String),
      toTime: json['toTime'] == null
          ? null
          : DateTime.parse(json['toTime'] as String),
      overtimeHour: (json['overtimeHour'] as num?)?.toDouble(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      attachmentString: json['attachmentString'] as String?,
      overtimeTypeName: json['overtimeTypeName'] as String?,
      staffName: json['staffName'] as String?,
      staffCode: json['staffCode'] as String?,
      positionId: (json['positionId'] as num?)?.toInt(),
      positionName: json['positionName'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      branchName: json['branchName'] as String?,
      branchCode: json['branchCode'] as String?,
      departmentId: (json['departmentId'] as num?)?.toInt(),
      departmentName: json['departmentName'] as String?,
      status: (json['status'] as num?)?.toInt(),
      approverId: (json['approverId'] as num?)?.toInt(),
      approvedBy: json['approvedBy'] as String?,
      approvedDate: json['approvedDate'] == null
          ? null
          : DateTime.parse(json['approvedDate'] as String),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      statusName: json['statusName'] as String?,
      statusNameKh: json['statusNameKh'] as String?,
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$OvertimeToJson(Overtime instance) => <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'staffId': instance.staffId,
      'requestNo': instance.requestNo,
      'overtimeTypeId': instance.overtimeTypeId,
      'requestedDate': instance.requestedDate?.toIso8601String(),
      'date': instance.date?.toIso8601String(),
      'fromTime': instance.fromTime?.toIso8601String(),
      'toTime': instance.toTime?.toIso8601String(),
      'overtimeHour': instance.overtimeHour,
      'attachments': instance.attachments,
      'attachmentString': instance.attachmentString,
      'overtimeTypeName': instance.overtimeTypeName,
      'staffName': instance.staffName,
      'staffCode': instance.staffCode,
      'positionId': instance.positionId,
      'positionName': instance.positionName,
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'branchCode': instance.branchCode,
      'departmentId': instance.departmentId,
      'departmentName': instance.departmentName,
      'status': instance.status,
      'approverId': instance.approverId,
      'approvedBy': instance.approvedBy,
      'approvedDate': instance.approvedDate?.toIso8601String(),
      'createdDate': instance.createdDate?.toIso8601String(),
      'statusName': instance.statusName,
      'statusNameKh': instance.statusNameKh,
    };
