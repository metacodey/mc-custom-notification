// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'notification.dart';

class NotificationCalling extends NotificationModel {
  Function(dynamic payload)? onEndCall;
  Function(dynamic payload)? onSpeaker;
  Function(dynamic payload)? onMute;
  NotificationCalling({
    required super.id,
    super.title,
    super.body,
    super.image,
    super.payload,
    super.groupKey,
    super.tag,
    this.onMute,
    this.onSpeaker,
    this.onEndCall,
  });

  @override
  NotificationCalling copyWith({
    Function(dynamic payload)? onEndCall,
    Function(dynamic payload)? onSpeaker,
    Function(dynamic payload)? onMute,
    int? id,
    String? title,
    String? tag,
    String? body,
    String? image,
    Map<String, dynamic>? payload,
    String? groupKey,
  }) {
    return NotificationCalling(
        onEndCall: onEndCall ?? this.onEndCall,
        id: id ?? this.id,
        title: title ?? this.title,
        tag: tag ?? this.tag,
        body: body ?? this.body,
        image: image ?? this.image,
        payload: payload ?? this.payload,
        groupKey: groupKey ?? this.groupKey,
        onMute: onMute ?? this.onMute,
        onSpeaker: onSpeaker ?? this.onSpeaker);
  }
}
