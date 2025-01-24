import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/models/working_sheet.dart';
import 'package:staff_view_ui/pages/working/working_controller.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';

enum TYPE {
  present(1),
  offDuty(4),
  absent(5);

  final int value;
  const TYPE(this.value);
}

class WorkingScreen extends StatelessWidget {
  WorkingScreen({super.key});

  final WorkingController workingController = Get.put(WorkingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Implement download functionality
            },
            child: Row(
              children: [
                const Icon(CupertinoIcons.arrow_down_circle,
                    size: 24, color: Colors.white),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/attendance-record');
                  },
                  child: Text('History'.tr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamilyFallback: ['Gilroy', 'Kantumruy'])),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (workingController.working.isEmpty &&
            !workingController.isLoading.value) {
          return const Center(child: Text('No data found'));
        }
        if (workingController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Text(
                'Summary'.tr,
                style: const TextStyle(color: Colors.black54),
              ),
            ),
            Expanded(
              // Wrap the ListView.builder in Expanded
              child: RefreshIndicator(
                onRefresh: () async {
                  await workingController.getWorking();
                },
                child: ListView.separated(
                  itemCount: workingController.working.length,
                  itemBuilder: (context, index) {
                    return Skeletonizer(
                      enabled: workingController.isLoading.value,
                      child: ListTile(
                        trailing: workingController.working[index].type! !=
                                TYPE.offDuty.value
                            ? !workingController.working[index].date!
                                    .isAfter(DateTime.now())
                                ? Tag(
                                    color: getTagColor(
                                        workingController.working[index]),
                                    text: getTag(
                                        workingController.working[index]),
                                  )
                                : null
                            : null,
                        tileColor:
                            getTileColor(workingController.working[index]),
                        title: Row(
                          children: [
                            Calendar(
                              date: workingController.working[index].date!,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTitle(workingController.working[index]),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      color: Colors.grey.shade400,
                      width: double.infinity,
                      height: 1,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

Color getTileColor(Worksheets working) {
  if (working.type == TYPE.offDuty.value) {
    return Colors.grey.shade300;
  }
  if (working.type == TYPE.absent.value) {
    if (working.date!.isAfter(DateTime.now())) {
      return Colors.grey.shade50;
    }
    return AppTheme.dangerColor.withOpacity(0.12);
  }
  return Colors.grey.shade50;
}

Color getTagColor(Worksheets working) {
  double percentage =
      working.adrWorkingHour! * 100 / working.expectedWorkingHour!;

  if (working.type! == TYPE.present.value) {
    if (percentage >= 90) {
      return AppTheme.successColor;
    } else if (percentage >= 80) {
      return AppTheme.warningColor;
    } else if (percentage >= 75) {
      return AppTheme.warningColor;
    } else if (percentage >= 60) {
      return AppTheme.warningColor;
    } else if (percentage >= 1) {
      return AppTheme.warningColor;
    }
  }
  return AppTheme.dangerColor;
}

String getTitle(Worksheets working) {
  if (working.holiday?.isNotEmpty == true) {
    return working.holiday!;
  }
  if (working.leaveReason?.isNotEmpty == true) {
    return working.leaveReason!;
  }
  if (working.missionObjective?.isNotEmpty == true) {
    return working.missionObjective!;
  }
  if (working.type! == TYPE.present.value) {
    return '${'Working'.tr} ${working.adrWorkingHour}${'h'.tr} / ${working.expectedWorkingHour}${'h'.tr}';
  }
  if (working.type! == TYPE.offDuty.value) {
    return 'Day off'.tr;
  }
  if (working.type! == TYPE.absent.value) {
    if (working.date!.isAfter(DateTime.now())) {
      return '';
    }
    return 'Absent unauthorized'.tr;
  }
  return '';
}

String getTag(Worksheets working) {
  return getPerformanceRating(
      working.adrWorkingHour!, working.expectedWorkingHour!);
}

String getPerformanceRating(double workingHour, double expectedWorkingHour) {
  double percentage = workingHour * 100 / expectedWorkingHour;

  if (percentage >= 90) {
    return "Excellent";
  } else if (percentage >= 80) {
    return "Good";
  } else if (percentage >= 75) {
    return "Fairly Good";
  } else if (percentage >= 60) {
    return "Average";
  } else if (percentage >= 1) {
    return "Poor";
  } else {
    return "Will Take Action";
  }
}
