import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/models/user_info_model.dart';
import 'package:staff_view_ui/pages/staff/staff_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';

class StaffSelect extends StatelessWidget {
  final String formControlName;
  final String labelText;
  final FormGroup formGroup;
  final bool isEdit;
  final bool isDelegate;

  const StaffSelect({
    super.key,
    required this.formControlName,
    this.labelText = 'Staff',
    required this.formGroup,
    this.isEdit = false,
    this.isDelegate = false,
  });

  @override
  Widget build(BuildContext context) {
    final StaffSelectController controller = Get.put(StaffSelectController());
    if (formGroup.control(formControlName).value == null) {
      controller.selectedStaff.value = '-';
    }
    // else {
    //   if (formGroup.control(formControlName).value != null) {
    //     controller.getStaffById(formGroup.control(formControlName).value);
    //   }
    // }

    return Obx(
      () => TextField(
        controller: TextEditingController(text: controller.selectedStaff.value),
        decoration: InputDecoration(
          suffixIcon: const Icon(CupertinoIcons.chevron_down),
          labelText: labelText.tr,
          labelStyle: const TextStyle(
            fontFamilyFallback: ['Gilroy', 'Kantumruy'],
            fontWeight: FontWeight.normal,
          ),
        ),
        readOnly: true,
        onTap: () async {
          await Get.to(() => StaffSelectDialog(
                formControlName: formControlName,
                formGroup: formGroup,
              ));
        },
      ),
    );
  }
}

class StaffSelectDialog extends StatelessWidget {
  final String formControlName;
  final FormGroup formGroup;
  StaffSelectDialog({
    super.key,
    required this.formControlName,
    required this.formGroup,
  });
  final StaffSelectController controller = Get.put(StaffSelectController());

  @override
  Widget build(BuildContext context) {
    controller.getStaff();
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: AppTheme.borderRadius,
          ),
          child: SearchBar(
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                color: Colors.white,
                fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                fontSize: 18,
              ),
            ),
            hintText: 'Search'.tr,
            hintStyle: WidgetStateProperty.all(
              TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 18,
                  fontFamilyFallback: const ['Gilroy', 'Kantumruy']),
            ),
            leading: const Icon(Icons.search),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              controller.searchText.value = value;
              controller.staff.clear();
              controller.currentPage = 1;
              controller.getStaff();
            },
          ),
        ),
      ),
      body: Obx(() {
        if (controller.loading.isTrue && controller.staff.isEmpty) {
          return Skeletonizer(
            enabled: controller.loading.isTrue,
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return const ListTile(
                  leading: CircleAvatar(),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('__________________________'),
                      Text('_________________________',
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels >=
                    scrollNotification.metrics.maxScrollExtent &&
                !controller.loadingMore.isTrue) {
              controller.loadMoreStaff();
            }
            return false;
          },
          child: ListView.builder(
            itemCount:
                controller.staff.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.staff.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: controller.staff[index].photo != null &&
                          controller.staff[index].photo!.isNotEmpty
                      ? NetworkImage(controller.staff[index].photo!)
                      : AssetImage(
                              'assets/images/${controller.staff[index].sexId == 1 ? 'female.jpg' : 'man.png'}')
                          as ImageProvider,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.staff[index].name ?? '',
                        style: Theme.of(context).textTheme.bodyLarge),
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Text(controller.staff[index].positionName ?? '',
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(width: 10),
                        Text(controller.staff[index].departmentName ?? '',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    )),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  print(controller.staff);
                  controller.selectedStaff.value =
                      '${controller.staff[index].name}';
                  formGroup.control(formControlName).value =
                      controller.staff[index].id;
                       
                      print(formGroup.control('staffId').value);
                  Get.back(result: controller.staff[index]);
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class StaffValueAccessor extends ControlValueAccessor<String, String> {
  @override
  String? modelToViewValue(String? modelValue) {
    if (modelValue == null) return '-';
    var staff = Staff.fromJson(json.decode(modelValue));
    return "${staff.name}";
  }

  @override
  String? viewToModelValue(String? viewValue) {
    return viewValue;
  }
}
