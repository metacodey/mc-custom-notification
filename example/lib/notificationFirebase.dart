// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:mc_custom_notification/mc_custom_notification.dart';
import 'package:mc_custom_notification/models/notification.dart';
import 'package:mc_custom_notification/models/notification_call.dart';
import 'package:costum_notification_call_example/androidNotificatonDetails.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mc_custom_notification/models/notification_message.dart';
import 'package:timezone/data/latest.dart' as tz;

NotificationService notificationService = NotificationService();

class NotificationService {
  int i = 0;
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = 'your_channel_id';
  static const channelName = 'your_channel_name';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    initPushNotification();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // await platform?.createNotificationChannel(androidNotificationChannel);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponse,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(hendleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(hendleMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) return;
      McCustomNotification().showNotificationMessage(
          model: NotificationMessage(
        id: notification.android.hashCode,
        body: notification.body,
        title: notification.title,
        payload: event.toMap(),
        tag: notification.android?.tag,
        onRead: (payload) {
          print("read it from class");
          print(
              "---------9999999999999999999999999999999999999999999999999999999");
        },
        onReply: (payload) {
          print("replay it from class");
          print(
              "---------9999999999999999999999999999999999999999999999999999999");
        },
      ));
      // showForegroundNotifications(
      //     notification.title!, notification.body!, jsonEncode(event.toMap()));
    });
  }

  void hendleMessage(RemoteMessage? message) {
    if (message == null) return;

    print(
        "-----------------------------------------------------------333333333333333333333");
    print('----------------------------------------------------------4');
    print('----------------------------------------------------------6');
    print('----------------------------------------------------------8');
    print('----------------------------------------------------------7');
    print('----------------------------------------------------------6');
    print('----------------------------------------------------------5');
    // novigatorKey.currentState?.pushNamed(HomeScreen.route, arguments: message);
  }

  Future<void> showNotifications(
      String? title, String? body, String payload) async {
    await flutterLocalNotificationsPlugin.show(
      i++,
      title,
      body,
      payload: payload,
      NotificationDetails(android: androidNotificationDetails),
    );
  }

  Future<void> showForegroundNotifications(
      String? title, String? body, String payload) async {
    await flutterLocalNotificationsPlugin.show(
      i++,
      title,
      body,
      payload: payload,
      NotificationDetails(android: androidNotificationDetails),
    );
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<String> initializeFirebaseMessaging() async {
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
      print('token $fCMToken');
      print('----------------------------------------------------------2');

      return fCMToken ?? "";
    } catch (e) {
      return "";
    }
  }
}

void onDidReceiveNotificationResponse(NotificationResponse details) async {
  print(
      "-----------------------------------------------------------2222222222222");
}

Future<void> handeleBachgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.threadId}');
  print('tag: ${message.notification?.android?.toMap()}');
  print('senderId: ${message.senderId}');
  print('messageId: ${message.messageId}');
  log(message.toMap().toString());

//set tag in notification to cancel notification firebase
  McCustomNotification().showNotificationMessage(
      model: NotificationMessage(
    id: 0,
    tag: message.notification?.android?.tag,
    title: 'New Notification',
    body: 'This is the body of the notification',
    payload: {'id': 55, "name": "ali"},
    onRead: (payload) {
      print("read it from class");
      print("---------9999999999999999999999999999999999999999999999999999999");
    },
    onReply: (payload) {
      print("replay it from class");
      print("---------9999999999999999999999999999999999999999999999999999999");
    },
  ));
}
