import 'package:json_annotation/json_annotation.dart';
import 'package:staff_view_ui/models/attachment_model.dart';

part 'document_model.g.dart';

@JsonSerializable()
class DocumentModel {
  int? docTypeId;
  String? docNo;
  String? title;
  String? note;
  Attachment? attachment;
  int? id;
  String? docTypeName;
  String? docTypeNameKh;
  String? size;

  DocumentModel({
    this.docTypeId,
    this.size,
    this.docNo,
    this.title,
    this.note,
    this.attachment,
    this.id,
    this.docTypeName,
    this.docTypeNameKh,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);
}
