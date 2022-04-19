import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import '../../view/shared/widgets/toast_helper.dart';

class FireNotificationHelper {
  static Future<String?> token() => FirebaseMessaging.instance.getToken();

  FireNotificationHelper() {
    FirebaseMessaging.instance.subscribeToTopic("all").catchError((err) {});

    FirebaseMessaging.onMessage
        .listen(_firebaseMessagingForegroundHandler)
        .onError((err) {});
    FirebaseMessaging.onMessageOpenedApp
        .listen(_firebaseMessagingBackgroundHandler)
        .onError((err) {});

    //   FirebaseMessaging.onBackgroundMessage(
    //       _firebaseMessagingBackgroundCloseHandler);
  }

  Future<void> _firebaseMessagingForegroundHandler(
      RemoteMessage message) async {
    redirectPage(message.data);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    redirectPage(message.data);
  }

  Future<void> redirectPage(Map<String, dynamic> data) async {
    showToast("New courses Refresh please", type: ToastType.info);
  }
}

// Future<void> _firebaseMessagingBackgroundCloseHandler(
//     RemoteMessage message) async {
// }
