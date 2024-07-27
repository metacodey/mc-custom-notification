import 'package:mc_custom_notification/mc_custom_notification_method_channel.dart';
import 'package:mc_custom_notification/models/notification.dart';
import 'package:mc_custom_notification/models/notification_call.dart';
import 'package:mc_custom_notification/models/notification_calling.dart';
import 'package:mc_custom_notification/models/notification_message.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

abstract class McCustomNotificationPlatform extends PlatformInterface {
  /// Constructs a McCustomNotificationPlatform.
  McCustomNotificationPlatform() : super(token: _token);

  static final Object _token = Object();

  static McCustomNotificationPlatform _instance =
      MethodChannelMcCustomNotification();

  /// The default instance of [McCustomNotificationPlatform] to use.
  ///
  /// Defaults to [MethodChannelCostumNotificationCall].
  static McCustomNotificationPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [McCustomNotificationPlatform] when
  /// they register themselves.
  static set instance(McCustomNotificationPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void initialize({
    Function(dynamic payload)? onClick,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> showNotificationCall({required NotificationCall model}) {
    throw UnimplementedError(
        'showNotificationCall() has not been implemented.');
  }

  Future<void> showNotificationCalling({
    required NotificationCalling model,
  }) {
    throw UnimplementedError(
        'showNotificationCalling() has not been implemented.');
  }

  Future<void> showNotificationMessage(
      {required NotificationMessage model, String? imageUrl}) async {
    throw UnimplementedError(
        'showNotificationMessage() has not been implemented.');
  }

  Future<void> showNotificationNormal(
      {required NotificationModel model}) async {
    throw UnimplementedError(
        'showNotificationNormal() has not been implemented.');
  }

  Future<void> cancelAllNotifications() async {
    throw UnimplementedError(
        'cancelAllNotifications() has not been implemented.');
  }

  Future<void> cancelNotification({required int id, String? tag}) {
    throw UnimplementedError('cancelNotification() has not been implemented.');
  }

  Future<dynamic> getAllNotificcations() {
    throw UnimplementedError(
        'getAllNotificcations() has not been implemented.');
  }

  Future<Uint8List> getImageFromUrl(String imageUrl) async {
    try {
      // Fetch the image from the URL
      final response = await http.get(Uri.parse(imageUrl));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Convert the response body to Uint8List
        Uint8List bytes = response.bodyBytes;

        // Optionally, you can process the image using the 'image' package
        img.Image? image = img.decodeImage(bytes);
        if (image != null) {
          // Convert the processed image back to Uint8List
          Uint8List processedBytes = Uint8List.fromList(img.encodePng(image));
          return processedBytes;
        } else {
          throw Exception("Failed to decode image");
        }
      } else {
        throw Exception("Failed to load image");
      }
    } catch (e) {
      throw Exception("Failed to load image");
    }
  }
}
