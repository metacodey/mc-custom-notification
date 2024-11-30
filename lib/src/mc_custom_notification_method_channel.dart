import 'dart:convert';
import 'dart:developer';
import 'package:mc_custom_notification/src/mc_custom_notification_platform_interface.dart';
import 'package:mc_custom_notification/src/models/notification.dart';
import 'package:mc_custom_notification/src/models/notification_call.dart';
import 'package:mc_custom_notification/src/models/notification_calling.dart';
import 'package:mc_custom_notification/src/models/notification_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// An implementation of [McCustomNotificationPlatform] that uses method channels
/// to communicate with the native platform for handling notifications.
class MethodChannelMcCustomNotification extends McCustomNotificationPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('costum_notification');
  final methodChannelCall = const MethodChannel('costum_notification_call');
  final methodChannelCalling =
      const MethodChannel('costum_notification_calling');
  final methodChannelMessage =
      const MethodChannel('costum_notification_message');

  @override
  void initialize({Function(dynamic payload)? onClick}) {
    methodChannel.setMethodCallHandler(
      (call) => _handleMethod(
        call: call,
        onClick: onClick,
      ),
    );
  }

  /// Displays a call notification using the provided [NotificationCall] model.
  ///
  /// [model] contains the details of the call notification.
  @override
  Future<void> showNotificationCall({required NotificationCall model}) async {
    await methodChannelCall.invokeMethod<void>(
        'showNotificationCall', model.toMap());
    methodChannelCall.setMethodCallHandler(
      (call) => _handleMethod(
          call: call, onAccepted: model.onAccepted, onDenied: model.onDenied),
    );
  }

  /// Displays an ongoing call notification using the provided [NotificationCalling] model.
  ///
  /// [model] contains the details of the ongoing call notification.
  @override
  Future<void> showNotificationCalling(
      {required NotificationCalling model}) async {
    model = model.copyWith(tag: "calling${model.tag}");
    await methodChannelCalling.invokeMethod<void>(
        'showNotificationCalling', model.toMap());
    methodChannelCalling.setMethodCallHandler(
      (call) => _handleMethod(
          call: call,
          onEndCall: model.onEndCall,
          onMute: model.onMute,
          onSpeaker: model.onSpeaker),
    );
  }

  /// Displays a message notification using the provided [NotificationMessage] model.
  ///
  /// [model] contains the details of the message notification.
  /// [imageUrl] is the URL of the image associated with the notification.
  @override
  Future<void> showNotificationMessage(
      {required NotificationMessage model, String? imageUrl}) async {
    if (model.useInbox) {
      model.payload = {"imageUrl": imageUrl, ...model.payload ?? {}};
    }
    await methodChannelMessage.invokeMethod<void>(
        'showNotificationMessage', model.toMapMsg());
    methodChannelMessage.setMethodCallHandler(
      (call) => _handleMethod(
        call: call,
        onRead: model.onRead,
        onReplay: model.onReply,
      ),
    );
  }

  /// Displays a normal notification using the provided [NotificationModel].
  ///
  /// [model] contains the details of the normal notification.
  @override
  Future<void> showNotificationNormal(
      {required NotificationModel model}) async {
    await methodChannel.invokeMethod<void>(
        'showNotificationNormal', model.toMap());
  }

  /// Cancels a specific notification based on the provided [id] and optional [tag].
  ///
  /// [id] is the identifier of the notification to be canceled.
  /// [tag] is an optional tag used to identify the notification.
  @override
  Future<void> cancelNotification({required int id, String? tag}) async {
    await methodChannel
        .invokeMethod<void>('cancelNotification', {'id': id, 'tag': tag});
  }

  /// Cancels all currently active notifications.
  @override
  Future<void> cancelAllNotifications() async {
    await methodChannel.invokeMethod<void>('cancelAllNotification');
  }

  /// Retrieves all currently active notifications from the native platform.
  @override
  Future<dynamic> getAllNotificcations() async {
    final data =
        await methodChannel.invokeMethod<dynamic>('getAllNotifications');
    return data;
  }

  /// Handles replying to a message notification.
  ///
  /// [payload] contains the data required to construct and display the reply notification.
  Future<void> _onReplayMsg(dynamic payload) async {
    log(payload.toString());
    try {
      String? base64Image;
      if (payload['payload']['imageUrl'] != null) {
        var imageBytes = await McCustomNotificationPlatform.instance
            .getImageFromUrl(payload['payload']['imageUrl']);
        base64Image = base64Encode(imageBytes);
      }

      Map<String, dynamic> payloadMap = Map<String, dynamic>.from(
          payload['payload'] as Map<Object?, Object?>);
      showNotificationMessage(
        model: NotificationMessage(
            id: payload['notification_id'] ?? 0,
            body: payload['payload']['msg'] ?? "",
            groupKey: payload['groupKey'] ?? "",
            payload: payloadMap,
            tag: payload['tag'],
            image: base64Image ?? "",
            title: "You ",
            useInbox: payload['useInbox'] ?? false,
            isVibration: false),
        //  imageUrl: payload['imageUrl'],
      );
    } catch (e) {
      log(e.toString());
    }
  }

  /// Handles method calls from the native platform.
  ///
  /// [call] is the method call from the native platform.
  /// [onClick], [onAccepted], [onEndCall], [onRead], [onReplay], [onMute], [onSpeaker], and [onDenied]
  /// are optional callbacks for handling specific events triggered by the notifications.
  Future<void> _handleMethod(
      {required MethodCall call,
      Function(dynamic payload)? onClick,
      Function(dynamic payload)? onAccepted,
      Function(dynamic payload)? onEndCall,
      Function(dynamic payload)? onRead,
      Function(dynamic payload)? onReplay,
      Function(dynamic payload)? onMute,
      Function(dynamic payload)? onSpeaker,
      Function()? onDenied}) async {
    switch (call.method) {
      case 'onDecline':
        onDenied!();
        break;
      case 'onAccept':
        onAccepted!(call.arguments);
        break;
      case 'onClick':
        onClick!(call.arguments);
        break;
      case 'onRead':
        onRead!(call.arguments);
        break;
      case 'onReply':
        _onReplayMsg(call.arguments);
        onReplay!(call.arguments);
        break;
      case 'onEndCall':
        onEndCall!(call.arguments);
        break;
      case 'onMic':
        onMute!(call.arguments);
        break;
      case 'onSpeaker':
        onSpeaker!(call.arguments);
        break;
      default:
        log('Unknown method ${call.method}');
    }
  }
}
