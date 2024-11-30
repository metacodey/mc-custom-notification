import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:mc_custom_notification/src/models/notification.dart';

/// A service class for sending notifications via Firebase Cloud Messaging (FCM).
///
/// This class provides methods for sending notifications either to a specific device or
/// to multiple devices using topics or conditions. It uses Firebase Authentication
/// to obtain an access token and then sends notifications through the FCM HTTP v1 API.
///
/// Key Features:
/// - **Send Notification to a Single Device**: Uses the recipient's FCM token to target a specific device.
/// - **Send Notification to Multiple Devices**: Supports broadcasting messages to multiple devices
///   using FCM topics or conditions.
/// - **Secure Authentication**: Authenticates using a service account to generate a secure access token.
/// - **Custom Notification Payloads**: Allows adding custom data to the notification message.
/// - **Platform-Specific Configurations**: Includes support for platform-specific properties (e.g., APNs for iOS).
///
/// Usage:
/// 1. Obtain a Firebase service account JSON file and load it as a map.
/// 2. Use the `sendNotificationToOne` method to send a notification to a single device.
/// 3. Use the `sendNotificationToAll` method to send a notification to multiple devices using topics or conditions.
class FCMService {
  // Singleton instance of [FCMService].
  static final FCMService _instance = FCMService._internal();

  FCMService._internal();

  factory FCMService() {
    return _instance;
  }

  /// Obtains an access token for Firebase Cloud Messaging (FCM) using a service account.
  ///
  /// [serviceAccount] is a map containing the service account credentials in JSON format.
  /// Returns the access token as a [String].
  /// Throws an exception if there is an error obtaining the access token.
  static Future<String> _getAccessToken(
      Map<String, dynamic> serviceAccount) async {
    try {
      final client = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson(serviceAccount),
          ['https://www.googleapis.com/auth/firebase.messaging']);

      final accessToken = client.credentials.accessToken.data;
      return accessToken;
    } catch (_) {
      throw Exception('Error getting access token');
    }
  }

  /// Sends a notification to multiple devices using a condition or topic subscription.
  ///
  /// [serviceAccount] is a map containing the service account credentials in JSON format.
  /// [projectId] is the Firebase project ID.
  /// [topics] is the condition or topic targeting string (e.g., "'dogs' in topics || 'cats' in topics").
  /// [model] is an optional [NotificationModel] containing notification details (title, body, and data).
  /// Returns `true` if the notification is sent successfully, otherwise `false`.
  static Future<bool> sendNotificationToAll({
    required Map<String, dynamic> serviceAccount,
    required String projectId,
    required String topics,
    NotificationModel? model,
  }) async {
    Map map = model?.toMapSend() ?? {};
    final reqBody = jsonEncode(
      {
        "message": {
          "condition": topics,
          "data": map,
          "apns": {
            "payload": {
              "aps": {"category": "NEW_NOTIFICATION"}
            }
          }
        }
      },
    );
    return await _sendNotification(
        projectId: projectId, reqBody: reqBody, serviceAccount: serviceAccount);
  }

  /// Sends a notification to a specific device using the recipient's FCM token.
  ///
  /// [serviceAccount] is a map containing the service account credentials in JSON format.
  /// [projectId] is the Firebase project ID.
  /// [recipientFCMToken] is the FCM token of the recipient device.
  /// [model] is an optional [NotificationModel] containing notification details (title, body, and data).
  /// Returns `true` if the notification is sent successfully, otherwise `false`.
  static Future<bool> sendNotificationToOne({
    required Map<String, dynamic> serviceAccount,
    required String projectId,
    required String recipientFCMToken,
    NotificationModel? model,
  }) async {
    Map map = model?.toMapSend() ?? {};
    final reqBody = jsonEncode(
      {
        "message": {
          "token": recipientFCMToken,
          "data": map,
          "apns": {
            "payload": {
              "aps": {"category": "NEW_NOTIFICATION"}
            }
          }
        }
      },
    );
    return await _sendNotification(
        projectId: projectId, reqBody: reqBody, serviceAccount: serviceAccount);
  }

  /// Helper method for sending a notification.
  ///
  /// [serviceAccount] is a map containing the service account credentials in JSON format.
  /// [projectId] is the Firebase project ID.
  /// [reqBody] is the JSON-encoded request body for the FCM API.
  /// Returns `true` if the notification is sent successfully, otherwise `false`.
  static Future<bool> _sendNotification({
    required Map<String, dynamic> serviceAccount,
    required String projectId,
    required String reqBody,
  }) async {
    final String accessToken = await _getAccessToken(serviceAccount);

    String fcmEndpoint = "https://fcm.googleapis.com/v1/projects/$projectId";
    final url = Uri.parse('$fcmEndpoint/messages:send');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.post(url, headers: headers, body: reqBody);
      log(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
