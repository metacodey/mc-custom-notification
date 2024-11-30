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
  await notificationService.init();

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
                child: const Text('Show Notification call'),
                onPressed: () async {
                  await _testpluginPlugin.showNotificationCall(
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
                child: const Text('show calling Notification'),
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
                child: const Text('Notification For One User Messsages'),
                onPressed: () async {
                  for (var x = 0; x < 5; x++) {
                    await _testpluginPlugin.showNotificationMessage(
                        model: NotificationMessage(
                      useInbox: true,
                      id: 111,
                      tag: 'tag111',
                      title: 'Younas Ali Ahmed',
                      body: 'nice to meet you $x',
                      image:
                          "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                      payload: {'id': 55, "name": "ali"},
                      groupKey: "chat22",
                      isVibration: true,
                      onRead: (payload) {
                        //set here event to read massage
                      },
                      onReply: (payload) {
                        //set here event to replay massage
                      },
                    ));
                  }
                },
              ),
              ElevatedButton(
                child: const Text(
                    'Notification For One User Messsages With Replay'),
                onPressed: () async {
                  //just replay and you will see that
                  await _testpluginPlugin.showNotificationMessage(
                      model: NotificationMessage(
                    useInbox: true,
                    id: 11641,
                    tag: 'tag11441',
                    title: 'Younas Ali Ahmed',
                    body: 'nice to meet you ',
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
                child: const Text('Notification For Multi Users'),
                onPressed: () async {
                  List names = ['younas', 'ali', 'mohammed', 'ahmed', 'salh'];
                  var dis = [
                    'nice to meet you',
                    'hellow man',
                    'how are you',
                    'I need Vs code',
                    'no thanks its work'
                  ];
                  for (var x = 0; x < names.length; x++) {
                    await _testpluginPlugin.showNotificationMessage(
                        model: NotificationMessage(
                      useInbox: true,
                      id: 11 + x,
                      tag: 'tag111$x',
                      title: names[x],
                      body: dis[x],
                      // image:
                      //     "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                      payload: {'id': 55, "name": "ali"},
                      groupKey: "chat55214",

                      isVibration: true,
                      onRead: (payload) {
                        //set here event to read massage
                      },
                      onReply: (payload) {
                        //set here event to replay massage
                      },
                    ));
                  }
                },
              ),
              ElevatedButton(
                child: const Text('Show Notification  Messsage Without Inbox'),
                onPressed: () async {
                  for (var x = 0; x < 5; x++) {
                    await _testpluginPlugin.showNotificationMessage(
                        model: NotificationMessage(
                      id: x,
                      tag: 'tag12$x',
                      title: 'Younas Ali Ahmed',
                      body: 'This is the body of the notification',
                      image:
                          "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                      payload: {'id': 55, "name": "ali"},
                      groupKey: "chatattt",
                      onRead: (payload) {
                        //set here event to read massage
                      },
                      onReply: (payload) {
                        //set here event to replay massage
                      },
                    ));
                  }
                },
              ),
              ElevatedButton(
                child: const Text('show Normal Notification'),
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
                child: const Text('Send Chat Notification Message by Firebase'),
              ),
              ElevatedButton(
                onPressed: () async {
                  _testpluginPlugin.sendNotificationToAll(
                      topics:
                          "'meta' in topics || 'code' in topics ||'allUsers' in topics",
                      model: NotificationModel(
                        title: "younas ali",
                        body: "hello how are you",
                        groupKey: 'normal_notification',
                        id: 150,
                        image:
                            "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                        payload: {"id": 1, "name": "younas"},
                      ));
                },
                child: const Text('Send  Multi Notifications by Firebase'),
              ),
              ElevatedButton(
                child: const Text('Show All Notification'),
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
                child: const Text('cancel All Notification'),
                onPressed: () {
                  _testpluginPlugin.cancelAllNotifications();
                },
              ),
              ElevatedButton(
                child: const Text('cancel Notification'),
                onPressed: () {
                  _testpluginPlugin.cancelNotification(id: 555, tag: "tag55");
                  // _testpluginPlugin.cancelNotification(id: 2, tag: "tag12");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
