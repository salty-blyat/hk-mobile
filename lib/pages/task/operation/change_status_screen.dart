import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/pages/task/task_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/button.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

class ChangeStatusScreen extends StatelessWidget {
  final int id;
  final String title;
  final VoidCallback submit;
  ChangeStatusScreen(
      {super.key, required this.id, required this.title, required this.submit});
  TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    controller.statusForm.control("note").value = null;
    return Column(children: [
      _header(title: title),
      _buildContent(context),
      _footer(id: id),
    ]);
  }

  Widget _buildContent(BuildContext context) {
    controller.statusForm.control('id').value = id;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: ReactiveForm(
            formGroup: controller.statusForm,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                MyFormField(
                  label: "Note",
                  controlName: "note",
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header({required String title}) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        color: AppTheme.primaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 16,
            onPressed: () {},
            icon: const Icon(CupertinoIcons.clear, color: Colors.transparent),
          ),
          Center(
            child: Text(
              title.tr,
              style: Get.textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            iconSize: 16,
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.clear, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _footer({required int id}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: MyButton(label: 'Save', onPressed: submit),
    );
  }
}
