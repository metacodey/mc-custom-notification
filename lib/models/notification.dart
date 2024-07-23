import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationModel {
  int id;
  String? tag;
  String? title;
  String? body;
  String? image;
  Map<String, dynamic>? payload;
  String? groupKey;
  NotificationModel({
    required this.id,
    this.title,
    this.tag,
    this.body,
    this.image,
    this.payload,
    this.groupKey,
  });

  NotificationModel copyWith({
    int? id,
    String? title,
    String? tag,
    String? body,
    String? image,
    Map<String, dynamic>? payload,
    String? groupKey,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      body: body ?? this.body,
      image: image ?? this.image,
      payload: payload ?? this.payload,
      groupKey: groupKey ?? this.groupKey,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tag': tag,
      'title': title,
      'body': body,
      'payload': payload,
      'base64Image': image,
      'groupKey': groupKey,
    };
  }

  String toJson() => json.encode(toMap());
}
