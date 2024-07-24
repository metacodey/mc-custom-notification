# MC Custom Notification

[pub package <img src="https://meta-code-ye.com/mcwebsit/web/images/logo.png" width="40" /> ](https://pub.dev/packages/mc_custom_notification)


Custom notifications, call notifications, message notifications, call notifications, regular notifications, Firebase notifications

> Please contribute to the [discussion](https://github.com/metacodey/mc-custom-notification/issues) with issues.

[<img src="https://meta-code-ye.com/mcwebsit/web/images/logo.png" width="200" />](https://meta-code-ye.com)

## screenShot
[<img src="https://meta-code-ye.com/images/image/1.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/2.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/3.jpg" width="200" style="margin-right: 10px;" />
<img src="https://meta-code-ye.com/images/image/4.jpg" width="200" style="margin-right: 10px;" />
]


## Platform support

| Feature/platform   | Android | iOS | Web              | macOS            | Windows          | Linux            |
| ------------------ | ------- | --- | ---------------- | ---------------- | ---------------- | ---------------- |
| Notification       | ✓       | ╳   | ╳                | ╳                | ╳ <sup>(1)</sup> | ╳ <sup>(1)</sup> |


1. Show incoming call notification Event to answer Event to reject
2. Notification of an ongoing call Call end event Microphone on event Call mute event
3. Notification message with a reply event, a read event, and a hide event
4. Regular notification with notification click event
5. Cancel all notifications
6. Cancel a specific notification
7. Get all notifications
8. All notices contain the title of the notice, the image of the notice, the body of the notice, the payload of the notice, the hands of the notice, and the tag of the notice
9. You can use Firebase and cancel notifications for work in the background by sending a tag to this library, and the id must be =0
10. When you click on the notification, if the application is closed, it opens it, and if it is running in the background, it opens it as well.


## Installation

```sh
flutter pub add mc_custom_notification
```

## Example


## Initialized Library
start with Initialized mc_custom_notification
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

Here's a quick example that shows how to build a `NotificationCall` in your app

```dart
import 'package:mc_custom_notification/models/notification_call.dart';

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


Here's a quick example that shows how to build a `NotificationCalling` in your app

```dart
import 'package:mc_custom_notification/models/notification_calling.dart';

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

Here's a quick example that shows how to build a `NotificationMessage` in your app

```dart
import 'package:mc_custom_notification/models/notification_message.dart';

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

The rest of the things are explained in the example

## About us

Web site [Meta Code](https://meta-code-ye.com).

Telegram [Our business](https://t.me/metacodeye1).

Telegram [Meta Code](https://t.me/metacodeye).
