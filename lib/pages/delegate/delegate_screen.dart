// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/delegate/delegate_controller.dart';
import 'package:staff_view_ui/pages/delegate/operation/delegate_operation_screen.dart';
import 'package:staff_view_ui/utils/get_date.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/khmer_date_formater.dart';
import 'package:staff_view_ui/utils/style.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';

enum FilterDelegateTypes {
  Uncompleted(1),
  Completed(2);

  final int value;
  const FilterDelegateTypes(this.value);
}

enum DelegateStatus { Active, Upcoming, Completed }

class DelegateScreen extends StatelessWidget {
  DelegateScreen({super.key});

  final DelegateController controller = Get.put(DelegateController());

  @override
  Widget build(BuildContext context) {
    controller.search();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => DelegateOperationScreen()),
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add),
      ),
      appBar: AppBar(
        title: Text('Delegate'.tr),
        actions: [
          IconButton(
            iconSize: 30,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 0, 0),
                items: FilterDelegateTypes.values
                    .map((e) => PopupMenuItem<FilterDelegateTypes>(
                          value: e,
                          child: Row(
                            children: [
                              Icon(
                                controller.filterType.value == e
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                e.name.tr,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ).then((selectedValue) {
                if (selectedValue != null) {
                  controller.filterType.value = selectedValue;
                  controller.lists.clear();
                  controller.currentPage = 1;
                  controller.search();
                }
              });
            },
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildYearSelector(),
          Expanded(
            child: Obx(() {
              if (controller.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.lists.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.add_circled,
                        size: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Not found'.tr,
                        style: context.textTheme.bodyLarge,
                      )
                    ],
                  ),
                );
              }

              return _buildStickyDelegateList();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyDelegateList() {
    final groupedDelegate = _groupDelegateByMonth(controller.lists);

    return CustomScrollView(
      slivers: groupedDelegate.entries.map((entry) {
        final month = entry.key;
        final delegates = entry.value;

        return SliverStickyHeader(
          header: _buildStickyHeader(month),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
              final delegate = delegates[index];
              return _buildDelegateItem(delegate);
            },
            separatorBuilder: (context, index) => Container(
              color: Colors.grey.shade300,
              width: double.infinity,
              height: 1,
            ),
            itemCount: delegates.length,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStickyHeader(String month) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        month.tr,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildDelegateItem(delegate) {
    return Slidable(
      key: Key(delegate.id.toString()),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          _CustomSlideButton(
            onPressed: () {
              Get.to(() => DelegateOperationScreen(id: delegate.id));
            },
            label: 'Edit',
            icon: Icons.edit_square,
            color: AppTheme.primaryColor,
          ),
          _CustomSlideButton(
            onPressed: () {
              controller.delete(delegate.id);
            },
            label: 'Delete',
            icon: CupertinoIcons.delete_solid,
            color: AppTheme.dangerColor,
          ),
        ],
      ),
      child: Stack(
        children: [
          ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            leading: delegate.delegatePhoto != null
                ? CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        delegate.delegatePhoto,
                        fit: BoxFit.cover,
                        height: 64,
                        width: 64,
                      ),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                    child: Text(
                      delegate.staffDelegateName
                              ?.substring(0, 1)
                              .toUpperCase() ??
                          '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '${delegate.delegateTitle ?? ''} ${delegate.staffDelegateName ?? ''}'
                        .trim(),
                    style: const TextStyle(
                      fontSize: 14,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    delegate.delegatePosition,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    getDateOnly(delegate.fromDate) ==
                            getDateOnly(delegate.toDate)
                        ? convertToKhmerDate(delegate.fromDate)
                        : '${convertToKhmerDate(delegate.fromDate)} ~ ${convertToKhmerDate(delegate.toDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    '${delegate.toDate.difference(delegate.fromDate).inDays + 1} ${'Day'.tr}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Tag(
                    color: Style.getDelegateStatusColor(
                        _getStatus(delegate.fromDate, delegate.toDate)),
                    text: _getStatus(delegate.fromDate, delegate.toDate).name,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  DelegateStatus _getStatus(DateTime fromDate, DateTime toDate) {
    final currentDate = getDateOnly(DateTime.now());
    final from = getDateOnly(fromDate);
    final to = getDateOnly(toDate);

    if (currentDate.isBefore(from)) {
      return DelegateStatus.Upcoming;
    } else if (currentDate.isAfter(to)) {
      return DelegateStatus.Completed;
    } else {
      return DelegateStatus.Active;
    }
  }

  Widget _buildYearSelector() {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.only(left: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: YearSelect(
          onYearSelected: (year) {
            controller.year.value = year;
            controller.search();
          },
        ),
      ),
    );
  }

  Map<String, List<dynamic>> _groupDelegateByMonth(List<dynamic> delegates) {
    final Map<String, List<dynamic>> grouped = {};

    for (var delegate in delegates) {
      final month = getMonth(delegate.fromDate!);
      grouped.putIfAbsent(month, () => []).add(delegate);
    }

    return grouped;
  }
}

class _CustomSlideButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  const _CustomSlideButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: SizedBox.expand(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Text(
                label.tr,
                style: Get.textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
