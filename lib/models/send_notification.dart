import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:mc_custom_notification/models/notification.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  FCMService._internal();
  factory FCMService() {
    return _instance;
  }
  static Future<String> _getAccessToken(
      Map<String, dynamic> serviceAccount) async {
    try {
      final client = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson(serviceAccount),
          ['https://www.googleapis.com/auth/firebase.messaging']);

      final accessToken = client.credentials.accessToken.data;
      return accessToken;
    } catch (_) {
      //handle your error here
      throw Exception('Error getting access token');
    }
  }

// SEND NOTIFICATION TO A DEVICE
  static Future<bool> sendNotification(
      {required Map<String, dynamic> serviceAccount,
      required String projectId,
      required String recipientFCMToken,
      NotificationModel? model}) async {
    final String accessToken = await _getAccessToken(serviceAccount);
    print(accessToken);

    String fcmEndpoint = "https://fcm.googleapis.com/v1/projects/$projectId";
    final url = Uri.parse('$fcmEndpoint/messages:send');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    Map map = model?.toMapSend() ?? {};
    final reqBody = jsonEncode(
      {
        "message": {
          "token": recipientFCMToken,
          "data": map,
          // "notification": {"body": body, "title": title},
          // "android": {
          //   "notification": {
          //     "click_action": "FLUTTER_NOTIFICATION_CLICK",
          //     "tag": "fmc-889564144", //set tage to cancel notification firebase
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
      //handle your error here
      return false;
    }
  }
}
