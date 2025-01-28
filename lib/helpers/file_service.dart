import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';

Future<void> downloadAndOpenFile(
    String url, String fileName, Function(double) percentage) async {
  try {
    var directory = await getDownloadsDirectory();
    final filePath = "${directory?.path}/$fileName.${url.split('.').last}";

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
      throw Exception('Failed to download file');
    }
  } catch (e) {
    throw Exception('Failed to download file');
  }
}
