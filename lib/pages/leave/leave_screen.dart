import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/leave/leave_controller.dart';
import 'package:staff_view_ui/pages/leave/leave_operation_screen.dart';

class LeaveScreen extends StatelessWidget {
  LeaveScreen({super.key});

  final LeaveController controller = Get.put(LeaveController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => LeaveOperationScreen());
        },
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add),
      ),
      appBar: AppBar(
        title: Text('Leave'.tr,
            style: context.textTheme.titleLarge!.copyWith(
              color: Colors.white,
            )),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Container();
        },
        itemCount: 10,
      ),
    );
  }
}
