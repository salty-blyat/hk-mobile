import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/version_server.dart';
import 'package:staff_view_ui/pages/app-info/app_info_controller.dart';
import 'package:staff_view_ui/utils/widgets/input.dart';

class AppInfoOperationScreen extends StatelessWidget {
  AppInfoOperationScreen({super.key});
  final controller = Get.put(AppInfoController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(),
        _buildContent(context),
        _Footer(controller: controller),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            ReactiveForm(
              formGroup: controller.formGroup,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Version'.tr, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      FutureBuilder(
                        future: AppVersion.getAppVersion(),
                        builder: (context, snapshot) {
                          return Text(
                              ': v${snapshot.data ?? '...'} (${Const.date})',
                              style: const TextStyle(fontSize: 16));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MyFormField(
                    controlName: 'coreUrl',
                    label: 'Security URL'.tr,
                  ),
                  MyFormField(
                    controlName: 'apiUrl',
                    label: 'Pavr URL'.tr,
                  ),
                  MyFormField(
                    controlName: 'tenant',
                    label: 'Tenant'.tr,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        color: Theme.of(context).colorScheme.primary,
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
              'Setting'.tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
}

class _Footer extends StatelessWidget {
  final AppInfoController controller;

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
            label: 'Save'.tr,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            onPressed: () {
              controller.save();
            },
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required String label,
    required Color backgroundColor,
    required Color foregroundColor,
    required VoidCallback onPressed,
    bool disabled = false,
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
      onPressed: disabled ? null : onPressed,
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
              : const SizedBox.shrink(),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    ));
  }
}
