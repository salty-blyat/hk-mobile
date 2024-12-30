import 'package:json_annotation/json_annotation.dart';

part 'qr_scan_model.g.dart';

@JsonSerializable()
class QrScanModel {
  final String? key;
  final int? type;
  final String? fd;
  final String? td;
  final String? lat;
  final String? lng;

  QrScanModel({
    this.key,
    this.type,
    this.fd,
    this.td,
    this.lat,
    this.lng,
  });

  factory QrScanModel.fromJson(Map<String, dynamic> json) =>
      _$QrScanModelFromJson(json);

  Map<String, dynamic> toJson() => _$QrScanModelToJson(this);
}
