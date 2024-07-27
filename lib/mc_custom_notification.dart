import 'dart:convert';

import 'package:mc_custom_notification/mc_custom_notification_platform_interface.dart';
import 'package:mc_custom_notification/models/notification.dart';
import 'package:mc_custom_notification/models/notification_call.dart';
import 'package:mc_custom_notification/models/notification_calling.dart';
import 'package:mc_custom_notification/models/notification_message.dart';
import 'package:mc_custom_notification/models/preferences.dart';

import 'models/send_notification.dart';

class McCustomNotification {
  void initialize(
      {Function(dynamic payload)? onClick,
      String? projectId,
      Map<String, dynamic>? serviceAccount}) async {
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

  Future<void> showNotificationNormal(
      {required NotificationModel model}) async {
    return McCustomNotificationPlatform.instance
        .showNotificationNormal(model: model);
  }

  Future<void> cancelAllNotifications() {
    return McCustomNotificationPlatform.instance.cancelAllNotifications();
  }

  Future<void> cancelNotification({required int id, String? tag}) {
    return McCustomNotificationPlatform.instance
        .cancelNotification(id: id, tag: tag);
  }

  Future<dynamic> getAllNotificcations() {
    return McCustomNotificationPlatform.instance.getAllNotificcations();
  }

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
      print("error: you must add id Project of firebase and serviceAccount");
    }
  }
}
