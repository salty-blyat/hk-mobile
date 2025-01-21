import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/pages/overtime/delete/overtime_delete_controller.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';

class OvertimeDeleteScreen extends StatelessWidget {
  final int id;
  final OvertimeDeleteController controller =
      Get.put(OvertimeDeleteController());

  OvertimeDeleteScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    controller.getOvertime(id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Header(),
        Obx(
          () => controller.loading.value
              ? _buildLoading(context)
              : _buildContent(context),
        ),
        _Footer(controller: controller),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        children: [
          _info('Request No'.tr, controller.overtime.value.requestNo!, context),
          _info(
              'Request date'.tr,
              convertToKhmerDate(controller.overtime.value.requestedDate!),
              context),
          _info('Date'.tr, convertToKhmerDate(controller.overtime.value.date!),
              context),
          _info(
              'Time'.tr,
              '${getTime(controller.overtime.value.fromTime!)} - ${getTime(controller.overtime.value.toTime!)}',
              context),
          _info(
              'Total (hours)'.tr,
              '${Const.numberFormat(controller.overtime.value.overtimeHour!)} ${'Hours'.tr}',
              context),
          const SizedBox(height: 8),
          ReactiveForm(
            formGroup: controller.formGroup,
            child: ReactiveTextField<String>(
              formControlName: 'note',
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Note'.tr),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Skeletonizer(
        child: Column(
          children: [
            _info('Request No'.tr, '0000', context),
            _info('Request date'.tr, '10-10-2000', context),
            _info('Date'.tr, '10-10-2000', context),
            _info('Time'.tr, '12:00-01:00', context),
            _info('Total (hours)'.tr, '10 hours', context),
            const SizedBox(height: 8),
            ReactiveForm(
              formGroup: controller.formGroup,
              child: ReactiveTextField<String>(
                formControlName: 'note',
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Note'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title :',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade800,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 16,
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.clear,
              color: Colors.transparent,
            ),
          ),
          Center(
            child: Text('Delete'.tr,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    )),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              CupertinoIcons.clear,
              color: Colors.white,
            ),
            iconSize: 16,
          )
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final OvertimeDeleteController controller;

  const _Footer({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _actionButton(
            context,
            icon: CupertinoIcons.clear,
            label: 'Cancel'.tr,
            backgroundColor: Colors.grey.shade200,
            foregroundColor: Colors.black,
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 16),
          Obx(
            () => _actionButton(
              context,
              icon: CupertinoIcons.trash,
              loading: controller.operationLoading.value,
              label: 'Delete'.tr,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              onPressed: () {
                controller.deleteOvertime();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onPressed,
    bool loading = false,
  }) {
    return Expanded(
        child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loading
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foregroundColor,
                  ),
                )
              : Icon(icon, size: 16),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    ));
  }
}
