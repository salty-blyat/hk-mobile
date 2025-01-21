import 'package:get/get.dart';
import 'package:staff_view_ui/models/overtime_type_model.dart';
import 'package:staff_view_ui/pages/overtime/overtime_type/overtime_type_service.dart';

class OvertimeTypeController extends GetxController {
  final OvertimeTypeService overtimeTypeService = OvertimeTypeService();

  final lists = <OvertimeType>[OvertimeType()].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    search();
  }

  Future<void> search() async {
    try {
      isLoading.value = true;
      final fetchedOvertimeType = await overtimeTypeService.getOvertimeType();
      lists.assignAll(fetchedOvertimeType);
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
