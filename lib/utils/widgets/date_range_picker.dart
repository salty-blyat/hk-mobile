import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/utils/widgets/date_picker.dart';

class DateRangePicker extends StatelessWidget {
  const DateRangePicker(
      {super.key,
      required this.formGroup,
      required this.fromDateControlName,
      required this.toDateControlName,
      this.onDateSelected});
  final FormGroup formGroup;
  final String fromDateControlName;
  final String toDateControlName;
  final Function(DateTimeRange)? onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child:
              _buildDateRangeFields(context, fromDateControlName, 'From date'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDateRangeFields(context, toDateControlName, 'To date'),
        ),
      ],
    );
  }

  Widget _buildDateRangeFields(
      BuildContext context, String controlName, String label) {
    return DatePicker(
      formControlName: controlName,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, picker, child) {
        return GestureDetector(
          onTap: () {
            if (formGroup.control(toDateControlName).disabled &&
                label == 'From date') {
              datePicker(context);
              return;
            }
            if (picker.control.enabled) {
              dateRangePicker(context);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: picker.control.value == null
                  ? null
                  : label.tr, // Localization for the label
              suffixIcon: const Icon(CupertinoIcons.calendar),
              fillColor: Colors.grey.shade200,
              filled: !picker.control.enabled,
            ),
            child: Text(
              picker.control.value != null
                  ? DateFormat('dd-MM-yyyy').format(picker.control.value!)
                  : 'Select a date'.tr, // Placeholder text
              style: picker.control.enabled
                  ? null
                  : const TextStyle(color: Colors.grey), // Disabled style
            ),
          ),
        );
      },
    );
  }

  Future<void> dateRangePicker(BuildContext context) async {
    final selectedDates = await showDateRangePicker(
      context: context,
      locale: Get.locale,
      initialDateRange: DateTimeRange(
        start: formGroup.control(fromDateControlName).value ?? DateTime.now(),
        end: formGroup.control(toDateControlName).value ?? DateTime.now(),
      ),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (selectedDates != null) {
      formGroup.control(fromDateControlName).value = selectedDates.start;
      formGroup.control(toDateControlName).value = selectedDates.end;
      onDateSelected?.call(selectedDates);
    }
  }

  Future<void> datePicker(BuildContext context) async {
    final selectedDates = await showDatePicker(
      context: context,
      locale: Get.locale,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate:
          formGroup.control(fromDateControlName).value ?? DateTime.now(),
    );
    if (selectedDates != null) {
      formGroup.control(fromDateControlName).value = selectedDates;
      formGroup.control(toDateControlName).value = selectedDates;
    }
  }
}
