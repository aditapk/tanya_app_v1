import 'dart:convert';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/constants.dart';
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

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // const AndroidInitializationSettings androidInitializationSettings =
    //     AndroidInitializationSettings('launch_background');
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

  String? getWordType(String type) {
    if (type == "pills" || type == "water") {
      return "กิน";
    } else if (type == "arrow") {
      return "ฉีด";
    } else if (type == "drop") {
      return "หยอด/พ่น";
    } else {
      return "";
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
    var dateJson = notifyData["notifyInfo"]["date"];
    var timeJson = notifyData["notifyInfo"]["time"];
    var datetime = DateTime(
      dateJson["year"],
      dateJson["month"],
      dateJson["day"],
      timeJson["hour"],
      timeJson["minute"],
    );

    double nTake = medicineInfo["nTake"];
    var order = medicineInfo["order"];

    // if (notifyTitle!.isEmpty) {
    //   notifyTitle = "ถึงเวลา${getWordType(type)}ยา $name";
    // }
    // if (notifyDetail!.isEmpty) {
    //   notifyDetail = "อย่าลืม${getWordType(type)}ยานะครับ";
    // }

    String nTakeStr;

    // check is intisInt(double num) {
    if (nTake % 1 == 0) {
      nTakeStr = nTake.toInt().toString();
    } else {
      nTakeStr = nTake.toString();
    }

    var howToEat = "<type> ครั้งละ $nTakeStr $unit";
    switch (type) {
      case "pills":
      case "water":
        howToEat = howToEat.replaceAll('<type>', "กิน");
        break;
      case "arrow":
        howToEat = howToEat.replaceAll("<type>", "ฉีด");
        break;
      case "drop":
        howToEat = howToEat.replaceAll("<type>", "หยอด/พ่น");
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
      case "":
        orderInThai = "";
        break;
    }
    final contentTitle = "<b>$name<b>";

    final summaryText = orderInThai.isEmpty
        ? "$howToEat<br>เวลา ${DateFormat('HH:mm น.').format(datetime)}"
        : "$howToEat<br>$orderInThai, เวลา ${DateFormat('HH:mm น.').format(datetime)}";

    // big picture
    BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      imagePath.isNotEmpty
          ? FilePathAndroidBitmap(imagePath)
          : const FilePathAndroidBitmap(emptyPicture),
      contentTitle: contentTitle,
      htmlFormatContentTitle: true,
      summaryText: summaryText,
      htmlFormatSummaryText: true,
      hideExpandedLargeIcon: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channelID,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'medicine notification ticker',
      actions: notifyAction,
      styleInformation: bigPictureStyleInformation,
      largeIcon: FilePathAndroidBitmap(imagePath),
    );

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
      '$notifyDetail เวลา ${DateFormat('HH:mm น.').format(datetime)}',
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
      playSound: true,
      ticker: 'doctor appoinment ticker',
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
