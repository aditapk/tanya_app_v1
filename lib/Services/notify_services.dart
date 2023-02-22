import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:timezone/data/latest_all.dart' as tz;
//import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotifyService {
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // TODO
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        // TODO: Handle this case.
        // When click on notification
        // .notificationResponseType
        // .id
        // .actonId
        // .input
        // .payload
        print(notificationResponse.payload);

        break;
      case NotificationResponseType.selectedNotificationAction:
        // TODO: Handle this case.
        // When action on notification is clicked
        print(notificationResponse.actionId);
        print(notificationResponse.input);
        break;
    }
  }

  Future<void> inintializeNotification() async {
    tz.initializeTimeZones();
    final DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: iOSInitializationSettings,
            android: androidInitializationSettings);

    await localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      await localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? andriodImplementation =
          localNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await andriodImplementation?.requestPermission();
    }
  }

  Future<void> showNotification({
    required String channelID,
    required String channelName,
    String? channelDescription,
    required int notifyID,
    String? notifyTitle,
    String? notifyDetail,
    String? notifyPayload,
    String? notifyTicker,
    List<AndroidNotificationAction>? notifyAction,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelID, channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: notifyTicker,
            actions: notifyAction);
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // await localNotificationsPlugin.show(
    //     notifyID, notifyTitle, notifyDetail, notificationDetails,
    //     payload: notifyPayload);
    var schedule1 = tz.TZDateTime.now(tz.local).add(Duration(seconds: 5));
    var schedule2 = schedule1.add(Duration(seconds: 5));
    await localNotificationsPlugin.zonedSchedule(
      1,
      'title1',
      'body1',
      schedule1,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
    await localNotificationsPlugin.zonedSchedule(
      2,
      'title2',
      'body2',
      schedule2,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
