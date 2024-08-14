// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'notification.dart';

/// A model representing a notification for an ongoing call.
///
/// [NotificationCalling] extends [NotificationModel] and includes additional
/// functionality for handling in-call actions such as ending the call, muting, and
/// toggling the speaker.
class NotificationCalling extends NotificationModel {
  /// A callback function triggered when the call is ended.
  Function(dynamic payload)? onEndCall;

  /// A callback function triggered when the speaker is toggled.
  Function(dynamic payload)? onSpeaker;

  /// A callback function triggered when the mute is toggled.
  Function(dynamic payload)? onMute;

  /// Constructs a [NotificationCalling] object.
  ///
  /// [id] is required and represents the unique identifier for the notification.
  /// [title], [body], [image], [payload], [groupKey], and [tag] are optional parameters
  /// that provide additional details about the notification.
  /// [onEndCall], [onSpeaker], and [onMute] are optional callbacks for handling
  /// actions related to the call.
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

  /// Creates a copy of the current [NotificationCalling] instance with modified properties.
  ///
  /// Any of the properties [onEndCall], [onSpeaker], [onMute], [id], [title], [tag], [body],
  /// [image], [payload], and [groupKey] can be updated in the new copy. If a property
  /// is not provided, the original value from this instance is retained.
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
      onSpeaker: onSpeaker ?? this.onSpeaker,
    );
  }
}
