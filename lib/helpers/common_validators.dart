import 'package:get/get_utils/get_utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

typedef Validator<T> = Map<String, dynamic>? Function(
    AbstractControl<T> control);

class CommonValidators {
  static String? required(String field) {
    if (field.isEmpty) {
      return 'Input is required!'.tr;
    }
    return null;
  }

  static Validator<String> multipleEmailValidator =
      (AbstractControl<String> control) {
    final value = control.value;

    if (value == null || value.isEmpty) {
      return null; // No error if the value is empty
    }

    // Regular expression for email validation
    final emailRegex = RegExp(r'^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$');
    final emails = value.split('/');

    // Check if all emails are valid
    final isValid = emails.every((email) => emailRegex.hasMatch(email));

    if (!isValid) {
      return {
        'multipleEmail':
            'One or more email addresses are invalid', // Validation key and message
      };
    }

    return null; // No errors, validation passed
  };
}
