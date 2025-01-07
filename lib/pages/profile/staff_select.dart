// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/user_info_model.dart';

enum FilterTypesStaff {
  DirectFollower(4),
  AnyFollower(5),
  AnyStaff(9);

  final int value;

  const FilterTypesStaff(this.value);
}

enum FilterTypesApprover {
  DirectManager(1),
  UpperManager(2),
  AnyManager(3),
  AnyStaff(9),
  SelfApprove(10);

  final int value;
  const FilterTypesApprover(this.value);
}

class StaffSelect extends StatelessWidget {
  final String formControlName;
  final String labelText;
  final FormGroup formGroup;
  final bool isEdit;

  const StaffSelect({
    super.key,
    required this.formControlName,
    this.labelText = 'Approver',
    required this.formGroup,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    final StaffSelectController controller = Get.put(StaffSelectController());
    print(formGroup.control(formControlName).value);
    if (formGroup.control(formControlName).value == null) {
      controller.selectedStaff.value = '-';
    } else {
      if (formGroup.control(formControlName).value != null) {
        controller.getStaffById(formGroup.control(formControlName).value);
      }
    }

    return Obx(
      () => TextField(
        controller: TextEditingController(text: controller.selectedStaff.value),
        decoration: InputDecoration(
          suffixIcon: const Icon(CupertinoIcons.chevron_down),
          labelText: labelText.tr,
          labelStyle: const TextStyle(
            fontFamilyFallback: ['Kantumruy', 'Gilroy'],
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
            borderRadius: BorderRadius.circular(4),
          ),
          child: SearchBar(
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                color: Colors.white,
                fontFamilyFallback: ['Kantumruy', 'Gilroy'],
                fontSize: 18,
              ),
            ),
            hintText: 'Search'.tr,
            hintStyle: WidgetStateProperty.all(
              TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 18,
                  fontFamilyFallback: const ['Kantumruy', 'Gilroy']),
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
        actions: [
          IconButton(
            iconSize: 30,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(
                    100, 100, 0, 0), // Adjust position as needed
                items: FilterTypesApprover.values
                    .map((e) => PopupMenuItem<FilterTypesApprover>(
                          value: e,
                          child: Row(
                            children: [
                              Icon(
                                controller.filterType.value == e
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary, // Set the icon color
                                size: 20, // Adjust the icon size
                              ),
                              const SizedBox(
                                  width: 8), // Spacing between icon and text
                              Text(e.name.tr,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                        ))
                    .toList(),
              ).then((selectedValue) {
                if (selectedValue != null) {
                  controller.filterType.value = selectedValue;
                  controller.staff.clear();
                  controller.currentPage = 1;
                  controller.getStaff();
                }
              });
            },
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.isTrue && controller.staff.isEmpty) {
          return Skeletonizer(
            enabled: controller.loading.isTrue,
            child: ListView.builder(
              itemCount: 20,
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
                              'assets/images/${controller.staff[index].sexId == '1' ? 'female.jpg' : 'man.png'}')
                          as ImageProvider,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${controller.staff[index].tittleName ?? ''} ${controller.staff[index].name ?? ''} ${controller.staff[index].latinName ?? ''}',
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
                  controller.selectedStaff.value =
                      '${controller.staff[index].tittleName} ${controller.staff[index].name} ${controller.staff[index].latinName}';
                  formGroup.control(formControlName).value =
                      controller.staff[index].id;
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

class StaffSelectController extends GetxController {
  final RxString searchText = ''.obs;
  final RxString selectedStaff = '-'.obs;
  final RxList<Staff> staff = <Staff>[].obs;
  final StaffService staffService = StaffService();
  final RxBool loading = false.obs;
  final RxBool loadingMore = false.obs;
  final RxBool hasMore = true.obs;
  int currentPage = 1;
  final int pageSize = 20;
  final Rx<FilterTypesApprover> filterType =
      FilterTypesApprover.DirectManager.obs;

  Future<void> getStaffById(int id) async {
    loading.value = true;
    var filter = [
      {'field': 'id', 'operator': 'eq', 'value': id}
    ];

    var response = await staffService.getStaff(queryParameters: {
      'pageIndex': currentPage,
      'pageSize': pageSize,
      'filters': jsonEncode(filter)
    });
    if (response.isNotEmpty) {
      selectedStaff.value =
          '${response.first.tittleName} ${response.first.name} ${response.first.latinName}';
    }
    loading.value = false;
  }

  Future<void> getStaff() async {
    loading.value = true;
    staff.value = [];
    var filter = [];
    if (searchText.value.isNotEmpty) {
      filter.add({
        'field': 'search',
        'operator': 'contains',
        'value': searchText.value
      });
    }
    if (filterType.value != 0) {
      filter.add({
        'field': 'staffFilterTypes',
        'operator': 'eq',
        'value': filterType.value.value
      });
    }

    var response = await staffService.getStaff(queryParameters: {
      'pageIndex': currentPage,
      'pageSize': pageSize,
      'filters': jsonEncode(filter)
    });

    if (response.isNotEmpty) {
      staff.addAll(response);
      hasMore.value = response.length == pageSize;
    } else {
      hasMore.value = false;
    }
    loading.value = false;
  }

  Future<void> loadMoreStaff() async {
    if (!hasMore.value || loadingMore.value) return;

    loadingMore.value = true;
    currentPage++;
    var filter = [
      {
        'field': 'staffFilterTypes',
        'operator': 'eq',
        'value': filterType.value.value
      }
    ];
    var response = await staffService.getStaff(queryParameters: {
      'pageIndex': currentPage,
      'pageSize': pageSize,
      'filters': jsonEncode(filter)
    });

    if (response.isNotEmpty) {
      staff.addAll(response);
    } else {
      hasMore.value = false;
    }
    loadingMore.value = false;
  }
}

class StaffService {
  final DioClient dio = DioClient();
  Future<List<Staff>> getStaff({Map<String, dynamic>? queryParameters}) async {
    var response = await dio.get('/staff', queryParameters: queryParameters);
    if (response?.statusCode == 200) {
      return (response?.data['results'] as List)
          .map((e) => Staff.fromJson(e))
          .toList();
    }
    return [];
  }
}

class StaffValueAccessor extends ControlValueAccessor<String, String> {
  @override
  String? modelToViewValue(String? modelValue) {
    if (modelValue == null) return '-';
    var staff = Staff.fromJson(json.decode(modelValue));
    return "${staff.tittleName} ${staff.name} ${staff.latinName}";
  }

  @override
  String? viewToModelValue(String? viewValue) {
    return viewValue;
  }
}
