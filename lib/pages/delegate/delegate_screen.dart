import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/pages/delegate/delegate_controller.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/year_select.dart';

class DelegateScreen extends StatelessWidget {
  DelegateScreen({super.key});

  final DelegateController controller = Get.put(DelegateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delegate'.tr),
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
            onPressed: () {},
            label: 'Edit',
            icon: Icons.edit_square,
            color: AppTheme.primaryColor,
          ),
          _CustomSlideButton(
            onPressed: () {},
            label: 'Delete',
            icon: CupertinoIcons.delete_solid,
            color: AppTheme.dangerColor,
          ),
        ],
      ),
      child: ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        leading: Calendar(date: delegate.fromDate!),
        subtitle: Text(
          delegate.delegatePosition,
          overflow: TextOverflow.ellipsis,
        ),
        title: const Row(
          children: [Text('not done')],
        ),
      ),
    );
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
