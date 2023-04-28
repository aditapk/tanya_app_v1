import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fraction/fraction.dart';
//import 'package:timezone/data/latest_all.dart' as tz;
//import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotifyService {
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> inintializeNotification({
    required onDidReceiveNotificationIOS,
    required onDidReceiveNotificationAndroid,
  }) async {
    tz.initializeTimeZones();
    List<DarwinNotificationCategory> iosNotificationCategories =
        const <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        'default',
        // actions: <DarwinNotificationAction>[
        //   DarwinNotificationAction.text(
        //     'OK',
        //     'ตกลง',
        //     buttonTitle: 'ตกลง',
        //   ),
        //   DarwinNotificationAction.text(
        //     'PENDING',
        //     'เลื่อนไปก่อน',
        //     buttonTitle: 'เลื่อนไปก่อน',
        //   ),
        // ],
      ),
      DarwinNotificationCategory(
        'Doctor Appointment',
        // actions: <DarwinNotificationAction>[
        //   DarwinNotificationAction.plain(
        //     'OK',
        //     'ตกลง',
        //   ),
        //   DarwinNotificationAction.plain(
        //     'PENDING',
        //     'เตือนอีกครั้ง',
        //   ),
        // ],
      ),
    ];
    final DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: onDidReceiveNotificationIOS,
      notificationCategories: iosNotificationCategories,
    );

    // const AndroidInitializationSettings androidInitializationSettings =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: iOSInitializationSettings,
            android: androidInitializationSettings);

    await localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationAndroid);
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

  Future<void> scheduleNotify({
    required String channelID,
    required String channelName,
    String? channelDescription,
    required int notifyID,
    String? notifyTitle,
    String? notifyDetail,
    String? notifyPayload,
    String? notifyTicker,
    required DateTime scheduleTime,
    required int notifyId,
    List<AndroidNotificationAction>? notifyAction,
    required String imagePath,
  }) async {
    var notifyData = jsonDecode(notifyPayload!);
    var medicineInfo = notifyData["notifyInfo"]["medicineInfo"];
    var name = medicineInfo["name"];
    var type = medicineInfo["type"];
    var unit = medicineInfo["unit"];
    double nTake = medicineInfo["nTake"];
    var order = medicineInfo["order"];

    String nTakeStr;

    // check is intisInt(double num) {
    if (nTake % 1 == 0) {
      nTakeStr = nTake.toInt().toString();
    } else {
      nTakeStr = Fraction.fromDouble(nTake).toString();
    }

    var howToEat = "<type> $nTakeStr $unit";
    switch (type) {
      case "pills":
        howToEat = howToEat.replaceAll('<type>', "รับประทาน");
        break;
    }
    var orderInThai = "";
    switch (order) {
      case "before":
        orderInThai = "ก่อนอาหาร";
        break;
      case "after":
        orderInThai = "หลังอาหาร";
        break;
    }
    final contentTitle = "<b>$name<b>";
    final summaryText = "$howToEat<br>$orderInThai";

    // big picture
    BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(imagePath),
      largeIcon: FilePathAndroidBitmap(imagePath),
      contentTitle: contentTitle,
      htmlFormatContentTitle: true,
      summaryText: summaryText,
      htmlFormatSummaryText: true,
      hideExpandedLargeIcon: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channelID, channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: notifyTicker,
            actions: notifyAction,
            styleInformation: bigPictureStyleInformation);

    // check file is exist
    DarwinNotificationDetails? iosNotificationDetails =
        const DarwinNotificationDetails(
      categoryIdentifier: 'default',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    // await localNotificationsPlugin.show(
    //     notifyID, notifyTitle, notifyDetail, notificationDetails,
    //     payload: notifyPayload);
    var schedule1 = tz.TZDateTime.from(scheduleTime, tz.local);
    // var schedule2 = schedule1.add(Duration(seconds: 5));
    await localNotificationsPlugin.zonedSchedule(
      notifyId,
      notifyTitle,
      notifyDetail,
      schedule1,
      notificationDetails,
      payload: notifyPayload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> scheduleDoctorAppointmentNotify({
    required int notifyID,
    required DateTime notifyDate,
    String? title,
    String? detail,
    String? payload,
    List<AndroidNotificationAction>? actions,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'Doctor Appointment ID',
      'Doctor Appointment',
      channelDescription: 'Notify channel for Doctor Appointment',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'notifyTicker',
      actions: actions,
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      categoryIdentifier: 'Doctor Appointment',
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    var scheduledDate = tz.TZDateTime.from(notifyDate, tz.local);
    await localNotificationsPlugin.zonedSchedule(
      notifyID,
      title,
      detail,
      scheduledDate,
      notificationDetails,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}
