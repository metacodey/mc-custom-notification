// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'notification.dart';

class NotificationCall extends NotificationModel {
  Function(dynamic payload)? onAccepted;

  Function()? onDenied;
  NotificationCall({
    required super.id,
    super.title,
    super.body,
    super.image,
    super.payload,
    super.groupKey,
    super.tag,
    this.onAccepted,
    this.onDenied,
  });

  @override
  NotificationCall copyWith({
    Function(dynamic payload)? onAccepted,
    Function()? onDenied,
    int? id,
    String? title,
    String? tag,
    String? body,
    String? image,
    Map<String, dynamic>? payload,
    String? groupKey,
  }) {
    return NotificationCall(
      onAccepted: onAccepted ?? this.onAccepted,
      onDenied: onDenied ?? this.onDenied,
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
