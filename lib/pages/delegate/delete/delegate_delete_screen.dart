import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/pages/delegate/delete/delegate_delete_controller.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';

class DelegateDeleteScreen extends StatelessWidget {
  final int id;
  final DelegateDeleteController controller =
      Get.put(DelegateDeleteController());

  DelegateDeleteScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    controller.getDelegate(id);
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
          _info(
              'From Date'.tr,
              convertToKhmerDate(
                  controller.delegate.value.fromDate ?? DateTime.now()),
              context),
          _info(
              'To Date'.tr,
              convertToKhmerDate(
                  controller.delegate.value.toDate ?? DateTime.now()),
              context),
          _info('Total (days)'.tr, controller.totalDays.value.toString(),
              context),
          const SizedBox(height: 8),
          ReactiveForm(
            formGroup: controller.formGroup,
            child: ReactiveTextField<String>(
              formControlName: 'reason',
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
            _info('From date'.tr, '10-10-2000', context),
            _info('To date'.tr, '10-10-2000', context),
            _info('Total (days)'.tr, '10 days', context),
            const SizedBox(height: 8),
            ReactiveForm(
              formGroup: controller.formGroup,
              child: ReactiveTextField<String>(
                formControlName: 'reason',
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
  final DelegateDeleteController controller;

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
                controller.deleteDelegate();
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
