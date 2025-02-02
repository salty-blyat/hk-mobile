import 'dart:convert'; // Import for Base64 encoding
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:staff_view_ui/app_setting.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/attachment_model.dart';

class FilePickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var filePath = RxString('');
  var selectedImage = Rx<File?>(null);
  var selectedFile = Rx<File?>(null);
  var isUploading = RxBool(false);
  var progress = RxDouble(0);
  var attachments = RxList<Attachment>();
  var mimeType = RxString('');
  final dio = DioClient().dio;
  final isImage = RxBool(false);
  // Pick an image from the camera and automatically upload it as Base64
  Future<Attachment?> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      Get.back();
      selectedImage.value = File(pickedFile.path);
      await uploadFileAsBase64(
          selectedImage.value!); // Automatically upload after picking
      return attachments.first;
    }
    return null;
  }

  // Pick an image from the gallery and automatically upload it as Base64
  Future<Attachment?> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Get.back();
      selectedImage.value = File(pickedFile.path);
      await uploadFileAsBase64(
          selectedImage.value!); // Automatically upload after picking
      return attachments.first;
    }
    return null;
  }

  // Pick a general file and automatically upload it as Base64
  Future<List<Attachment>?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      Get.back();
      for (var file in result.files) {
        selectedFile.value = File(file.path!);
        mimeType.value = getMimeType(selectedFile.value!);
        await uploadFileAsBase64(
            selectedFile.value!); // Automatically upload after picking
      }
      return attachments;
    }
    return null;
  }

  // Upload file as Base64 to the server using Dio
  Future<void> uploadFileAsBase64(File file) async {
    final url = '${AppSetting.setting['AUTH_API_URL']}/upload/base64';
    const secureStorage = FlutterSecureStorage();
    final token =
        await secureStorage.read(key: Const.authorized['AccessToken']!);
    filePath.value = file.path;
    isUploading.value = true;

    try {
      // Read the file as bytes and encode it to Base64
      List<int> fileBytes = await file.readAsBytes();
      String base64String = base64Encode(fileBytes);

      // Prepare the request data
      Map<String, dynamic> data = {
        'fileName': file.path.split('/').last,
        'mimeType': getMimeType(file),
        'base64': base64String,
      };
      isImage.value = Const.isImage(data['fileName']);

      // Send the request using dio
      var response = await dio.post(
        url,
        data: data, // Send the data as JSON (Base64 encoded file)
        options: Options(
          headers: {
            "Content-Type": "application/json", // Set content type to JSON
            'Authorization': 'Bearer $token',
          },
        ),
        onSendProgress: (int sent, int total) {
          progress.value = sent / total;
        },
      );

      // Handle the response
      if (response.statusCode == 200) {
        progress.value = 1;
        attachments.add(Attachment.fromJson(response.data));
      } else {
        Get.snackbar(
            'Error', 'Failed to upload file. Status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isUploading.value = false;
    }
  }

  // Function to get MIME type manually based on file extension
  String getMimeType(File file) {
    String extension = file.path.split('.').last.toLowerCase();

    // Map of file extensions to MIME types
    const mimeTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'bmp': 'image/bmp',
      'tiff': 'image/tiff',
      'pdf': 'application/pdf',
      'txt': 'text/plain',
      'csv': 'text/csv',
      'html': 'text/html',
      'js': 'application/javascript',
      'css': 'text/css',
      'zip': 'application/zip',
      'rar': 'application/x-rar-compressed',
      'mp4': 'video/mp4',
      'mp3': 'audio/mp3',
      'avi': 'video/x-msvideo',
      'wav': 'audio/wav',
    };

    // Return MIME type based on extension or 'application/octet-stream' if not found
    return mimeTypes[extension] ?? 'application/octet-stream';
  }

  // Clear selections
  void clearSelections() {
    selectedImage.value = null;
    selectedFile.value = null;
  }

  bool isImageUrl(String url) {
    return Const.isImage(url);
  }
}
