import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationApi {
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static late AndroidNotificationChannel channel;
  static bool isFlutterLocalNotificationsInitialized = false;

  // static void init() {
  //   flutterLocalNotificationsPlugin.initialize(
  //     const InitializationSettings(
  //       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  //       iOS: DarwinInitializationSettings(),
  //     ),
  //   );
  // }

  static Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  static Future<void> showFlutterNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
      final notificationData = message.data;

      if (notificationData.containsKey('screen')) {
        final screen = notificationData['screen'];
        Get.toNamed(screen, arguments: notificationData);
      }
    }
  }

  // static pushNotification(
  //   RemoteMessage message,
  // ) async {
  //   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
  //     'fcm_default_channel',
  //     'Notification',
  //     channelDescription: 'Notifications channel',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: iOSPlatformChannelSpecifics,
  //   );
  //   await flutterLocalNotificationsPlugin.show(message.hashCode, message.notification!.title,
  //       message.notification!.body, platformChannelSpecifics);
  // }
}
