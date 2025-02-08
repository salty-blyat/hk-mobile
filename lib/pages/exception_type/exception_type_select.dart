import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/pages/exception_type/exception_type_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';

class ExceptionTypeSelect extends StatelessWidget {
  ExceptionTypeSelect({super.key, this.exceptionTypeId = 0});
  final ExceptionTypeController controller = Get.put(ExceptionTypeController());
  final int exceptionTypeId;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Skeletonizer(
          child: SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadius,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('Leave'),
                ),
              ),
            ),
          ),
        );
      }

      if (controller.exceptionTypes.isEmpty) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 45,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.exceptionTypes.length,
          itemBuilder: (context, index) {
            final exceptionType = controller.exceptionTypes[index];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                final isSelected = exceptionTypeId == exceptionType.id;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppTheme.borderRadius,
                    ),
                    backgroundColor: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  onPressed: () {},
                  child: Text(exceptionType.name ?? ''),
                );
              }),
            );
          },
        ),
      );
    });
  }
}
