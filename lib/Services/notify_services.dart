import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/constants.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotifyService {
  static FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> inintializeNotification({
    required onDidReceiveNotification,
  }) async {
    tz.initializeTimeZones();

    // IOS
    List<DarwinNotificationCategory> iosNotificationCategories =
        const <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        'แจ้งเตือนยา',
      ),
      DarwinNotificationCategory(
        'แจ้งเตือนนัดหมาย',
      ),
    ];

    final DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: iosNotificationCategories,
    );

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: iOSInitializationSettings,
            android: androidInitializationSettings);

    await localNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotification);
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
      await andriodImplementation?.requestNotificationsPermission();
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

  // medicine notify schedule
  Future<void> scheduleMedicineNotify({
    required int notifyID,
    required String notifyTitle,
    required String notifyDetail,
    required String notifyPayload,
    required DateTime scheduleTime,
    List<AndroidNotificationAction>? notifyAction,
    required String imagePath,
  }) async {
    var notifyData = jsonDecode(notifyPayload);
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

    // notify detail of android
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'medicine',
      'แจ้งเตือนยา',
      channelDescription: 'การแจ้งเตือนรายการยา',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'medicine',
      styleInformation: bigPictureStyleInformation,
      largeIcon: FilePathAndroidBitmap(imagePath),
      actions: const <AndroidNotificationAction>[
        AndroidNotificationAction(
          'OK',
          'ตกลง',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'PENDING',
          'เลื่อนไปก่อน',
          showsUserInterface: true,
        )
      ],
    );

    // check file is exist
    DarwinNotificationDetails? iosNotificationDetails =
        const DarwinNotificationDetails(
      categoryIdentifier: 'แจ้งเตือนยา',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    var schedule1 = tz.TZDateTime.from(scheduleTime, tz.local);
    await localNotificationsPlugin.zonedSchedule(
      notifyID,
      notifyTitle,
      '$notifyDetail เวลา ${DateFormat('HH:mm น.').format(datetime)}',
      schedule1,
      notificationDetails,
      payload: notifyPayload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // appointment notify
  Future<void> scheduleDoctorAppointmentNotify({
    required int notifyID,
    required DateTime notifyDate,
    String? title,
    String? detail,
    String? payload,
    required int delayDays,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'doctor_appointment',
      'แจ้งเตือนนัดหมาย',
      channelDescription: 'การแจ้งเตือนสำหรับการนัดหมายพบแพทย์',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'doctor appointment',
      actions: delayDays > 1
          ? const <AndroidNotificationAction>[
              AndroidNotificationAction(
                'PENDING',
                'แจ้งเตือนอีกครั้ง',
                showsUserInterface: true,
              ),
              AndroidNotificationAction(
                'OK',
                'ไม่ต้องแจ้งเตือน',
                showsUserInterface: true,
              )
            ]
          : null,
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      categoryIdentifier: 'แจ้งเตือนนัดหมาย',
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    var scheduledDate = tz.TZDateTime.from(notifyDate, tz.local);
    await localNotificationsPlugin.zonedSchedule(
      notifyID + offsetID,
      title,
      detail,
      scheduledDate,
      notificationDetails,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
