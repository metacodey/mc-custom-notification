import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FCMService {
//get the access token with the .json file downloaded from google cloud console
  Future<String> _getAccessToken() async {
    try {
      //the scope url for the firebase messaging
      String firebaseMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      //get the service account from the environment variables or from the .env file where it has been stored.
      //it is advised not to hardcode the service account details in the code
      Map<String, dynamic> serviceAccount = {
        "type": "service_account",
        "project_id": "test-notification-f021c",
        "private_key_id": "eefbdb3a00a21f37952d60ab39798f50899dc2d2",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDAag6KGkd6lkFg\nFgABlqv54GzVJxxlaOmgQju+Dzd6haEP5b+TJYbpUCM/k8kpBKI67Xm8eWXXJmWn\n61N6r6YysnlpmEUs5tTu+5HyoLM8RbNzI43dz7zA8GrdYeHajDbPOkefL4txYVlQ\nCvukR9EONX7Zw3gEO5Mssg97L7AMQymksEy2NI3uQvWjmUyumqQ36emJ1heUGqTO\n1GVxTu/LiKjGJiPzP71pLVJKbwMJuOcHWA57N24nWl3MlR9pnQ5puYOsRnRUJEKL\nJRyTSN6hzQry2wtvJiFpB1FTsdUz2HiH8rxPGiRaef88DurfIAPQ6gunDhjDejNo\n7oNtf7YjAgMBAAECggEAIKlAC5A3ZucfdMR3Ps3JJnLCdpIbf1lGIvZrNrFVjP4m\n31Bz6vHZSzxXp2CaKlTHhvItkmEW+OTjJ5RKCM7NCtkBw/tdbqhGJ8TbOtCtbAM2\n2UoFOEwdcbC9qxOE53iaiyWM58gFxvqr0uryWSn5ogxRmnxUIH/OVS1qdFIdc48d\nh+6IrwE9Itbif3IfENpZM+QwqJ028nW1mDuDGcKrJrFkJNEFmt52HlGnLa5JCi70\nR7mXqszsIoGpzDQjj28WdzyTdDqrOLxVMMTi+kiLmDyqzuukimnLno7PXgVY/3JE\nILcVaoWDZknxnrI7A6DJjtNBmzG8CMkMcFirscRNIQKBgQDq59Z2TY50LkwLKgfS\nv4TLlWsLG8/S0OfSQdkHdgBh06urPL6uX6B9D+ia8E8bdAvEMdoB7B6O+BhhGX05\nzZ8Re5oJLfRBPieMnFeeidRscUItPL/LU/q1amWdrbkWcK2G4sPIJd+FQ9+ib9To\n8Hjv3TlStsBpuO5xrTOOg66BwwKBgQDRsWacyQDEBA6uCXv4mBPySbSIRr7WTLF4\nIBXbqx1JjlEFodzEIazf+naPlEQWGs1sUcvMaiwCDMFpGhkEuGLIuCiBpKsQBHNX\nM1HpJ7cpU4bNqITR8fJogArzOT7IVxiXBfrLHcJNuLGJtui/EsZkswqn7BiLDK8k\n/NdLnQ9UIQKBgQCSke3jCyljnK+eF6+h9BYr4SNVXxkhdW/wZV3BpgM/BxAKXHCt\n5MUCw7ZjVqZFfvcIiAJ7SJUYp/yuOXVFZ+NkyTanm6DYRKvwtGyHY4DD2TdteoZB\nnDjGkYiuBgOC2POtQjje3aLGSD9130l9vu323JYz4gvU66r8CxIsTkXIeQKBgCD8\nG90LzUAIN1rvCP44xeJ1750EK96/36a6vVV5nDjG1z3gkT6U4YG1/1JkizVC8A9a\n6oj0JooIAaCLx2Wzr25Ncam7AmGZoZ8U5oybf7dTeT/+gy4XNf90LMTHu3V+JdMT\n0LiErNzW8a5tBD2SMX0DoOh7Pf0ZeK+DykYNpayhAoGAHZOic79E09Zy7c40Xgxr\n4ZvbvsTacM8DhvJrEiA8o1qTDQR0ekmyWcZE+x/fWhjhC9BLfG3jB2KtmqbO4Pf5\nMS4JfhdjyMltn570itUT3HI6nafIBfWA/fQvn9GHGmpcHdiwG4AvRR6jRo8LpCEC\n+/MwkPa2dxZSskVqHGir5X0=\n-----END PRIVATE KEY-----\n",
        "client_email":
            "test-notification@test-notification-f021c.iam.gserviceaccount.com",
        "client_id": "104187923604745528979",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/test-notification%40test-notification-f021c.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      };

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
  Future<bool> sendNotification(
      {required String recipientFCMToken,
      required String title,
      required String body}) async {
    final String accessToken = await _getAccessToken();
    //Input the project_id value in the .json file downloaded from the google cloud console
    const String projectId = 'test-notification-f021c';
    const String fcmEndpoint =
        "https://fcm.googleapis.com/v1/projects/$projectId";
    final url = Uri.parse('$fcmEndpoint/messages:send');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final reqBody = jsonEncode(
      {
        "message": {
          "token": recipientFCMToken,
          "notification": {"body": body, "title": title},
          "android": {
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "tag": "fmc-889564144", //set tage to cancel notification firebase
            }
          },
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
