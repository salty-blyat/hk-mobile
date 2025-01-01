import 'package:get/get.dart';
import 'package:staff_view_ui/models/leave_type_model.dart';
import 'package:staff_view_ui/pages/leave/leave_service.dart';

class LeaveTypeController extends GetxController {
  final LeaveTypeService leaveTypeService = LeaveTypeService();

  // List of leave types and loading state
  final leaveTypes = <LeaveType>[].obs;
  final leaveUnits = [
    {"id": "1", "name": "ច្បាប់ឈប់ (ថ្ងៃ)"},
    {"id": "2", "name": "ច្បាប់ឈប់ (ម៉ោង)"}
  ].obs;
  final leaveUnit = '1'.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaveTypes();
  }

  Future<void> fetchLeaveTypes() async {
    try {
      isLoading.value = true; // Start loading
      final fetchedLeaveTypes = await leaveTypeService.getLeaveType();
      leaveTypes.assignAll(fetchedLeaveTypes); // Update observable lis
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch leave types: $e',
          snackPosition: SnackPosition.BOTTOM);
      isLoading.value = false; // Stop loading
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}
