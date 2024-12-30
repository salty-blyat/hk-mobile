import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

class LeaveOperationScreen extends StatelessWidget {
  final LeaveController controller = Get.put(LeaveController());
  LeaveOperationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              MyFormField(
                label: 'Leave No',
                icon: Icons.person,
                controller: controller.leaveNoController,
                disabled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
