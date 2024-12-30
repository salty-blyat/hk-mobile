// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_scan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QrScanModel _$QrScanModelFromJson(Map<String, dynamic> json) => QrScanModel(
      key: json['key'] as String?,
      type: (json['type'] as num?)?.toInt(),
      fd: json['fd'] as String?,
      td: json['td'] as String?,
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
    );

Map<String, dynamic> _$QrScanModelToJson(QrScanModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'type': instance.type,
      'fd': instance.fd,
      'td': instance.td,
      'lat': instance.lat,
      'lng': instance.lng,
    };
