import 'package:json_annotation/json_annotation.dart';

part 'user_info_model.g.dart';

@JsonSerializable()
class Staff {
  String? name;
  String? latinName;
  String? code;
  int? supervisorId;
  int? sexId;
  int? positionId;
  int? departmentId;
  int? officeId;
  int? branchId;
  DateTime? dateOfBirth;
  DateTime? joinDate;
  String? phone;
  String? email;
  String? address;
  int? contractTypeId;
  int? staffLevelId;
  String? photo;
  String? idNumber;
  int? idType;
  int? tittleId;
  int? scheduleId;
  int? id;
  int? statusId;
  String? sexName;
  String? sexNameKh;
  String? positionName;
  String? departmentName;
  String? pathName;
  String? officeName;
  String? branchName;
  String? contractTypeName;
  String? detailInfoString;
  String? photoString;
  String? staffLevelCode;
  String? supervisorName;
  String? statusName;
  String? idTypeName;
  String? tittleName;
  String? scheduleName;
  String? salaryModeName;
  String? paymentMethodName;
  int? salary;
  int? salaryMode;
  int? paymentMethodId;
  String? payrollAccountNo;

  Staff({this.name, this.latinName, this.code, this.supervisorId, this.sexId, this.positionId, this.departmentId, this.officeId, this.branchId, this.dateOfBirth, this.joinDate, this.phone, this.email, this.address, this.contractTypeId, this.staffLevelId, this.photo, this.idNumber, this.idType, this.tittleId, this.scheduleId, this.id, this.statusId, this.sexName, this.sexNameKh, this.positionName, this.departmentName, this.pathName, this.officeName, this.branchName, this.contractTypeName, this.detailInfoString, this.photoString, this.staffLevelCode, this.supervisorName, this.statusName, this.idTypeName, this.tittleName, this.scheduleName, this.salaryModeName, this.paymentMethodName, this.salary, this.salaryMode, this.paymentMethodId, this.payrollAccountNo});

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
  Map<String, dynamic> toJson() => _$StaffToJson(this);
}

