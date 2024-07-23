// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'notification.dart';

class NotificationCalling extends NotificationModel {
  Function(dynamic payload)? onEndCall;
  NotificationCalling({
    required super.id,
    super.title,
    super.body,
    super.image,
    super.payload,
    super.groupKey,
    super.tag,
    this.onEndCall,
  });

  @override
  NotificationCalling copyWith({
    Function(dynamic payload)? onAccepted,
    int? id,
    String? title,
    String? tag,
    String? body,
    String? image,
    Map<String, dynamic>? payload,
    String? groupKey,
  }) {
    return NotificationCalling(
      onEndCall: onAccepted ?? this.onEndCall,
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
