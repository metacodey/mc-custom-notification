# MC Custom Notification
[![English](https://img.shields.io/badge/lang-English-blue)](README.md) 
[![Arabic](https://img.shields.io/badge/lang-Arabic-green)](README_AR.md) 


[pub package](https://pub.dev/packages/mc_custom_notification)


Send Notifications now Like Whatsapp And Telegram 
Custom notifications, call notifications, message notifications, calling notifications, regular notifications, Firebase notifications

## Notes

1. You should know that the library can work withou `Firebase`
2. an `Arabic` document is `Available` at this Button [![Arabic](https://img.shields.io/badge/lang-Arabic-green)](README_AR.md) 



> Please contribute to the [discussion](https://github.com/metacodey/mc-custom-notification/issues) with issues.

[<img src="https://meta-code-ye.com/mcwebsit/web/images/logo.png" width="200" />](https://meta-code-ye.com)

## screenShot


[<img src="https://meta-code-ye.com/images/image/1.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/2.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/3.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/4.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/5.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/6.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/7.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/8.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/9.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/10.jpg" width="200" style="margin-right: 10px;" />
]


## Platform support

| Feature/platform   | Android | iOS | Web              | macOS            | Windows          | Linux            |
| ------------------ | ------- | --- | ---------------- | ---------------- | ---------------- | ---------------- |
| Notification       | ✓       | ╳   | ╳                | ╳                | ╳ <sup>(1)</sup> | ╳ <sup>(1)</sup> |


## Features


1. Show incoming call notification Event to answer Event to reject
2. Notification of an ongoing call Call end event Microphone on event Call mute event
3. Notification message With InBox like Whatsapp with a reply event, a read event, and a hide event
4. Notification message with a reply event, a read event, and a hide event
5. Regular notification with notification click event
6. Cancel all notifications
7. Cancel a specific notification
8. Get all notifications
9. Sending notifications using Firebase.
10. All notices contain the title of the notice, the image of the notice, the body of the notice, the payload of the notice, the hands of the notice, and the tag of the notice
11. You can use Firebase to receive notifications in the foreground and background without Firebase notifications appearing
12. When you click on the notification, if the application is closed, it opens it, and if it is running in the background, it opens it as well.


## Installation


```sh
flutter pub add mc_custom_notification
```


## Usage


## Initializing Library


start with Initializing mc_custom_notification


```dart
import 'package:mc_custom_notification/mc_custom_notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  McCustomNotification().initialize(
    onClick: (payload) {
        //payload is detalis notification payload and tag
    // set here what you want to do when the notification is clicked
    },
  );
  runApp(const MyApp());
}

```



Here's a quick example that shows how to use a `NotificationCall` in your app



```dart
import 'package:mc_custom_notification/mc_custom_notifications.dart';

          await  McCustomNotification().showNotificationCall(
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
                    //set here what you want to do when the notification call is accepted
                    },
                    onDenied: () {
                       //set here what you want to do when the notification call is denied
                    },
        ));
```




Here's a quick example that shows how to use a `NotificationCalling` in your app




```dart
import 'package:mc_custom_notification/mc_custom_notifications.dart';

                  await McCustomNotification().showNotificationCalling(
                    model: NotificationCalling(
                      id: 52,
                      tag: 'tag18',
                      title: 'Normal notification ',
                      body: 'This is the body of the notification',
                      payload: {'id': 55, "name": "ali"},
                      groupKey: "normal53",
                      onEndCall: (payload) {
                       //set here what you want to do when the notification call is ended
                      },
                    ),
                  );

```





Here's a quick example that shows how to use a `NotificationMessageWithInBox` in your app



```dart
        import 'package:mc_custom_notification/mc_custom_notifications.dart';
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

```



Here's a quick example that shows how to use a `NotificationMessageWithOutInBox` in your app



```dart
import 'package:mc_custom_notification/mc_custom_notifications.dart';

                  await McCustomNotification().showNotificationMessage(
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
                     //set here what you want to do when the notification message is read
                    },
                    onReply: (payload) {
                     //set here what you want to do when the notification message is rplay
                    },
                  ));

```

## Firebase

 Initializing With `Firebase` 


```dart
                      McCustomNotification().initialize(
                        projectId: "id of your project in firebase",
                        serviceAccount: {}// serviceAccount from firebase you can get it from google cloude,
                        onClick: (payload) {
                          //set here event when click notifications
                        },
                      );
```


Here's a quick example that shows how to use a `Send Notification With Firebase For One` in your app



```dart
                    
                  McCustomNotification().sendNotification(
                      token: token,
                      model: NotificationModel(
                        title: "younas ali",
                        body: "hello how are you",
                        id: 150,
                        image:
                            "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                        payload: {"id": 1, "name": "younas"},
                      ));

                      

```



Here's a quick example that shows how to use a `Send Notification With Firebase For Group Of Subscribers` in your app



```dart
                
               McCustomNotification().sendNotificationToAll(
                      topics:
                          "'dogs' in topics || 'cats' in topics ||'allUsers' in topics",
                      model: NotificationModel(
                        title: "younas ali",
                        body: "hello how are you",
                        groupKey: 'normal_notification',
                        id: 150,
                        image:
                            "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                        payload: {"id": 1, "name": "younas"},
                      ));

                      

```

## To Send Notifications to Multiple Users


Create a subscription and have a group of users join the subscription


## How to Create a Subscription

Write the subscription name between single quotes followed by the keyword in topics:

```dart

'meta_code' in topics

```

How to Have Users Join the Subscription


```dart

await FirebaseMessaging.instance.subscribeToTopic('meta_code');


```


Sending Notifications to Multiple Groups



```dart

'meta' in topics || 'code' in topics || 'allUsers' in topics


```



Here's a quick example that shows how to use a `Notification With Firebase in Background` in your app



```dart

  FirebaseMessaging.onBackgroundMessage(handeleBachgroundMessage);

Future<void> handeleBachgroundMessage(RemoteMessage message) async {
  var payloadData = message.data;
  log(payloadData.toString());
  var model = NotificationModel.fromMap(payloadData);
  McCustomNotification().showNotificationMessage(
      model: NotificationMessage(
    id: 1,
    tag: message.notification?.android?.tag,
    title: model.title,
    body: model.body,
    image: model.image,
    payload: model.payload,
    onRead: (payload) {
      //set here event to read massage
    },
    onReply: (payload) {
      //set here event to replay massage
    },
  ));

```



Here's a quick example that shows how to use a `Notification With Firebase in forgrounde` in your app




```dart

  FirebaseMessaging.onMessage.listen((event) {
      final payload = event.data;

      var model = NotificationModel.fromMap(payload);
      McCustomNotification().showNotificationMessage(
          model: NotificationMessage(
        id: 1,
        tag: model.tag,
        title: model.title,
        body: model.body,
        image: model.image,
        payload: model.payload,
        onRead: (payload) {
          //set here event to read massage
        },
        onReply: (payload) {
          //set here event to replay massage
        },
      ));
    });

```



The rest of the things are explained in the example

The example works well and includes all the requirements, even the Google Cloud service keys.

## Obtaining Google Cloud Keys

The method is very simple; here’s a video explaining it:


[Video Tutorial on Obtaining Google Cloud Keys](https://www.youtube.com/watch?v=X3i9SErMGD0&t=991s)



## About us

Web site [Meta Code](https://meta-code-ye.com).

Telegram [Our business](https://t.me/metacodeye1).

Telegram [Meta Code](https://t.me/metacodeye).
