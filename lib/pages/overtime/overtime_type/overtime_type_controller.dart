import 'package:get/get.dart';
import 'package:staff_view_ui/models/overtime_type_model.dart';
import 'package:staff_view_ui/pages/overtime/overtime_service.dart';

class OvertimeTypeController extends GetxController {
  final OvertimeTypeService overtimeTypeService = OvertimeTypeService();

  final overtimeTypes = <OvertimeType>[OvertimeType(id: 0, name: 'All')].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOvertimeType();
  }

  Future<void> fetchOvertimeType() async {
    try {
      isLoading.value = true;
      final fetchedOvertimeType = await overtimeTypeService.getOvertimeType();
      overtimeTypes.addAll(fetchedOvertimeType);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch overtime types: $e',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
