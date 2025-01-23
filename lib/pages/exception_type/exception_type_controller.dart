import 'package:get/get.dart';
import 'package:staff_view_ui/models/exception_type_model.dart';
import 'package:staff_view_ui/pages/exception_type/exception_type_service.dart';

enum Unit {
  Days(1),
  Hours(2);

  final int value;
  const Unit(this.value);
}

enum EXCEPTION_TYPE {
  MISS_SCAN(1),
  ABSENT_EXCEPTION(2),
  LATE_EXCEPTION(3),
  EARLY_EXCEPTION(4),
  HOUR_ABSENT(5);

  final int value;
  const EXCEPTION_TYPE(this.value);
}

class ExceptionTypeController extends GetxController {
  final ExceptionTypeService exceptionTypeService = ExceptionTypeService();

  final exceptionTypes = <ExceptionTypeModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExceptionTypes();
  }

  Future<void> fetchExceptionTypes() async {
    try {
      isLoading.value = true;
      final fetchedExceptionTypes =
          await exceptionTypeService.getExceptionType();
      exceptionTypes.assignAll(fetchedExceptionTypes);
    } catch (e) {
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
