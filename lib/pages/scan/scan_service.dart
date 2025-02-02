import 'package:dio/dio.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/qr_scan_model.dart';

class ScanService {
  final dio = DioClient().dio;
  Future<Response> checkAttendance(QrScanModel qrCodeData) async {
    final response = await dio.post('${DioClient().baseUrl}/check', data: {
      'key': qrCodeData.key,
      'type': qrCodeData.type,
      'fd': qrCodeData.fd,
      'td': qrCodeData.td,
      'lat': qrCodeData.lat,
      'lng': qrCodeData.lng
    });
    return response;
  }
}
