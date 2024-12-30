import 'package:get/get.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/qr_scan_model.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class ScanService {
  final dio = DioClient();
  Future<void> checkAttendance(QrScanModel qrCodeData) async {
    try {
      final response = await dio.post('/check', data: {
        'key': qrCodeData.key,
        'type': qrCodeData.type,
        'fd': qrCodeData.fd,
        'td': qrCodeData.td,
        'lat': qrCodeData.lat,
        'lng': qrCodeData.lng
      });
      if (response?.statusCode == 200) {
        Get.offAllNamed('/menu');
        Modal.successDialog('Success', 'Attendance checked successfully');
      }
    } catch (e) {
      Modal.errorDialog('Error', 'Failed to check attendance');
    }
  }
}
