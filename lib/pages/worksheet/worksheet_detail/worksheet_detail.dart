import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:staff_view_ui/pages/worksheet/worksheet_detail/worksheet_detail_controller.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/summary_box.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';

class WorkingDetailBottomSheet extends StatelessWidget {
  const WorkingDetailBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkingDetailController());

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return Obx(() {
                if (controller.isLoading.value) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Worksheet'.tr,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Calendar(date: controller.working.value!.date!),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SummaryBox(
                                    label: 'Working hour',
                                    height: 56,
                                    child: Row(
                                      children: [
                                        RichTextWidget(
                                          value:
                                              '${controller.working.value!.adrWorkingHour}',
                                          unit: 'h',
                                          fontSize: 16,
                                        ),
                                        const Text(
                                          '/',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 4,
                                            fontFamilyFallback: [
                                              'Gilroy',
                                              'Kantumruy'
                                            ],
                                          ),
                                        ),
                                        RichTextWidget(
                                          value:
                                              '${controller.working.value!.expectedWorkingHour}',
                                          unit: 'h',
                                          fontSize: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SummaryBox(
                                    label: 'Absent authorized',
                                    height: 56,
                                    child: RichTextWidget(
                                      value:
                                          '${controller.working.value!.absentAuthHour}',
                                      unit: 'h',
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SummaryBox(
                                    label: 'Absent unauthorized',
                                    height: 56,
                                    child: RichTextWidget(
                                      value:
                                          '${controller.working.value!.absentUnAuthHour}',
                                      unit: 'h',
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Scan Log'.tr,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: controller.attendanceRecord.length,
                        itemBuilder: (context, index) {
                          final item = controller.attendanceRecord[index];
                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: convertToKhmerDate(item.time!),
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        TextSpan(
                                          text:
                                              ' ${DateFormat('h:mm a').format(item.time!.toLocal())}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 14),
                                  )
                                ],
                              ),
                              subtitle: Text(
                                item.terminalName!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Tag(
                                    color:
                                        item.checkInOutTypeName!.contains('In')
                                            ? AppTheme.successColor
                                            : AppTheme.dangerColor,
                                    text: item.checkInOutTypeNameKh!.trim(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              });
            },
          )),
    );
  }
}
