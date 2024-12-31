import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/utils/theme.dart';

class YearSelect extends StatelessWidget {
  final List<int> years = [2019, 2020, 2021, 2022, 2023, 2024];
  final selectedYear = 2024.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ' ${selectedYear.value}',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(width: 5),
            const Icon(
              CupertinoIcons.chevron_down,
              color: Colors.black,
              size: 16,
            ),
          ],
        ),
        onPressed: () => {
          showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 300,
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Text(
                            'Cancel'.tr,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Text(
                            'Done'.tr,
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontFamilyFallback: ['NotoSansKhmer', 'Gilroy'],
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color.fromARGB(255, 217, 217, 217),
                      height: 1,
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        onSelectedItemChanged: (int index) {
                          selectedYear.value = years[index];
                        },
                        children: years
                            .map((e) => Center(
                                  child: Text('$e'),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        },
      ),
    );
  }
}
