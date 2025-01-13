import 'package:dio/dio.dart';
import 'package:staff_view_ui/helpers/base_service.dart';
import 'package:staff_view_ui/models/request_model.dart';

class RequestApproved extends BaseModel {
  int? nextApproverId;

  RequestApproved.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    nextApproverId = json['nextApproverId'];
  }
}

class RequestRejected extends BaseModel {
  RequestRejected.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
  }
}

class RequestUndo extends BaseModel {
  RequestUndo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
  }
}

class RequestApproveService extends BaseService<RequestModel> {
  RequestApproveService() : super('request');
  Future<Response<RequestModel>> findByReqType(int id, int reqType) async {
    return await dio.get<RequestModel>('$apiUrl/requesttype/$id/$reqType');
  }

  Future<Response<bool>> canDoAction(int id) async {
    return await dio.get<bool>('$apiUrl/can-do-action/$id');
  }

  Future<Response<RequestModel>> reject(RequestRejected model) async {
    return await dio.post<RequestModel>('$apiUrl/reject', data: model);
  }

  Future<Response<RequestModel>> approve(RequestApproved model) async {
    return await dio.post<RequestModel>('$apiUrl/approve', data: model);
  }

  Future<Response<RequestModel>> undo(RequestUndo model) async {
    return await dio.post<RequestModel>('$apiUrl/undo', data: model);
  }
}
