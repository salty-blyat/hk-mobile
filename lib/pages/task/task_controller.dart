import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/housekeeping_model.dart';
import 'package:staff_view_ui/models/task_model.dart';
import 'package:staff_view_ui/pages/task/task_service.dart';

class TaskController extends GetxController {
  final RxString searchText = ''.obs;
  final RxList<TaskModel> list = <TaskModel>[].obs;
  final TaskService service = TaskService();
  final RxBool loading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool canLoadMore = true.obs;

  final FormGroup formGroup = fb.group({
    'roomIds': FormControl<List<int>>(
      value: [],
      validators: [Validators.required],
    ),
    'staffId': FormControl<int>(validators: [Validators.required]),
    'hkActivityType':
        FormControl<int>(value: 2, validators: [Validators.required]),
    'houseKeepingStatus':
        FormControl<String>(validators: [Validators.required]),
    'note': FormControl<String>(validators: [Validators.required]),
  });

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
    await search();
  }

  Future<void> search() async {
    loading.value = true;
    var filter = [
      // {
      //   "field": "reservationId",
      //   "operator": "eq",
      //   "value": "49",
      //   "logic": null,
      //   "manual": true,
      //   "filters": null
      // }
    ];

    // queryParameters.update((params) {
    //   params?.pageIndex = (params.pageIndex ?? 0) + 1;
    // });
    if (searchText.value.isNotEmpty) {
      filter.add({
        'field': 'search',
        'operator': 'contains',
        'value': searchText.value
      });
    }
    try {
      var response = await service.search(
          queryParameters.value, (item) => TaskModel.fromJson(item));
      list.assignAll(response.results as Iterable<TaskModel>);
      canLoadMore.value =
          response.results.length == queryParameters.value.pageSize;
    } catch (e) {
      canLoadMore.value = false;
      print("Error during search: $e");
    } finally {
      loading.value = false;
    }
  }

  Future<void> post() async {
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
    // var response = await service.search(date: selectedDate, queryParameters: {
    //   'pageIndex': currentPage,
    //   'pageSize': pageSize,
    //   'filters': jsonEncode(filter)
    // });
    // if (response.isNotEmpty) {
    //   list.value = response;
    // }
    loading.value = false;
  }
}
