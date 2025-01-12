import 'package:get/get.dart';
import 'package:staff_view_ui/models/leave_type_model.dart';
import 'package:staff_view_ui/pages/leave_type/leave_type_service.dart';

enum LeaveUnit {
  day(1),
  hour(2);

  final int value;
  const LeaveUnit(this.value);
}

class LeaveTypeController extends GetxController {
  final LeaveTypeService leaveTypeService = LeaveTypeService();

  final leaveTypes = <LeaveType>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaveTypes();
  }

  Future<void> fetchLeaveTypes() async {
    try {
      isLoading.value = true;
      final fetchedLeaveTypes = await leaveTypeService.getLeaveType();
      leaveTypes.assignAll(fetchedLeaveTypes);
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
