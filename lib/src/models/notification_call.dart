// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'notification.dart';

/// A model representing a call notification.
///
/// [NotificationCall] extends [NotificationModel] and includes additional
/// functionality for handling call-specific actions such as accepting or denying the call.
class NotificationCall extends NotificationModel {
  /// A callback function triggered when the call is accepted.
  Function(dynamic payload)? onAccepted;

  /// A callback function triggered when the call is denied.
  Function()? onDenied;

  /// Constructs a [NotificationCall] object.
  ///
  /// [id] is required and represents the unique identifier for the notification.
  /// [title], [body], [image], [payload], [groupKey], and [tag] are optional parameters
  /// that provide additional details about the notification.
  /// [onAccepted] and [onDenied] are optional callbacks for handling actions
  /// related to the call.
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

  /// Creates a copy of the current [NotificationCall] instance with modified properties.
  ///
  /// Any of the properties [onAccepted], [onDenied], [id], [title], [tag], [body],
  /// [image], [payload], and [groupKey] can be updated in the new copy. If a property
  /// is not provided, the original value from this instance is retained.
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
