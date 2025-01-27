// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    DocumentModel(
      docTypeId: (json['docTypeId'] as num?)?.toInt(),
      size: json['size'] as String?,
      docNo: json['docNo'] as String?,
      title: json['title'] as String?,
      note: json['note'] as String?,
      attachment: json['attachment'] == null
          ? null
          : Attachment.fromJson(json['attachment'] as Map<String, dynamic>),
      id: (json['id'] as num?)?.toInt(),
      docTypeName: json['docTypeName'] as String?,
      docTypeNameKh: json['docTypeNameKh'] as String?,
    );

Map<String, dynamic> _$DocumentModelToJson(DocumentModel instance) =>
    <String, dynamic>{
      'docTypeId': instance.docTypeId,
      'docNo': instance.docNo,
      'title': instance.title,
      'note': instance.note,
      'attachment': instance.attachment,
      'id': instance.id,
      'docTypeName': instance.docTypeName,
      'docTypeNameKh': instance.docTypeNameKh,
      'size': instance.size,
    };
