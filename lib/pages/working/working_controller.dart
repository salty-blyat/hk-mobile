import 'package:get/get.dart';
import 'package:staff_view_ui/models/working_sheet.dart';
import 'package:staff_view_ui/pages/working/working_service.dart';

class WorkingController extends GetxController {
  final WorkingService workingService = WorkingService();
  final RxList<Worksheets> working = RxList.empty();
  final RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getWorking();
  }

  Future<void> getWorking() async {
    try {
      isLoading.value = true;
      working.value = await workingService.getWorking();
      print('Working: ${working.value}');
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }
}
