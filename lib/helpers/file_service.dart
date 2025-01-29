import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';

Future<void> downloadAndSaveFile(
    String url, String fileName, Function(double) percentage) async {
  try {
    Directory? directory;

    if (Platform.isAndroid) {
      if (await _requestStoragePermission()) {
        var tmp = await getExternalStorageDirectory();
        directory = Directory(
            '${tmp?.path.split('/Android').first}/Download/StaffView');
      } else {
        throw Exception("Storage permission denied");
      }
    } else if (Platform.isIOS) {
      directory = Directory(
          '${(await getApplicationDocumentsDirectory()).path}/StaffView');
    }

    if (directory == null) {
      throw Exception("Could not find a valid directory");
    }

    final filePath = "${directory.path}/$fileName.${url.split('.').last}";

    // Ensure directory exists
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final dio = DioClient().dio;
    final response = await dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          percentage.call(received / total * 100);
        }
      },
    );

    if (response.statusCode == 200) {
      await OpenFile.open(filePath);
    } else {
      throw Exception('Failed to download file: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to download file: $e');
  }
}

Future<bool> _requestStoragePermission() async {
  if (Platform.isAndroid) {
    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }
  return true; // iOS doesn't need permission
}
