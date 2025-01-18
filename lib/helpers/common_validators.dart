import 'package:get/get_utils/get_utils.dart';

class CommonValidators {
  static String? required(String field) {
    if (field.isEmpty) {
      return 'Input is required!'.tr;
    }
    return null;
  }
}
