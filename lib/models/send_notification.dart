import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:mc_custom_notification/models/notification.dart';

/// A service class for sending notifications via Firebase Cloud Messaging (FCM).
///
/// This class uses Firebase Authentication to obtain an access token and then sends
/// notifications to devices using the FCM HTTP v1 API.
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
  /// Throws an exception if there is an error getting the access token.
  static Future<String> _getAccessToken(
      Map<String, dynamic> serviceAccount) async {
    try {
      final client = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson(serviceAccount),
          ['https://www.googleapis.com/auth/firebase.messaging']);

      final accessToken = client.credentials.accessToken.data;
      return accessToken;
    } catch (_) {
      // Handle errors in obtaining the access token
      throw Exception('Error getting access token');
    }
  }

  /// Sends a notification to a device using Firebase Cloud Messaging (FCM).
  ///
  /// [serviceAccount] is a map containing the service account credentials in JSON format.
  /// [projectId] is the Firebase project ID.
  /// [recipientFCMToken] is the FCM token of the recipient device.
  /// [model] is an optional [NotificationModel] that contains the notification data.
  /// Returns `true` if the notification was sent successfully, otherwise `false`.
  static Future<bool> sendNotification({
    required Map<String, dynamic> serviceAccount,
    required String projectId,
    required String recipientFCMToken,
    NotificationModel? model,
  }) async {
    final String accessToken = await _getAccessToken(serviceAccount);
    print(accessToken);

    String fcmEndpoint = "https://fcm.googleapis.com/v1/projects/$projectId";
    final url = Uri.parse('$fcmEndpoint/messages:send');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // Convert the [model] to a map for the request body
    Map map = model?.toMapSend() ?? {};
    final reqBody = jsonEncode(
      {
        "message": {
          "token": recipientFCMToken,
          "data": map,
          // Optionally, add notification and platform-specific data here
          // "notification": {"body": body, "title": title},
          // "android": {
          //   "notification": {
          //     "click_action": "FLUTTER_NOTIFICATION_CLICK",
          //     "tag": "fmc-889564144",
          //   }
          // },
          "apns": {
            "payload": {
              "aps": {"category": "NEW_NOTIFICATION"}
            }
          }
        }
      },
    );

    try {
      final response = await http.post(url, headers: headers, body: reqBody);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      // Handle errors in sending the notification
      return false;
    }
  }
}
