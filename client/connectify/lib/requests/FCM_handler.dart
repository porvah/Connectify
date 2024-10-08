import 'package:firebase_messaging/firebase_messaging.dart';


class NotificationService{
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static Future<void> _backgroundHandler(RemoteMessage message)async {
    print(message.data);
  }

  static Future<void> _foregroundHandler(RemoteMessage message)async{
    print(message.data);
  }
  static Future<void> initialize()async{
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_foregroundHandler);
  }
  static Future<void> getToken() async{
    await _firebaseMessaging.requestPermission();
    String? device_token = await _firebaseMessaging.getAPNSToken();
    print("FCM token = $device_token");
  }
}