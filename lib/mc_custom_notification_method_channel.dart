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
      (call) => _handleMethod(call: call, onEndCall: model.onEndCall),
    );
  }

  @override
  Future<void> showNotificationMessage(
      {required NotificationMessage model}) async {
    await methodChannelMessage.invokeMethod<void>(
        'showNotificationMessage', model.toMap());
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

  Future<void> _handleMethod(
      {required MethodCall call,
      Function(dynamic payload)? onClick,
      Function(dynamic payload)? onAccepted,
      Function(dynamic payload)? onEndCall,
      Function(dynamic payload)? onRead,
      Function(dynamic payload)? onReplay,
      Function()? onDenied}) async {
    switch (call.method) {
      case 'onDecline':
        onDenied!();
      case 'onAccept':
        onAccepted!(call.arguments);
      case 'onClick':
        onClick!(call.arguments);
      case 'onRead':
        onRead!(call.arguments);
      case 'onReply':
        onReplay!(call.arguments);

      case 'onEndCall':
        onEndCall!(call.arguments);
        break;

      default:
        print('Unknown method ${call.method}');
    }
  }
}
