import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/user_info_model.dart';

class StaffSelect extends StatelessWidget {
  final String formControlName;
  final String labelText;
  final FormGroup formGroup;
  const StaffSelect({
    super.key,
    required this.formControlName,
    this.labelText = 'Approver',
    required this.formGroup,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: formControlName,
      valueAccessor: StaffValueAccessor(),
      decoration: InputDecoration(
        labelText: labelText.tr,
        suffixIcon: const Icon(CupertinoIcons.chevron_down),
      ),
      readOnly: true,
      onTap: (context) async {
        var result = await Get.to(() => StaffSelectDialog(
              formControlName: formControlName,
              formGroup: formGroup,
            ));
        if (result != null) {
          var staff = Staff.fromJson(json.decode(result));
          formGroup.control(formControlName).value = staff.id.toString();
        }
      },
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
    return Scaffold(
      appBar: AppBar(title: Text('Staff'.tr)),
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
                      Text('__________________________________'),
                      Text('______________________________________________',
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
                    Row(
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
                  formGroup.control(formControlName).value =
                      json.encode(controller.staff[index]);
                  Get.back(result: json.encode(controller.staff[index]));
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
  final RxList<Staff> staff = <Staff>[].obs;
  final StaffService staffService = StaffService();
  final RxBool loading = false.obs;
  final RxBool loadingMore = false.obs;
  final RxBool hasMore = true.obs;
  int currentPage = 1;
  final int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    getStaff();
  }

  Future<void> getStaff() async {
    loading.value = true;
    var response =
        await staffService.getStaff(pageIndex: currentPage, pageSize: pageSize);
    if (response.isNotEmpty) {
      staff.addAll(response);
    } else {
      hasMore.value = false;
    }
    loading.value = false;
  }

  Future<void> loadMoreStaff() async {
    if (!hasMore.value || loadingMore.value) return;

    loadingMore.value = true;
    currentPage++;
    var response =
        await staffService.getStaff(pageIndex: currentPage, pageSize: pageSize);
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
  Future<List<Staff>> getStaff(
      {required int pageIndex, required int pageSize}) async {
    var response = await dio.get('/staff',
        queryParameters: {'pageIndex': pageIndex, 'pageSize': pageSize});
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
