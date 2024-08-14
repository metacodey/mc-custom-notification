// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mc_custom_notification/mc_custom_notification.dart';

NotificationService notificationService = NotificationService();

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(hendleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(hendleMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final payload = event.data;
      log('payload: $payload');
      var model = NotificationModel.fromMap(payload);
      McCustomNotification().showNotificationMessage(
          model: NotificationMessage(
        id: 6,
        tag: model.tag,
        title: model.title,
        body: model.body,
        image: model.image,
        payload: model.payload,
        groupKey: model.groupKey,
        useInbox: true,
        onRead: (payload) {
          //set here event to read massage
        },
        onReply: (payload) {
          //set here event to replay massage
        },
      ));
    });
  }

  void hendleMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  Future<String> getToken() async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      final fCMToken = await FirebaseMessaging.instance.getToken();
      log('token $fCMToken');

      return fCMToken ?? "";
    } catch (e) {
      return "";
    }
  }
}

Future<void> handeleBachgroundMessage(RemoteMessage message) async {
  var payloadData = message.data;
  log(payloadData.toString());
  var model = NotificationModel.fromMap(payloadData);
  McCustomNotification().showNotificationMessage(
      model: NotificationMessage(
    id: 5,
    tag: model.tag,
    title: model.title,
    body: model.body,
    image: model.image,
    payload: model.payload,
    groupKey: model.groupKey,
    useInbox: true,
    onRead: (payload) {
      //set here event to read massage
    },
    onReply: (payload) {
      //set here event to replay massage
    },
  ));
}
