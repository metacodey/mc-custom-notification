// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'notification.dart';

class NotificationMessage extends NotificationModel {
  Function(dynamic payload)? onRead;

  Function(dynamic payload)? onReply;
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
  });

  @override
  NotificationMessage copyWith({
    Function(dynamic payload)? onReply,
    Function(dynamic payload)? onRead,
    int? id,
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
    );
  }
}
