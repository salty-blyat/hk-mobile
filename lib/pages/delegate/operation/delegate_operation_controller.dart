// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/storage.dart';
import 'package:staff_view_ui/models/delegate_model.dart';
import 'package:staff_view_ui/pages/delegate/delegate_controller.dart';
import 'package:staff_view_ui/pages/delegate/delegate_service.dart';
import 'package:staff_view_ui/utils/widgets/dialog.dart';

class DelegatepOperationController extends GetxController {
  final DelegateController delegateController = Get.find<DelegateController>();
  final storage = Storage();
  final loading = false.obs;
  final delegateService = DelegateService();
  final formValid = false.obs;
  final id = 0.obs;

  final formGroup = FormGroup({
    'id': FormControl<int>(
      value: 0,
    ),
    'delegateStaffId': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
    'fromDate': FormControl<DateTime>(
      value: DateTime.now(),
      validators: [Validators.required],
    ),
    'toDate': FormControl<DateTime>(
      value: DateTime.now(),
      validators: [Validators.required],
    ),
    'totalDays': FormControl<int>(
      value: 0,
      disabled: true,
    ),
    'note': FormControl<String>(),
  });

  @override
  void onInit() {
    formGroup.valueChanges.listen((value) {
      formValid.value = formGroup.valid;
    });
    calculateTotalDays();

    super.onInit();
  }

  void find(int id) async {
    try {
      loading.value = true;
      var delegate = Delegate.fromJson(await delegateService.find(id));
      setFormValue(delegate);
      calculateTotalDays();
    } catch (e) {
      print(e);
    } finally {
      loading.value = false;
    }
  }

  void setFormValue(Delegate delegate) {
    formGroup.patchValue({
      'id': delegate.id,
      'delegateStaffId': delegate.delegateStaffId,
      'fromDate': delegate.fromDate?.toLocal(),
      'toDate': delegate.toDate?.toLocal(),
      'note': delegate.note,
    });
  }

  void calculateTotalDays() {
    final fromDate = formGroup.control('fromDate').value;
    final toDate = formGroup.control('toDate').value;

    final totalDays = toDate.difference(fromDate).inDays + 1;
    formGroup.control('totalDays').value = totalDays;
  }

  Future<void> submit() async {
    if (loading.isTrue) return;

    try {
      // Show loading dialog
      Modal.loadingDialog();

      var model = {
        'fromDate': formGroup.control('fromDate').value.toIso8601String(),
        'toDate': formGroup.control('toDate').value.toIso8601String(),
        'staffId': int.parse(storage.read(Const.staffId) ?? '0'),
      };

      if (id.value == 0) {
        await delegateService.add(
            Delegate.fromJson({...formGroup.rawValue, ...model}),
            Delegate.fromJson);
      } else {
        await delegateService.edit(
            Delegate.fromJson(
                {...formGroup.rawValue, ...model, 'id': id.value}),
            Delegate.fromJson);
      }

      delegateController.search();
      Get.back();
      Get.back();
    } catch (e) {
      print(e);
    }
  }
}
