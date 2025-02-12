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
import 'package:staff_view_ui/utils/file_type.dart';
import 'package:staff_view_ui/utils/widgets/snack_bar.dart';

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
      return attachments.last;
    }
    return null;
  }

  // Pick an image from the gallery and automatically upload it as Base64
  Future<Attachment?> pickImageFromGallery(Function(bool) setLoading) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setLoading.call(true);
    if (pickedFile != null) {
      Get.back();
      selectedImage.value = File(pickedFile.path);
      await uploadFileAsBase64(
          selectedImage.value!); // Automatically upload after picking
      return attachments.last;
    }
    return null;
  }

  // Pick a general file and automatically upload it as Base64
  Future<List<Attachment>?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    var attachmentLength = attachments.length;
    if (result != null) {
      Get.back();
      for (var file in result.files) {
        selectedFile.value = File(file.path!);
        mimeType.value = getMimeType(file: selectedFile.value);
        await uploadFileAsBase64(
            selectedFile.value!); // Automatically upload after picking
      }
      return attachments.sublist(attachmentLength);
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
        'mimeType': getMimeType(file: file),
        'base64': base64String,
      };
      isImage.value = isImageType(data['fileName']);

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
        errorSnackbar('Error'.tr,
            'Failed to upload file. Status: ${response.statusCode}');
      }
    } catch (e) {
      errorSnackbar('Error'.tr, 'An error occurred: $e');
    } finally {
      isUploading.value = false;
    }
  }

  // Clear selections
  void clearSelections() {
    selectedImage.value = null;
    selectedFile.value = null;
  }

  bool isImageUrl(String url) {
    return isImageType(url);
  }
}
