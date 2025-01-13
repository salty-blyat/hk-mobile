// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestModel _$RequestModelFromJson(Map<String, dynamic> json) => RequestModel(
      staffId: (json['staffId'] as num?)?.toInt(),
      photo: json['photo'] as String?,
      requestNo: json['requestNo'] as String?,
      requestedDate: json['requestedDate'] == null
          ? null
          : DateTime.parse(json['requestedDate'] as String),
      requestType: (json['requestType'] as num?)?.toInt(),
      requestTypeId: (json['requestTypeId'] as num?)?.toInt(),
      title: json['title'] as String?,
      requestData: json['requestData'] as String?,
      approvalRuleId: (json['approvalRuleId'] as num?)?.toInt(),
      lastStepId: (json['lastStepId'] as num?)?.toInt(),
      nextApproverIds: json['nextApproverIds'] as String?,
      status: (json['status'] as num?)?.toInt(),
      staffNameKh: json['staffNameKh'] as String?,
      staffNameEn: json['staffNameEn'] as String?,
      staffCode: json['staffCode'] as String?,
      statusName: json['statusName'] as String?,
      statusNameKh: json['statusNameKh'] as String?,
      requestTypeName: json['requestTypeName'] as String?,
      positionId: (json['positionId'] as num?)?.toInt(),
      positionCode: json['positionCode'] as String?,
      positionName: json['positionName'] as String?,
      departmentId: (json['departmentId'] as num?)?.toInt(),
      departmentCode: json['departmentCode'] as String?,
      departmentName: json['departmentName'] as String?,
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      canDoAction: json['canDoAction'] as bool?,
      delegatorId: (json['delegatorId'] as num?)?.toInt(),
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$RequestModelToJson(RequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'staffId': instance.staffId,
      'requestNo': instance.requestNo,
      'requestedDate': instance.requestedDate?.toIso8601String(),
      'requestType': instance.requestType,
      'requestTypeId': instance.requestTypeId,
      'title': instance.title,
      'requestData': instance.requestData,
      'approvalRuleId': instance.approvalRuleId,
      'lastStepId': instance.lastStepId,
      'nextApproverIds': instance.nextApproverIds,
      'photo': instance.photo,
      'status': instance.status,
      'staffNameKh': instance.staffNameKh,
      'staffNameEn': instance.staffNameEn,
      'staffCode': instance.staffCode,
      'statusName': instance.statusName,
      'statusNameKh': instance.statusNameKh,
      'requestTypeName': instance.requestTypeName,
      'positionId': instance.positionId,
      'positionCode': instance.positionCode,
      'positionName': instance.positionName,
      'departmentId': instance.departmentId,
      'departmentCode': instance.departmentCode,
      'departmentName': instance.departmentName,
      'createdDate': instance.createdDate?.toIso8601String(),
      'canDoAction': instance.canDoAction,
      'delegatorId': instance.delegatorId,
    };
