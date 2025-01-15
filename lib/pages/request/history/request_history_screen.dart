import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/models/request_model.dart';
import 'package:staff_view_ui/pages/request/history/request_history_controller.dart';
import 'package:staff_view_ui/pages/request/view/request_view_screen.dart';
import 'package:staff_view_ui/utils/get_date_name.dart';
import 'package:staff_view_ui/utils/style.dart';
import 'package:staff_view_ui/utils/widgets/calendar.dart';
import 'package:staff_view_ui/utils/widgets/tag.dart';

class RequestHistoryScreen extends StatelessWidget {
  RequestHistoryScreen({super.key});

  final RequestHistoryController controller =
      Get.put(RequestHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request/Approve History'.tr),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildStickyLeaveList();
      }),
    );
  }

  Widget _buildStickyLeaveList() {
    // Group the leave requests by month
    final groupedLeaves = _groupLeavesByMonth(controller.lists);

    return RefreshIndicator(
      onRefresh: () async {
        controller.search();
      },
      child: CustomScrollView(
        slivers: groupedLeaves.entries.map((entry) {
          final month = entry.key;
          final leaves = entry.value;

          return SliverStickyHeader(
            header: _buildStickyHeader(month),
            sliver: SliverList.separated(
              itemBuilder: (context, index) {
                final leave = leaves[index];
                return _buildLeaveItem(leave);
              },
              separatorBuilder: (context, index) => Container(
                color: Colors.grey.shade300,
                width: double.infinity,
                height: 1,
              ),
              itemCount: leaves.length,
            ),
          );
        }).toList(),
      ),
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

  Widget _buildLeaveItem(RequestModel leave) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      leading: Calendar(date: leave.requestedDate!),
      subtitle: Text(
        leave.title!,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
      title: Row(
        children: [
          Text(
            leave.staffNameKh!,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            leave.requestTypeName!.tr,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: Get.theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            leave.requestNo!,
            style: Get.textTheme.bodySmall!.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 12),
          Tag(
            color: Style.getStatusColor(leave.status!),
            text: leave.statusNameKh ?? leave.statusName!.tr,
          ),
        ],
      ),
      onTap: () {
        Get.to(() => RequestViewScreen(),
            arguments: {'id': leave.id!, 'reqType': 0});
      },
    );
  }

  Map<String, List<RequestModel>> _groupLeavesByMonth(
      List<RequestModel> leaves) {
    final Map<String, List<RequestModel>> grouped = {};

    for (var leave in leaves) {
      final month = getMonth(leave.requestedDate!);
      grouped.putIfAbsent(month, () => []).add(leave);
    }

    return grouped;
  }
}
