import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/models/working_sheet.dart';
import 'package:staff_view_ui/pages/attendance_cycle/attendance_cycle_select.dart';
import 'package:staff_view_ui/pages/worksheet/worksheet_controller.dart';
import 'package:staff_view_ui/utils/get_date.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/no_data.dart';
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

  final WorkingController controller = Get.put(WorkingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: AttendanceCycleSelect(
          onSelected: (value) {
            controller.startDate.value = getDateOnlyString(value.start!);
            controller.endDate.value = getDateOnlyString(value.end!);
            controller.search();
          },
        ),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      if (controller.isDownloading.value)
                        SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      IconButton(
                        onPressed: () {
                          controller.downloadReport('AttendanceDetailReport');
                        },
                        icon: const Icon(CupertinoIcons.arrow_down_circle,
                            size: 24, color: Colors.white),
                      ),
                    ],
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  Get.toNamed('/attendance-record');
                },
                icon: const Icon(
                  Icons.history,
                  // size: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.working.isEmpty && !controller.loading.value) {
          return const NoData();
        }
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Summary'.tr.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildSummaryItem(
                      Row(
                        children: [
                          _buildRichText(
                              '${controller.total.value.actual}', 'h'),
                          const Text(
                            '/',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              fontFamilyFallback: ['Gilroy', 'Kantumruy'],
                            ),
                          ),
                          _buildRichText(
                              '${controller.total.value.expected}', 'h'),
                        ],
                      ),
                      'Working hour',
                    ),
                    const SizedBox(width: 8),
                    _buildSummaryItem(
                      _buildRichText(
                          '${controller.total.value.permission}', 'h'),
                      'Absent authorized',
                    ),
                    const SizedBox(width: 8),
                    _buildSummaryItem(
                      _buildRichText('${controller.total.value.absent}', 'h'),
                      'Absent unauthorized',
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              // Wrap the ListView.builder in Expanded
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.search();
                },
                child: ListView.separated(
                  itemCount: controller.working.length,
                  itemBuilder: (context, index) {
                    return Skeletonizer(
                      enabled: controller.loading.value,
                      child: ListTile(
                        trailing: controller.working[index].type! !=
                                TYPE.offDuty.value
                            ? !controller.working[index].date!
                                    .isAfter(DateTime.now())
                                ? Tag(
                                    color:
                                        getTagColor(controller.working[index]),
                                    text: getTag(controller.working[index]),
                                  )
                                : null
                            : null,
                        tileColor: getTileColor(controller.working[index]),
                        title: Row(
                          children: [
                            Calendar(
                              date: controller.working[index].date!,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTitle(controller.working[index]),
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

  Widget _buildSummaryItem(Widget child, String label) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          child,
          Text(
            label.tr,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(String value, String unit) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: Const.numberFormat(double.parse(value)),
            style: const TextStyle(
              fontSize: 18,
              fontFamilyFallback: ['Gilroy', 'Kantumruy'],
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
            text: unit.tr,
            style: const TextStyle(
              fontSize: 16,
              fontFamilyFallback: ['Gilroy', 'Kantumruy'],
            ),
          ),
        ],
      ),
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
