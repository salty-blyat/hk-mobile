import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/utils/theme.dart';

class DateTimeController extends GetxController {
  var selectedDateTime = Rxn<DateTime>();

  void updateDateTime(DateTime date, TimeOfDay time) {
    selectedDateTime.value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }
}

class DateTimePicker extends StatelessWidget {
  final String controlName;
  final String label;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime, TimeOfDay)? onDateTimeSelected;

  const DateTimePicker(
      {super.key,
      required this.controlName,
      required this.label,
      this.initialDate,
      this.initialTime,
      this.firstDate,
      this.lastDate,
      this.onDateTimeSelected});

  Future<void> showDateTimePicker(BuildContext context) async {
    var tempDate = DateTime.now().obs;
    var tempTime = TimeOfDay.now().obs;

    await Get.dialog(
      AlertDialog(
        contentTextStyle: const TextStyle(color: Colors.black54),
        title: Text('Select Date & Time'.tr,
            style: const TextStyle(color: Colors.black)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date Picker with Theme Override
              CalendarDatePicker(
                initialDate: tempDate.value,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                onDateChanged: (date) {
                  tempDate.value = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    tempTime.value.hour,
                    tempTime.value.minute,
                  );
                },
              ),
              const SizedBox(height: 16),
              // Time Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Time'.tr,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                      fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: tempTime.value,
                      );
                      if (pickedTime != null) {
                        tempTime.value = pickedTime;
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppTheme.borderRadius,
                      ),
                    ),
                    child: Obx(() => Text(tempTime.value.format(context),
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamilyFallback: ['Gilroy', 'Kantumruy']))),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'.tr,
                style: const TextStyle(
                    fontFamilyFallback: ['Gilroy', 'Kantumruy'])),
          ),
          TextButton(
            onPressed: () {
              onDateTimeSelected?.call(tempDate.value, tempTime.value);
              Get.back();
            },
            child: Text('Ok'.tr,
                style: const TextStyle(
                    fontFamilyFallback: ['Gilroy', 'Kantumruy'])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveDatePicker<DateTime>(
      formControlName: controlName,
      builder: (context, picker, child) => GestureDetector(
        onTap: () {
          if (picker.control.enabled) {
            showDateTimePicker(context);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label.tr,
            suffixIcon: const Icon(CupertinoIcons.calendar),
            fillColor: Colors.grey.shade200,
            filled: !picker.control.enabled,
          ),
          child: Text(
            picker.control.value != null
                ? DateFormat('dd-MM-yyyy hh:mm a').format(picker.control.value!)
                : 'Select a date'.tr, // Placeholder text
            style: picker.control.enabled
                ? null
                : const TextStyle(color: Colors.grey), // Disabled style
          ),
        ),
      ),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }
}
