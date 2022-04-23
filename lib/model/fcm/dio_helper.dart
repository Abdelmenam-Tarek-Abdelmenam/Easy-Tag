import 'package:dio/dio.dart';

const String _fcmKey =
    "AAAAfv9fgQs:APA91bGXFhmp0B9-Rb12Laeo9Ol7JV7QzprIwwKupKF0ISHeJqGS_pC9PnRIXMtg9BXmiDmyIMr48A-xhtAIatsfATFsTihoObRMMwCGQnGrKT_NRraSEUGx1Q70F0D5qsjhfNPZwqal";

class NotificationSender {
  late Dio dio;

  NotificationSender() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://fcm.googleapis.com/fcm/',
      receiveDataWhenStatusError: true,
      connectTimeout: 50000,
      sendTimeout: 50000,
      validateStatus: (status) {
        return status! < 500;
      },
    ));
  }

  Future<Response> postData({
    String path = 'send',
    // required Map<String, String> sendData,
    required String title,
    required String body,
    // required String receiverUId,
  }) async {
    // sendData = sendData.map((key, value) {
    //   return MapEntry('"$key"', '"$value"');
    // });
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_fcmKey',
    };

    Map<String, dynamic> data = {
      // "data": {},
      "to": "/topics/all",
      "notification": {"title": title, "body": body, "sound": "default"},
      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": true,
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      }
    };

    return await dio.post(path, data: data).catchError((err) {
      print(err.type);
    });
  }
}
