// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_balance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveBalanceModel _$LeaveBalanceModelFromJson(Map<String, dynamic> json) =>
    LeaveBalanceModel(
      staffId: (json['staffId'] as num?)?.toInt(),
      staffName: json['staffName'] as String?,
      staffCode: json['staffCode'] as String?,
      positionId: (json['positionId'] as num?)?.toInt(),
      positionName: json['positionName'] as String?,
      totalAvail: (json['totalAvail'] as num?)?.toInt(),
      totalEntitle: (json['totalEntitle'] as num?)?.toInt(),
      departmentId: (json['departmentId'] as num?)?.toInt(),
      departmentName: json['departmentName'] as String?,
      leaveBalances: (json['leaveBalances'] as List<dynamic>?)
          ?.map((e) => LeaveBalances.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$LeaveBalanceModelToJson(LeaveBalanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'staffId': instance.staffId,
      'staffName': instance.staffName,
      'staffCode': instance.staffCode,
      'positionId': instance.positionId,
      'positionName': instance.positionName,
      'totalAvail': instance.totalAvail,
      'totalEntitle': instance.totalEntitle,
      'departmentId': instance.departmentId,
      'departmentName': instance.departmentName,
      'leaveBalances': instance.leaveBalances,
    };

LeaveBalances _$LeaveBalancesFromJson(Map<String, dynamic> json) =>
    LeaveBalances(
      leaveTypeId: (json['leaveTypeId'] as num?)?.toInt(),
      totalAvail: (json['totalAvail'] as num?)?.toInt(),
      totalEntitle: (json['totalEntitle'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LeaveBalancesToJson(LeaveBalances instance) =>
    <String, dynamic>{
      'leaveTypeId': instance.leaveTypeId,
      'totalAvail': instance.totalAvail,
      'totalEntitle': instance.totalEntitle,
    };
