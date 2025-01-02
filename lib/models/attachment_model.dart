import 'package:json_annotation/json_annotation.dart';

part 'attachment_model.g.dart';

@JsonSerializable()
class Attachment {
  final String uid;
  final String url;
  final String name;

  Attachment({
    required this.uid,
    required this.url,
    required this.name,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);
}
