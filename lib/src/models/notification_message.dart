// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'notification.dart';

/// A model representing a notification for a message.
///
/// [NotificationMessage] extends [NotificationModel] and includes additional
/// functionality for handling message-related actions such as reading and replying.
/// It also provides options for using inbox-style notifications and enabling vibration.
class NotificationMessage extends NotificationModel {
  /// A callback function triggered when the message is read.
  Function(dynamic payload)? onRead;

  /// A callback function triggered when the user replies to the message.
  Function(dynamic payload)? onReply;

  /// Indicates whether vibration should be enabled for the notification.
  bool isVibration;

  /// Indicates whether the inbox style should be used for the notification.
  bool useInbox;

  /// Constructs a [NotificationMessage] object.
  ///
  /// [id] is required and represents the unique identifier for the notification.
  /// [title], [body], [image], [payload], [groupKey], and [tag] are optional parameters
  /// that provide additional details about the notification.
  /// [onReply] and [onRead] are optional callbacks for handling actions related to the message.
  /// [useInbox] and [isVibration] are optional boolean values that control the notification style and behavior.
  NotificationMessage({
    required super.id,
    super.title,
    super.body,
    super.image,
    super.payload,
    super.groupKey,
    super.tag,
    this.onReply,
    this.onRead,
    this.useInbox = false,
    this.isVibration = false,
  });

  /// Creates a copy of the current [NotificationMessage] instance with modified properties.
  ///
  /// Any of the properties [onReply], [onRead], [isVibration], [id], [useInbox], [title], [tag],
  /// [body], [image], [payload], and [groupKey] can be updated in the new copy. If a property
  /// is not provided, the original value from this instance is retained.
  @override
  NotificationMessage copyWith({
    Function(dynamic payload)? onReply,
    Function(dynamic payload)? onRead,
    bool? isVibration,
    int? id,
    bool? useInbox,
    String? title,
    String? tag,
    String? body,
    String? image,
    Map<String, dynamic>? payload,
    String? groupKey,
  }) {
    return NotificationMessage(
      onReply: onReply ?? this.onReply,
      onRead: onRead ?? this.onRead,
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      body: body ?? this.body,
      image: image ?? this.image,
      payload: payload ?? this.payload,
      groupKey: groupKey ?? this.groupKey,
      useInbox: useInbox ?? this.useInbox,
      isVibration: isVibration ?? this.isVibration,
    );
  }

  /// Converts the [NotificationMessage] object into a map.
  ///
  /// This is useful for serializing the notification data before sending it to the native platform.
  Map<String, dynamic> toMapMsg() {
    return <String, dynamic>{
      'id': id,
      'tag': tag,
      'title': title,
      'body': body,
      'payload': payload,
      'base64Image': image,
      'groupKey': groupKey,
      'useInbox': useInbox ? "1" : "0",
      'isVibration': isVibration ? "1" : "0",
    };
  }
}
