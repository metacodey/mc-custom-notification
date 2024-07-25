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

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: int.parse(map['id'] ?? '0'),
      tag: map['tag'] != null ? map['tag'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      payload: map['payload'] != null
          ? Map<String, dynamic>.from(
              (jsonDecode(map['payload']) as Map<String, dynamic>))
          : null,
      groupKey: map['groupKey'] != null ? map['groupKey'] as String : null,
    );
  }

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

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

  Map<String, dynamic> toMapSend() {
    return <String, dynamic>{
      'id': id.toString(),
      'tag': tag.toString(),
      'title': title.toString(),
      'body': body.toString(),
      'payload': jsonEncode(payload),
      'image': image.toString(),
      'groupKey': groupKey.toString(),
    };
  }

  String toJsonSend() => json.encode(toMapSend());
  String toJson() => json.encode(toMap());
}
