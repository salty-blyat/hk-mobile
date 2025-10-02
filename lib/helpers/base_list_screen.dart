import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:staff_view_ui/utils/drawer.dart';
import 'package:staff_view_ui/utils/theme.dart';
import 'package:staff_view_ui/utils/widgets/no_data.dart';

class BaseList<T> extends StatelessWidget {
  const BaseList({super.key});
  String get title => '';
  bool get isCenterTitle => true;
  bool get isLoading => false;
  bool get isLoadingMore => false;
  bool get fabButton => true;
  bool get showHeader => true;
  RxBool get showDrawer => false.obs;
  Color get backgroundColor => Colors.white;

  void onFabPressed() {}
  Future<void> onRefresh() async {}
  Future<void> onLoadMore() async {}
  bool get canLoadMore => true;
  Widget leading() => const SizedBox.shrink();
  Map<String, List<T>> groupItems(List<T> items) => {};
  RxList<T> get items => RxList.empty();
  List<Widget> actions() => [];
  Widget buildItem(T item) => const SizedBox.shrink();
  Widget buildBottomNavigationBar() => const SizedBox.shrink();
  Widget titleWidget() => Text(
        title.tr,
        style: Get.textTheme.titleLarge!.copyWith(color: Colors.white),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        leading: showDrawer.value ? null : IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=>Get.back()),
        centerTitle: isCenterTitle,
        automaticallyImplyLeading: showDrawer.value,
        title: titleWidget(),
        actions: actions(), 
      ), 
      drawer: showDrawer.value ? DrawerWidget() : null,
      backgroundColor: backgroundColor,
      floatingActionButton: fabButton
          ? FloatingActionButton(
              onPressed: onFabPressed,
              shape: const CircleBorder(),
              child: const Icon(CupertinoIcons.add),
            )
          : null,
      body: Column(
        children: [
          showHeader
              ? Container(color: AppTheme.greyBg, child: buildHeaderWidget())
              : const SizedBox.shrink(),
          Expanded(
            child: Obx(
              () {
                if (isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (items.isEmpty) {
                  return RefreshIndicator(
                      color: Theme.of(context).primaryColor,
                      backgroundColor: Colors.white,
                      onRefresh: onRefresh,
                      // ignore: invalid_use_of_protected_member
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(
                            height: 300,
                            child: Center(child: NoData()),
                          ),
                        ],
                      ));
                }
                return NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollEndNotification &&
                        notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent &&
                        canLoadMore &&
                        !isLoading) {
                      onLoadMore();
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    color: Theme.of(context).primaryColor,
                    backgroundColor: Colors.white,
                    onRefresh: onRefresh,
                    // ignore: invalid_use_of_protected_member
                    child: buildStickyList(items.value),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildHeaderWidget() {
    return Container(
      width: double.infinity,
      // height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadius,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: headerWidget(),
      ),
    );
  }

  Widget headerWidget() => const SizedBox.shrink();

  Widget buildHeader(String section) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        section.tr,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  /// Builds the sticky list
  Widget buildStickyList(List<T> items) {
    final groupedItems = groupItems(items);

    return CustomScrollView(
      slivers: groupedItems.entries.map((entry) {
        final section = entry.key;
        final items = entry.value;
        bool isLastSection(String section) {
          return section == groupedItems.entries.last.key;
        }

        return SliverStickyHeader(
          header: buildHeader(section),
          sliver: SliverList.separated(
            itemBuilder: (context, index) {
              if (index < items.length) {
                return buildItem(items[index]);
              } else if (isLoadingMore && isLastSection(section)) {
                // Add a loading indicator as the last item only for the last section
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return null;
              }
            },
            separatorBuilder: (context, index) =>
                Container(height: 1, color: Colors.grey.shade100),
            itemCount: items.length +
                (isLoadingMore && isLastSection(section) ? 1 : 0),
          ),
        );
      }).toList(),
    );
  }
}
