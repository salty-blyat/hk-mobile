import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final leaveNoController = TextEditingController(text: 'New'.tr);
  final dateController =
      TextEditingController(text: DateTime.now().toString().split(' ')[0]);

  final fromDateController =
      TextEditingController(text: DateTime.now().toString().split(' ')[0]);
  final toDateController =
      TextEditingController(text: DateTime.now().toString().split(' ')[0]);
}
