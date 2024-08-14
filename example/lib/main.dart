import 'dart:convert';
import 'package:mc_custom_notification/mc_custom_notification.dart';
import 'package:costum_notification_call_example/firebase_options.dart';
import 'package:costum_notification_call_example/notification_firebase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  notificationService.init();

  FirebaseMessaging.onBackgroundMessage(handeleBachgroundMessage);
  var map = jsonDecode(dotenv.env['ACCOUNT_SERVICES'] ?? '');
  McCustomNotification().initialize(
    projectId: "test-notification-f021c",
    serviceAccount: map,
    onClick: (payload) {
      //set here event when click notifications
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
                      //set event when answer
                    },
                    onDenied: () {
                      //set event when denied
                    },
                  ));
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
                          //set here event to end call
                        },
                        onMute: (payload) {
                          //set here event to click mute
                        },
                        onSpeaker: (payload) {
                          //set here event to click onSpeaker
                        }),
                  );
                },
              ),
              ElevatedButton(
                child: const Text('Show showNotification Messsage'),
                onPressed: () async {
                  await _testpluginPlugin.showNotificationMessage(
                      model: NotificationMessage(
                    useInbox: true,
                    id: 555,
                    tag: 'tag555',
                    title: 'Younas Ali Ahmed',
                    body: 'This is the body of the notification',
                    image:
                        "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                    payload: {'id': 55, "name": "ali"},
                    groupKey: "chat",
                    isVibration: true,
                    onRead: (payload) {
                      //set here event to read massage
                    },
                    onReply: (payload) {
                      //set here event to replay massage
                    },
                  ));
                  await _testpluginPlugin.showNotificationMessage(
                      model: NotificationMessage(
                    useInbox: true,
                    id: 555,
                    tag: 'tag555',
                    title: 'Mohmmed Mohmmed',
                    body: 'This is the body of the notification',
                    image:
                        "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                    payload: {'id': 55, "name": "ali"},
                    groupKey: "chat",
                    isVibration: true,
                    onRead: (payload) {
                      //set here event to read massage
                    },
                    onReply: (payload) {
                      //set here event to replay massage
                    },
                  ));
                  await _testpluginPlugin.showNotificationMessage(
                      model: NotificationMessage(
                    useInbox: true,
                    id: 555,
                    tag: 'tag555',
                    title: 'Salh Salh',
                    body: 'This is the body of the notification',
                    image:
                        "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                    payload: {'id': 55, "name": "ali"},
                    groupKey: "chat",
                    isVibration: true,
                    onRead: (payload) {
                      //set here event to read massage
                    },
                    onReply: (payload) {
                      //set here event to replay massage
                    },
                  ));
                },
              ),
              ElevatedButton(
                child:
                    const Text('Show showNotification  Messsage Without Inbox'),
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
                      //set here event to read massage
                    },
                    onReply: (payload) {
                      //set here event to replay massage
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
                onPressed: () async {
                  var token = await notificationService.getToken();
                  _testpluginPlugin.sendNotification(
                      token: token,
                      model: NotificationModel(
                        title: "younas ali",
                        body: "hello how are you",
                        id: 150,
                        image:
                            "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                        payload: {"id": 1, "name": "younas"},
                      ));
                },
                child: const Text('Send Chat Message'),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     _sendChatMessage('hello man', 'younas ali', 13, 'chat1');
              //   },
              //   child: const Text('group Chat Message'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
