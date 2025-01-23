// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExceptionModel _$ExceptionModelFromJson(Map<String, dynamic> json) =>
    ExceptionModel(
      requestNo: json['requestNo'] as String?,
      staffId: (json['staffId'] as num?)?.toInt(),
      terminalId: (json['terminalId'] as num?)?.toInt(),
      exceptionTypeId: (json['exceptionTypeId'] as num?)?.toInt(),
      requestedDate: json['requestedDate'] == null
          ? null
          : DateTime.parse(json['requestedDate'] as String),
      fromDate: json['fromDate'] == null
          ? null
          : DateTime.parse(json['fromDate'] as String),
      toDate: json['toDate'] == null
          ? null
          : DateTime.parse(json['toDate'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      attachmentString: json['attachmentString'] as String?,
      scanType: (json['scanType'] as num?)?.toInt(),
      scanTime: json['scanTime'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      duration: (json['duration'] as num?)?.toDouble(),
      totalDays: (json['totalDays'] as num?)?.toDouble(),
      absentType: (json['absentType'] as num?)?.toInt(),
      totalHours: (json['totalHours'] as num?)?.toDouble(),
      exceptionTypeName: json['exceptionTypeName'] as String?,
      staffName: json['staffName'] as String?,
      staffCode: json['staffCode'] as String?,
      positionId: (json['positionId'] as num?)?.toInt(),
      positionName: json['positionName'] as String?,
      departmentName: json['departmentName'] as String?,
      departmentId: (json['departmentId'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      branchName: json['branchName'] as String?,
      status: (json['status'] as num?)?.toInt(),
      approvedBy: json['approvedBy'] as String?,
      approvedDate: json['approvedDate'] == null
          ? null
          : DateTime.parse(json['approvedDate'] as String),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      approverId: (json['approverId'] as num?)?.toInt(),
      statusName: json['statusName'] as String?,
      statusNameKh: json['statusNameKh'] as String?,
      scanTypeName: json['scanTypeName'] as String?,
      scanTypeNameKh: json['scanTypeNameKh'] as String?,
      absentTypeNameKh: json['absentTypeNameKh'] as String?,
      absentTypeNameEn: json['absentTypeNameEn'] as String?,
      terminalName: json['terminalName'] as String?,
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$ExceptionModelToJson(ExceptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'requestNo': instance.requestNo,
      'staffId': instance.staffId,
      'terminalId': instance.terminalId,
      'exceptionTypeId': instance.exceptionTypeId,
      'requestedDate': instance.requestedDate?.toIso8601String(),
      'fromDate': instance.fromDate?.toIso8601String(),
      'toDate': instance.toDate?.toIso8601String(),
      'attachments': instance.attachments,
      'attachmentString': instance.attachmentString,
      'scanType': instance.scanType,
      'scanTime': instance.scanTime,
      'date': instance.date?.toIso8601String(),
      'duration': instance.duration,
      'totalDays': instance.totalDays,
      'absentType': instance.absentType,
      'totalHours': instance.totalHours,
      'exceptionTypeName': instance.exceptionTypeName,
      'staffName': instance.staffName,
      'staffCode': instance.staffCode,
      'positionId': instance.positionId,
      'positionName': instance.positionName,
      'departmentName': instance.departmentName,
      'departmentId': instance.departmentId,
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'status': instance.status,
      'approvedBy': instance.approvedBy,
      'approvedDate': instance.approvedDate?.toIso8601String(),
      'createdDate': instance.createdDate?.toIso8601String(),
      'approverId': instance.approverId,
      'statusName': instance.statusName,
      'statusNameKh': instance.statusNameKh,
      'scanTypeName': instance.scanTypeName,
      'scanTypeNameKh': instance.scanTypeNameKh,
      'absentTypeNameKh': instance.absentTypeNameKh,
      'absentTypeNameEn': instance.absentTypeNameEn,
      'terminalName': instance.terminalName,
    };
