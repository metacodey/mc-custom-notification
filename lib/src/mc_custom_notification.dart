import 'dart:convert';
import 'dart:developer';

import 'package:mc_custom_notification/src/mc_custom_notification_platform_interface.dart';
import 'package:mc_custom_notification/src/models/notification.dart';
import 'package:mc_custom_notification/src/models/notification_call.dart';
import 'package:mc_custom_notification/src/models/notification_calling.dart';
import 'package:mc_custom_notification/src/models/notification_message.dart';
import 'package:mc_custom_notification/src/models/preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/send_notification.dart';

/// [McCustomNotification] class is responsible for managing and executing
/// various types of notifications within the application.
class McCustomNotification {
  /// Initializes the notification system.
  ///
  /// [onClick] is a callback function that gets triggered when the notification is clicked.
  /// [projectId] is the project identifier.
  /// [serviceAccount] is the service account information used for notifications.
  void initialize({
    Function(dynamic payload)? onClick,
    String? projectId,
    Map<String, dynamic>? serviceAccount,
  }) async {
    _premission();
    McCustomNotificationPlatform.instance.initialize(
      onClick: onClick,
    );
    await Preferences.initPref();
    if (projectId != null) {
      Preferences.setString(Preferences.projectId, projectId);
    }
    if (serviceAccount != null) {
      Preferences.setString(
          Preferences.serviceAccount, jsonEncode(serviceAccount));
    }
  }

  /// Displays a notification of type [NotificationCall].
  ///
  /// [model] contains the details of the call notification to be displayed.
  Future<void> showNotificationCall({required NotificationCall model}) async {
    if (model.image != null && model.image!.isNotEmpty) {
      var imageBytes = await McCustomNotificationPlatform.instance
          .getImageFromUrl(model.image!);
      String? base64Image = base64Encode(imageBytes);
      model = model.copyWith(image: base64Image);
      return McCustomNotificationPlatform.instance
          .showNotificationCall(model: model);
    } else {
      return McCustomNotificationPlatform.instance
          .showNotificationCall(model: model);
    }
  }

  /// Displays a notification of type [NotificationCalling].
  ///
  /// [model] contains the details of the calling notification to be displayed.
  Future<void> showNotificationCalling(
      {required NotificationCalling model}) async {
    if (model.image != null && model.image!.isNotEmpty) {
      var imageBytes = await McCustomNotificationPlatform.instance
          .getImageFromUrl(model.image!);
      String? base64Image = base64Encode(imageBytes);
      model = model.copyWith(image: base64Image);
      return McCustomNotificationPlatform.instance.showNotificationCalling(
        model: model,
      );
    } else {
      return McCustomNotificationPlatform.instance
          .showNotificationCalling(model: model);
    }
  }

  /// Displays a notification of type [NotificationMessage].
  ///
  /// [model] contains the details of the message notification to be displayed.
  Future<void> showNotificationMessage(
      {required NotificationMessage model}) async {
    var imageUrl = model.image;

    if (model.image != null && model.image!.isNotEmpty) {
      var imageBytes = await McCustomNotificationPlatform.instance
          .getImageFromUrl(model.image!);
      String? base64Image = base64Encode(imageBytes);
      model = model.copyWith(image: base64Image);
      return McCustomNotificationPlatform.instance
          .showNotificationMessage(model: model, imageUrl: imageUrl);
    } else {
      return McCustomNotificationPlatform.instance
          .showNotificationMessage(model: model, imageUrl: imageUrl);
    }
  }

  /// Displays a normal notification using the provided [NotificationModel].
  ///
  /// [model] contains the details of the normal notification to be displayed.
  Future<void> showNotificationNormal(
      {required NotificationModel model}) async {
    return McCustomNotificationPlatform.instance
        .showNotificationNormal(model: model);
  }

  /// Cancels all currently displayed notifications.
  Future<void> cancelAllNotifications() {
    return McCustomNotificationPlatform.instance.cancelAllNotifications();
  }

  /// Cancels a specific notification based on [id] and optional [tag].
  ///
  /// [id] is the identifier of the notification to be canceled.
  /// [tag] is an optional tag used to identify the notification.
  Future<void> cancelNotification({required int id, String? tag}) {
    return McCustomNotificationPlatform.instance
        .cancelNotification(id: id, tag: tag);
  }

  /// Retrieves all currently active notifications.
  Future<dynamic> getAllNotificcations() {
    return McCustomNotificationPlatform.instance.getAllNotificcations();
  }

  /// Sends a notification to a specific device using Firebase Cloud Messaging (FCM).
  ///
  /// [token] is the FCM token of the recipient device.
  /// [model] contains the details of the notification to be sent.
  Future<void> sendNotification(
      {required String token, NotificationModel? model}) async {
    final projectId = Preferences.getString(Preferences.projectId);
    final serviceAccount = Preferences.getString(Preferences.serviceAccount);
    if (projectId.isNotEmpty && serviceAccount.isNotEmpty) {
      FCMService.sendNotification(
          serviceAccount: jsonDecode(serviceAccount),
          projectId: projectId,
          recipientFCMToken: token,
          model: model);
    } else {
      log("Error: You must add a Firebase project ID and service account.");
    }
  }

  /// Requests necessary permissions for displaying notifications.
  Future<void> _premission() async {
    await Permission.notification.request();
    await Permission.accessNotificationPolicy.request();
  }
}
