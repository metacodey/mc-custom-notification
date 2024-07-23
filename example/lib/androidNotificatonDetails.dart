import 'dart:typed_data';

import 'package:costum_notification_call_example/notificationFirebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var androidPlatformChannelWithCall = const AndroidNotificationDetails(
    'your channel id', 'your channel name',
    channelDescription: 'color background channel description',
    color: Colors.greenAccent,
    colorized: true,
    actions: [
      AndroidNotificationAction(
        showsUserInterface: true,
        'end_call',
        titleColor: Colors.red,
        'End Call',
        cancelNotification: true,
        icon: DrawableResourceAndroidBitmap('end_call'),
      )
    ]);

var androidNotificationDetails = AndroidNotificationDetails(
  NotificationService.channelId,
  NotificationService.channelName,
  channelDescription: "channel description",
  importance: Importance.high,
  priority: Priority.max,
  category: AndroidNotificationCategory.message,
  groupAlertBehavior: GroupAlertBehavior.all,
  playSound: true,
  autoCancel: true,
  visibility: NotificationVisibility.public,
  vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
  enableVibration: true,
);
