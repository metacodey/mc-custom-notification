# MC Custom Notification

[pub package](https://pub.dev/packages/mc_custom_notification)


أرسل الأن اشعارات مثل أشعارات واتساب 

أشعارات مخصصة أشعارات مكالمة واردة أشعارات رسائل أشعارات اتصال أشعارات عادية أشعارات فايربيس أشعارات 



## ملاحظات

1. يجب ان تعرف ان المكتبة تستطيع العمل بدون فايربيس 



> يرجى المساهمة في  .Please contribute to the [المناقشة](https://github.com/metacodey/mc-custom-notification/issues) بالقضايا.

[<img src="https://meta-code-ye.com/mcwebsit/web/images/logo.png" width="200" />](https://meta-code-ye.com)

## لقطات الشاشة


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


## النصات المدعومة

| الميزة/المنصة | Android | iOS | Web              | macOS            | Windows          | Linux            |
| ------------------ | ------- | --- | ---------------- | ---------------- | ---------------- | ---------------- |
| Notification       | ✓       | ╳   | ╳                | ╳                | ╳ <sup>(1)</sup> | ╳ <sup>(1)</sup> |


## المميزات


1. أشعار مكالمة واردة مع حدث أجابة وحدث رفض
2. أشعار مكالمة جارية مع حدث انهاء وحدث اغلاق المايكروفون وحدث كت المكالمة
3. أشعار رساله في صندوق مثل واتساب مع حدث الرد وحدث اخفاء وحدث قرائه
4. أشعار رساله مع حدث الرد وحدث اخفاء وحدث قرائه
5. إشعار عادي مع حدث النقر على الإشعار
6. الغاء جميع الاشعارات
7. الغاء اشعار محدد
8. الحصول على جميع الاشعارات
9. أرسال الاشعارات باستخدام فايربيس
10. تحتوي جميع الإشعارات على عنوان الإشعار، وصورة الإشعار، ونص الإشعار، وحمولة الإشعار، وأيادي الإشعار، وعلامة الإشعار
11. يمكنك استخدام Firebase لتلقي الإشعارات في المقدمة والخلفية دون ظهور إشعارات Firebase
12. عند الضغط على الإشعار، إذا كان التطبيق مغلقًا، فإنه يفتحه، وإذا كان يعمل في الخلفية، فإنه يفتحه أيضًا.


## التثبيت


```sh
flutter pub add mc_custom_notification
```


## الأستخدام


## تهيئة المكتبة


ابداء مع تهيئة المكتبة mc_custom_notification


```dart
import 'package:mc_custom_notification/mc_custom_notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  McCustomNotification().initialize(
    onClick: (payload) {
        //هنا حدث عندما يتم فتح التطبيق
    // set here what you want to do when the notification is clicked
    },
  );
  runApp(const MyApp());
}

```



هذا مثال بسيط لعرض  `أشعار مكالمة واردة` في تطبيقك



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
                    //ضع هنا حدث الاجابة
                    },
                    onDenied: () {
                       //ضع هنا حدث الرفض
                    },
        ));
```




هذا مثال بسيط لعرض  `أشعار مكالمة جارية` في تطبيقك





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





هذا مثال بسيط لعرض  `أشعار  رسائل الصندوق `  في تطبيقك مثل واتساب




```dart
import 'package:mc_custom_notification/mc_custom_notifications.dart';

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



هذا مثال بسيط لعرض  `أشعار  رساله` في تطبيقك




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

أبداء نيئة المكتبة مع `فايربيس`

```dart
                      McCustomNotification().initialize(
                        projectId: "id of your project in firebase",
                        serviceAccount: {}// serviceAccount from firebase you can get it from google cloude,
                        onClick: (payload) {
                          //set here event when click notifications
                        },
                      );
```



هذا مثال بسيط يوضح كيف يمكنك  `ارسال الاشعار عبر فايربيس لشخص واحد` في تطبيق




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



هذا مثال بسيط يوضح كيف يمكنك  `ارسال الاشعار عبر فايربيس لعدة أشخاص ` في تطبيق



```dart

                  McCustomNotification().sendNotification(
                      topics:
                          "'dogs' in topics || 'cats' in topics ||'allUsers' in topics",
                      model: NotificationModel(
                        title: "younas ali",
                        body: "hello how are you",
                        id: 150,
                        image:
                            "https://vpsserver.meta-code-ye.com/files/image?name=IMG-20240314-WA0007.jpg",
                        payload: {"id": 1, "name": "younas"},
                      ));

                      
```


## حتى تستطيع أرسال الأشعارات لعدة أشخاص 

أنشاء أشتراك وجعل مجموعة من المستخدمين الأنضام الى الأشتراك 

طريقة أنشاء اشتراك  

اكتب أسم الأشتراك بين 'أشتراك' متبوعا بكلمة in topics 

```dart

    'meta_code' in topics 

```

طريقة جعل المستخدمين ينضمون الى الأشتراك 


```dart

    await FirebaseMessaging.instance.subscribeToTopic('meta_code');

```


يمكنك أرسال الأشعار الى عدة مجموعات وتصاغ بهذا الشكل 



```dart

      'meta' in topics || 'code' in topics ||'allUsers' in topics

```




هذا مثال بسيط يوضح كيف يمكنك  `تلقي الاشعار عبر فايربيس` في تطبيقك والعمل في الخلفية



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



هذا مثال بسيط يوضح كيف يمكنك  `تلقي الاشعار عبر فايربيس` في تطبيقك والعمل في المقدمة




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



باقي الاشياء مذكورة في المثال 
المثال يعمل بشكل جيد وفيه كل المتطلبات حتى مفاتيح خدمة جوجل كلاود 

# الحصول على مفاتيح جوجل كلاود


الطريقة سهله جدا هذا فيديو يشرح ذلك


[ فيديو شرح الحصول على مفاتيح جوجل كلاود](https://www.youtube.com/watch?v=X3i9SErMGD0&t=991s)




## من نحن

موقنا  [Meta Code](https://meta-code-ye.com).

تيلجرام [Our business](https://t.me/metacodeye1).

تيلجرام [Meta Code](https://t.me/metacodeye).
