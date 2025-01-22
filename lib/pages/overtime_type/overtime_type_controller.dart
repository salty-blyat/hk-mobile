import 'package:get/get.dart';
import 'package:staff_view_ui/models/overtime_type_model.dart';
import 'package:staff_view_ui/pages/overtime_type/overtime_type_service.dart';

class OvertimeTypeController extends GetxController {
  final OvertimeTypeService overtimeTypeService = OvertimeTypeService();

  var lists = <OvertimeType>[
    OvertimeType(id: 0, name: 'All'.tr), // Default "All" item
  ].obs;
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
      lists.addAll(fetchedOvertimeType);
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
