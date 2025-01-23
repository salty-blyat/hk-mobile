import 'package:get/get_utils/get_utils.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CommonValidators {
  //Required Validator
  static Map<String, dynamic>? required(AbstractControl<dynamic> control) {
    final value = control.value;
    if (value == null || (value is String && value.trim().isEmpty)) {
      return {'Input is required!'.tr: true};
    }
    return null;
  }

  //Mush Match Validator
  static ValidatorFunction mustMatch(
      String controlName, String matchingControlName,
      {bool markAsDirty = true}) {
    return (AbstractControl<dynamic> control) {
      final errorMessage = 'Password and confirm not match!'.tr;
      if (control is! FormGroup) {
        return {errorMessage: true};
      }

      final formControl = control.control(controlName);
      final matchingFormControl = control.control(matchingControlName);

      // Add error to matchingFormControl if values do not match
      if (formControl.value != matchingFormControl.value) {
        matchingFormControl.setErrors(
          {errorMessage: true},
          markAsDirty: markAsDirty,
        );
        matchingFormControl.markAsTouched();
      } else {
        matchingFormControl.removeError(errorMessage);
      }

      return null; // No error at the form group level
    };
  }

  // Multiple Email Validator
  static Map<String, dynamic>? multipleEmailValidator(
      AbstractControl<dynamic> control) {
    bool isEmptyInputValue(String? value) {
      return value == null || value.isEmpty;
    }

    bool isEmail(String value) {
      const emailPattern = r"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$";
      final regex = RegExp(emailPattern);
      final emails = value.split('/');
      return emails.every((email) => regex.hasMatch(email));
    }

    final value = control.value;
    if (isEmptyInputValue(value)) {
      return null;
    }

    return isEmail(value) ? null : {'Email is not valid!'.tr: true};
  }

  static Map<String, dynamic>? multiplePhoneValidator(
      AbstractControl<dynamic> control) {
    bool isEmptyInputValue(String? value) {
      return value == null || value.isEmpty;
    }

    bool isPhoneNumber(String value) {
      // Regex for validating multiple phone numbers
      const phonePattern =
          r"^((\+\d{1,3}|0)(\d{2})(\d{6,7})(([\/])(\+\d{1,3}|0)(\d{2})(\d{6,7}))*)*$";
      final regex = RegExp(phonePattern);

      // Replace unwanted characters (like zero-width space or extra spaces)
      value = value.replaceAll(RegExp(r'\u200B'), '').replaceAll(' ', '');

      // Split by slash and check each number
      final phoneNumbers = value.split('/');
      return phoneNumbers.every((phone) => regex.hasMatch(phone));
    }

    final value = control.value;
    if (isEmptyInputValue(value)) {
      return null;
    }

    return isPhoneNumber(value)
        ? null
        : {'Phone number is not valid!'.tr: true};
  }
}
