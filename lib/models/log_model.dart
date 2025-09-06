import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/helpers/base_service.dart'; 

part 'log_model.g.dart';

@JsonSerializable()
class Log extends BaseModel {


int? requestId;                                 
int? staffId;                                   
String? staffName;                                 
int? status;                                    
String? statusNameKh;                              
String? statusNameEn;                              
String? statusImage;                       
String ? createdBy;                                 
DateTime? createdDate;                               
 
  Log({
this.requestId,
this.staffId,
this.staffName,
this.status,
this.statusNameKh,
this.statusNameEn,
this.statusImage,
this.createdBy,
this.createdDate,
  });

  factory Log.fromJson(Map<String, dynamic> json) =>
      _$LogFromJson(json);
  Map<String, dynamic> toJson() => _$LogToJson(this);
}
