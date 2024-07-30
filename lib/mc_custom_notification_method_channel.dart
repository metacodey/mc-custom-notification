import 'dart:convert';
import 'package:mc_custom_notification/mc_custom_notification_platform_interface.dart';
import 'package:mc_custom_notification/models/notification.dart';
import 'package:mc_custom_notification/models/notification_call.dart';
import 'package:mc_custom_notification/models/notification_calling.dart';
import 'package:mc_custom_notification/models/notification_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// An implementation of [McCustomNotificationPlatform] that uses method channels.
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

  @override
  Future<void> showNotificationCall({required NotificationCall model}) async {
    await methodChannelCall.invokeMethod<void>(
        'showNotificationCall', model.toMap());
    methodChannelCall.setMethodCallHandler(
      (call) => _handleMethod(
          call: call, onAccepted: model.onAccepted, onDenied: model.onDenied),
    );
  }

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

  @override
  Future<void> showNotificationNormal(
      {required NotificationModel model}) async {
    await methodChannel.invokeMethod<void>(
        'showNotificationNormal', model.toMap());
  }

  @override
  Future<void> cancelNotification({required int id, String? tag}) async {
    await methodChannel
        .invokeMethod<void>('cancelNotification', {'id': id, 'tag': tag});
  }

  @override
  Future<void> cancelAllNotifications() async {
    await methodChannel.invokeMethod<void>('cancelAllNotification');
  }

  @override
  Future<dynamic> getAllNotificcations() async {
    final data =
        await methodChannel.invokeMethod<dynamic>('getAllNotifications');
    return data;
  }

  Future<void> _onReplayMsg(dynamic payload) async {
    try {
      String? base64Image;
      if (payload['payload'].toString().contains("imageUrl")) {
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
            tag: payload['tag'] ?? "",
            image: base64Image ?? "",
            title: payload['title'] ?? "",
            useInbox: payload['useInbox'] ?? false,
            isVibration: false),
        imageUrl: payload['imageUrl'],
      );
    } catch (e) {
      print(e);
    }
  }

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
        print('Unknown method ${call.method}');
    }
  }
}
