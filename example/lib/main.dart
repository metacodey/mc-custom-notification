import 'package:mc_custom_notification/mc_custom_notification.dart';
import 'package:mc_custom_notification/models/notification.dart';
import 'package:mc_custom_notification/models/notification_call.dart';
import 'package:mc_custom_notification/models/notification_calling.dart';
import 'package:mc_custom_notification/models/notification_message.dart';
import 'package:costum_notification_call_example/firebase_options.dart';
import 'package:costum_notification_call_example/notificationFirebase.dart';
import 'package:costum_notification_call_example/send.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  notificationService.init();
  notificationService.initializeFirebaseMessaging();
  FirebaseMessaging.onBackgroundMessage(handeleBachgroundMessage);
  McCustomNotification().initialize(
    onClick: (payload) {
      print(payload);
      print("click");
      print("---------7777777777777777777777777777777777777777777777777777");
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _testpluginPlugin = McCustomNotification();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Text('Running on: test \n'),
              ),
              ElevatedButton(
                child: const Text('Show All showNotification'),
                onPressed: () async {
                  var test = await _testpluginPlugin.getAllNotificcations();
                  Fluttertoast.showToast(
                      msg: test.toString(),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  print(test);
                },
              ),
              ElevatedButton(
                child: const Text('Show showNotification call'),
                onPressed: () async {
                  McCustomNotification().showNotificationCall(
                      model: NotificationCall(
                    id: 1,
                    tag: 'tag1',
                    title: 'New Notification',
                    body: 'This is the body of the notification',
                    image:
                        "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                    payload: {'id': 55, "name": "ali"},
                    groupKey: "call",
                    onAccepted: (payload) {
                      print(payload);
                      print("accept from class");
                      print(
                          "---------88888888888888888888888888888888888888888888888888");
                    },
                    onDenied: () {
                      print("denied from class");
                      print(
                          "---------9999999999999999999999999999999999999999999999999999999");
                    },
                  ));
                },
              ),
              ElevatedButton(
                child: const Text('Show showNotification Messsage'),
                onPressed: () async {
                  _testpluginPlugin.showNotificationMessage(
                      model: NotificationMessage(
                    id: 2,
                    tag: 'tag12',
                    title: 'Younas Ali Ahmed',
                    body: 'This is the body of the notification',
                    image:
                        "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                    payload: {'id': 55, "name": "ali"},
                    groupKey: "chat",
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
                },
              ),
              ElevatedButton(
                child: const Text('show Normal showNotification'),
                onPressed: () async {
                  await _testpluginPlugin.showNotificationNormal(
                      model: NotificationModel(
                          id: 5,
                          tag: 'tag1',
                          title: 'Normal notification ',
                          body: 'This is the body of the notification',
                          payload: {'id': 55, "name": "ali"},
                          groupKey: "normal53"));
                },
              ),
              ElevatedButton(
                child: const Text('show calling showNotification'),
                onPressed: () async {
                  await _testpluginPlugin.showNotificationCalling(
                    model: NotificationCalling(
                      id: 52,
                      tag: 'tag18',
                      title: 'Normal notification ',
                      body: 'This is the body of the notification',
                      payload: {'id': 55, "name": "ali"},
                      groupKey: "normal53",
                      onEndCall: (payload) {
                        print("onEndCall it from class");
                        print(
                            "---------9999999999999999999999999999999999999999999999999999999");
                      },
                    ),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('cancel All showNotification'),
                onPressed: () {
                  _testpluginPlugin.cancelAllNotifications();
                },
              ),
              ElevatedButton(
                child: const Text('cancel showNotification'),
                onPressed: () {
                  _testpluginPlugin.cancelNotification(id: 1, tag: "tag1");
                  _testpluginPlugin.cancelNotification(id: 2, tag: "tag12");
                },
              ),
              ElevatedButton(
                onPressed: () {
                  FCMService().sendNotification(
                      recipientFCMToken:
                          "d4fXiNycRGaMBthYK2UeXQ:APA91bFfqx15bYcPuALA8aPiwIBiCF5nJ6RxuVTz8jQRbgig7HzWb2MS1ABte6hgz8et8MBKjIGHrxWd2tE8XvJX1qmTyUZZmNuNpLiVqS94Toaryt2OgZTI7gdGAPX589wyXQO4luiG",
                      body: "test test",
                      title: "test test");
                },
                child: Text('Send Chat Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
