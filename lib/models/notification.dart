import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

/// A model representing a generic notification.
///
/// [NotificationModel] encapsulates common properties of a notification, such as
/// an ID, title, body, image, payload, and group key. This base model can be extended
/// or used directly to represent different types of notifications.
class NotificationModel {
  /// The unique identifier for the notification.
  int id;

  /// An optional tag that can be used to categorize or identify the notification.
  String? tag;

  /// The title of the notification.
  String? title;

  /// The body text of the notification.
  String? body;

  /// A base64-encoded string representing an image associated with the notification.
  String? image;

  /// An optional payload containing additional data for the notification.
  Map<String, dynamic>? payload;

  /// A key used to group related notifications together.
  String? groupKey;

  /// Constructs a [NotificationModel] object.
  ///
  /// The [id] parameter is required, while the other parameters are optional.
  NotificationModel({
    required this.id,
    this.title,
    this.tag,
    this.body,
    this.image,
    this.payload,
    this.groupKey,
  });

  /// Creates a copy of the current [NotificationModel] instance with modified properties.
  ///
  /// Any of the properties [id], [title], [tag], [body], [image], [payload], and [groupKey]
  /// can be updated in the new copy. If a property is not provided, the original value from
  /// this instance is retained.
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

  /// Constructs a [NotificationModel] from a map.
  ///
  /// The [map] parameter must contain keys corresponding to the properties of the model.
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

  /// Constructs a [NotificationModel] from a JSON string.
  ///
  /// The [source] parameter must be a valid JSON string representation of a map.
  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Converts the [NotificationModel] to a map.
  ///
  /// This is useful for serializing the notification data to be stored or transmitted.
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

  /// Converts the [NotificationModel] to a map with stringified values.
  ///
  /// This is particularly useful for sending data where all values must be strings.
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

  /// Converts the [NotificationModel] to a JSON string suitable for sending.
  ///
  /// This method uses [toMapSend] to first convert the model to a map with stringified values.
  String toJsonSend() => json.encode(toMapSend());

  /// Converts the [NotificationModel] to a JSON string.
  ///
  /// This method uses [toMap] to first convert the model to a map.
  String toJson() => json.encode(toMap());
}
