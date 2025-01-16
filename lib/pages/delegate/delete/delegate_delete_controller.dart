import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/models/delegate_model.dart';
import 'package:staff_view_ui/pages/delegate/delegate_controller.dart';
import 'package:staff_view_ui/pages/delegate/delegate_service.dart';

class DelegateDeleteController extends GetxController {
  final delegateService = DelegateService();
  final DelegateController delegateController = Get.find<DelegateController>();
  final loading = false.obs;
  final operationLoading = false.obs;
  final delegate = Delegate().obs;
  final totalDays = 0.obs;

  final formGroup = fb.group({
    'id': fb.control(0),
    'reason': fb.control(''),
  });

  void calculateTotalDays() {
    final fromDate = delegate.value.fromDate;
    final toDate = delegate.value.toDate;

    final days = toDate!.difference(fromDate!).inDays + 1;
    totalDays.value = days;
    print(totalDays);
  }

  Future<void> getDelegate(int id) async {
    try {
      loading.value = true;
      delegate.value = Delegate.fromJson(await delegateService.find(id));
      formGroup.value = {
        'id': delegate.value.id,
      };
      calculateTotalDays();
      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }

  Future<void> deleteDelegate() async {
    if (operationLoading.isTrue) return;

    try {
      operationLoading.value = true;
      var res =
          await delegateService.delete(Delegate.fromJson(formGroup.rawValue));
      if (res) {
        Get.back();
        delegateController.search();
      }
    } catch (e) {
      operationLoading.value = false;
    } finally {
      operationLoading.value = false;
    }
  }
}
