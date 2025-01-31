// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_sheet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Worksheets _$WorksheetsFromJson(Map<String, dynamic> json) => Worksheets(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      day: json['day'] as String?,
      expectedWorkingHour: (json['expectedWorkingHour'] as num?)?.toDouble(),
      absentAuthHour: (json['absentAuthHour'] as num?)?.toDouble(),
      absentAvailableAuthHour:
          (json['absentAvailableAuthHour'] as num?)?.toDouble(),
      absentUnAuthHour: (json['absentUnAuthHour'] as num?)?.toDouble(),
      adrWorkingHour: (json['adrWorkingHour'] as num?)?.toDouble(),
      type: (json['type'] as num?)?.toInt(),
      dutyRated: (json['dutyRated'] as num?)?.toDouble(),
      holiday: json['holiday'] as String?,
      holidayId: (json['holidayId'] as num?)?.toInt(),
      missionId: (json['missionId'] as num?)?.toInt(),
      missionObjective: json['missionObjective'] as String?,
      leaveReason: json['leaveReason'] as String?,
      leaveType: json['leaveType'] as String?,
      leaveId: (json['leaveId'] as num?)?.toInt(),
      leaveTypeId: (json['leaveTypeId'] as num?)?.toInt(),
      shiftClockIn: json['shiftClockIn'] as String?,
      shiftClockOut: json['shiftClockOut'] as String?,
      actualWorkingHour: (json['actualWorkingHour'] as num?)?.toDouble(),
      actualIn: json['actualIn'] as String?,
      actualOut: json['actualOut'] as String?,
      workingHour: (json['workingHour'] as num?)?.toDouble(),
      extData: json['extData'] as String?,
    )
      ..id = (json['id'] as num?)?.toInt()
      ..note = json['note'] as String?;

Map<String, dynamic> _$WorksheetsToJson(Worksheets instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'date': instance.date?.toIso8601String(),
      'day': instance.day,
      'expectedWorkingHour': instance.expectedWorkingHour,
      'absentAuthHour': instance.absentAuthHour,
      'absentAvailableAuthHour': instance.absentAvailableAuthHour,
      'absentUnAuthHour': instance.absentUnAuthHour,
      'adrWorkingHour': instance.adrWorkingHour,
      'type': instance.type,
      'dutyRated': instance.dutyRated,
      'holiday': instance.holiday,
      'holidayId': instance.holidayId,
      'missionId': instance.missionId,
      'missionObjective': instance.missionObjective,
      'leaveReason': instance.leaveReason,
      'leaveType': instance.leaveType,
      'leaveId': instance.leaveId,
      'leaveTypeId': instance.leaveTypeId,
      'shiftClockIn': instance.shiftClockIn,
      'shiftClockOut': instance.shiftClockOut,
      'actualWorkingHour': instance.actualWorkingHour,
      'actualIn': instance.actualIn,
      'actualOut': instance.actualOut,
      'workingHour': instance.workingHour,
      'extData': instance.extData,
    };
