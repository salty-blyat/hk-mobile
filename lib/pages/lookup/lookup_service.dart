import 'dart:convert';

import 'package:staff_view_ui/helpers/token_interceptor.dart';
import 'package:staff_view_ui/models/lookup_model.dart';

class LookupService {
  final dio = DioClient();
  Future<List<LookupModel>> getLookup(int lookupTypeId) async {
    final response = await dio.get('/lookupitem', queryParameters: {
      'pageSize': 50,
      'pageIndex': 1,
      'sorts': '',
      'filters': json.encode([
        {'field': 'lookupTypeId', 'operator': 'eq', 'value': lookupTypeId}
      ])
    });
    return (response?.data['results'] as List)
        .map((e) => LookupModel.fromJson(e))
        .toList();
  }
}
