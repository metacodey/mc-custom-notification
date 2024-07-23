import 'dart:convert';

import 'package:mc_custom_notification/mc_custom_notification_platform_interface.dart';
import 'package:mc_custom_notification/models/notification.dart';
import 'package:mc_custom_notification/models/notification_call.dart';
import 'package:mc_custom_notification/models/notification_calling.dart';
import 'package:mc_custom_notification/models/notification_message.dart';

class McCustomNotification {
  void initialize({
    Function(dynamic payload)? onClick,
  }) {
    McCustomNotificationPlatform.instance.initialize(
      onClick: onClick,
    );
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
    if (model.image != null && model.image!.isNotEmpty) {
      var imageBytes = await McCustomNotificationPlatform.instance
          .getImageFromUrl(model.image!);
      String? base64Image = base64Encode(imageBytes);
      model = model.copyWith(image: base64Image);
      return McCustomNotificationPlatform.instance
          .showNotificationMessage(model: model);
    } else {
      return McCustomNotificationPlatform.instance
          .showNotificationMessage(model: model);
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
}
