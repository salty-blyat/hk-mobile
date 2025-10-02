import 'dart:convert';

import 'package:get/get.dart';
import 'package:staff_view_ui/auth/auth_service.dart';
import 'package:staff_view_ui/const.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/client_info_model.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/pages/housekeeping/housekeeping_service.dart';
import 'package:staff_view_ui/pages/lookup/lookup_controller.dart';
import 'package:staff_view_ui/pages/staff_user/staff_user_controller.dart';

enum HousekeepingView { room, block }

extension HousekeepingViewExtension on HousekeepingView {
  static const Map<HousekeepingView, int> _values = {
    HousekeepingView.room: 1,
    HousekeepingView.block: 2,
  };
  int get value => _values[this]!;
}

class HousekeepingController extends GetxController {
  final RxString searchText = ''.obs;
  final RxList<Housekeeping> selected = <Housekeeping>[].obs;
  final RxList<Housekeeping> list = <Housekeeping>[].obs;
  final HousekeepingService service = HousekeepingService();
  final RxBool loading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool canLoadMore = true.obs;
  final LookupController lookupController = Get.put(LookupController());
  late final DateTime today;
  late String selectedDate;
  final Rx<int> houseKeepingStatus = 0.obs;
  final Rx<int> housekeepingView = HousekeepingView.room.value.obs;
final StaffUserController staffUserController = Get.put(StaffUserController());
  // final AuthService authService = AuthService();

  // Rx<ClientInfo?> auth = Rxn<ClientInfo>();

  int currentPage = 1;
  final int pageSize = 20;
  final queryParameters = QueryParam(
    pageIndex: 1,
    pageSize: 25,
    sorts: '',
    filters: '[]',
  ).obs; 

  @override
  Future<void> onInit() async {
    super.onInit();
    selected.clear(); 
    await staffUserController.getUser();
    print(staffUserController.staffUser.value);
    await lookupController.fetchLookups(LookupTypeEnum.housekeepingStatus.value);
    await search();

    //  try {
    //   final authData = await authService.readFromLocalStorage(Const.authorized['Authorized']!);
    //   auth.value = authData != null && authData.isNotEmpty ? ClientInfo.fromJson(jsonDecode(authData)) : ClientInfo(); 
    // } catch (e) {
    //   print('Error during initialization: $e');
    // }
  }
 
   Future<void> search() async {
    try { 
    loading.value = true;
    var filter = [];

    queryParameters.update((params) {
      params?.pageIndex = (params.pageIndex ?? 0) + 1;
    });

    if (searchText.value.isNotEmpty) {
      filter.add({
        'field': 'search',
        'operator': 'contains',
        'value': searchText.value
      });
    }
    if (houseKeepingStatus.value != 0) {
      filter.add({
        'field': 'houseKeepingStatus',
        'operator': 'contains',
        'value': houseKeepingStatus.value
      });
    }
    var response = await service.search(date: selectedDate, queryParameters: {
      'pageIndex': currentPage,
      'pageSize': pageSize,
      'filters': jsonEncode(filter)
    });
    if (response.isNotEmpty) {
      list.value = response;
    }
    } catch (e){
      loading.value = false;
    } finally {

    loading.value = false;
    }
  }
}
