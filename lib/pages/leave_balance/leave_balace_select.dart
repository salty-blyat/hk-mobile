import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/pages/leave_balance/leave_balace_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';

class LeaveBalaceSelect extends StatelessWidget {
  LeaveBalaceSelect({
    super.key,
    required this.selectedId,
    required this.onPressed,
  });
  final LeaveBalanceController controller = Get.put(LeaveBalanceController());
  final RxInt selectedId;
  final void Function(int leaveTypeId) onPressed;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Skeletonizer(
          child: Container(
            height: 65,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: const Size(86, 0),
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {},
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('10/30'),
                        Text('Total'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }

      if (controller.leaveTypes.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        height: 65,
        margin: const EdgeInsets.only(bottom: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.leaveTypes.length,
          itemBuilder: (context, index) {
            final leaveType = controller.leaveTypes[index];
            final leaveBalance = controller.leaveBalance.value;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                final isSelected = selectedId.value == leaveType.id;

                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    backgroundColor: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.secondaryColor,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    onPressed(leaveType.id!);
                  },
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 70),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontFamilyFallback: const [
                                  'Gilroy',
                                  'Kantumruy'
                                ],
                              ),
                              children: [
                                // Display totalAvail (use leaveBalance.totalAvail if leaveType.id == 0)
                                TextSpan(
                                  text: (leaveType.id == 0)
                                      ? '${leaveBalance.totalAvail ?? 0}' // Use totalAvail for total
                                      : '${leaveBalance.leaveBalances?.where((item) => item.leaveTypeId == leaveType.id).firstOrNull?.totalAvail ?? 0}', // Use firstOrNull to avoid errors
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Conditionally display '/' and totalEntitle only if leaveType.id matches
                                if (leaveType.id == 0 ||
                                    leaveBalance.leaveBalances?.any((item) =>
                                            item.leaveTypeId == leaveType.id) ==
                                        true)
                                  const TextSpan(
                                    text: '/',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                if (leaveType.id == 0 ||
                                    leaveBalance.leaveBalances?.any((item) =>
                                            item.leaveTypeId == leaveType.id) ==
                                        true)
                                  TextSpan(
                                    text: (leaveType.id == 0)
                                        ? '${leaveBalance.totalEntitle ?? 0}' // Use totalEntitle for total
                                        : '${leaveBalance.leaveBalances?.where((item) => item.leaveTypeId == leaveType.id).firstOrNull?.totalEntitle ?? 0}', // Use firstOrNull to avoid errors
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            leaveType.name ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      );
    });
  }
}
