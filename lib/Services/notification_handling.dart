import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tanya_app_v1/Services/notify_services.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import '../GetXBinding/medicine_state_binding.dart';
import '../Model/notify_info.dart';
import '../Model/user_info_model.dart';
import '../Screen/Notify/notify_handle_screen.dart';
import 'package:http/http.dart' as http;

class NotificationHandeling {
  // utility function
  static getNotifyID(String payload) {
    var notifyInfoObject = jsonDecode(payload);
    return notifyInfoObject["notifyID"];
  }

  static Future<void> generateNewSchedule(
      int notifyID, NotifyInfoModel? notifyInfo,
      {required NotifyService notifyService}) async {
    var date = notifyInfo!.date;
    var now = DateTime.now();
    var minuteDiff = now.difference(date).inSeconds;
    if (minuteDiff <= 60) {
      var nextDateTime = now.add(const Duration(seconds: 15));
      // Convert string payload
      var notifyPayload = jsonEncode({
        "notifyID": notifyID,
        "notifyInfo": notifyInfo.toJson(),
      });
      await notifySet(
        notifyService: notifyService,
        id: notifyID,
        scheduleTime: nextDateTime,
        payload: notifyPayload,
        numNotify: notifyInfo.status,
        imagePath: notifyInfo.medicineInfo.picture_path!,
        notifyTitle: notifyInfo.name,
        notifydetail: notifyInfo.description,
      );
    } else {
      // apply message following type of medicine
      var typeText = "";
      switch (notifyInfo.medicineInfo.type) {
        case "pills":
        case "water":
          typeText = "กิน";
          break;
        case "arrow":
          typeText = "ฉีด";
          break;
        case "drop":
          typeText = "หยอด";
          break;
      }

      var result = await Get.dialog(
        AlertDialog(
          title: const Text(
            "คำเตือน!",
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            "ไม่สามารถเลื่อนการแจ้งเตือนได้\nเนื่องจากเลยกินยามา 1 ชั่วโมงแล้ว\nกรุณา$typeTextยาตอนนี้",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(result: "ตกลง");
              },
              child: const Text("ตกลง"),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: "ยังก่อน");
              },
              child: const Text("ยังก่อน"),
            ),
          ],
        ),
      );
      switch (result) {
        case "ตกลง":
          notifyInfo.status = 0;
          await notifyInfo.save();
          break;
        case "ยังก่อน":
          // แจ้งเตือนไปยังผู้ดูแล
          await notifyToCarePerson();
          break;
      }
    }
  }

  static Future<void> notifyToCarePerson() async {
    // LINE notify
    var userInfoBox = Hive.box<UserInfo>(HiveDatabaseName.USER_INFO);
    var userInfo = userInfoBox.get(0);

    if (userInfo?.lineToken != null) {
      Uri lineNotifyUrl = Uri.https('notify-api.line.me', 'api/notify');
      await http.post(
        lineNotifyUrl,
        headers: {
          "Authorization": "Bearer ${userInfo?.lineToken}",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body:
            "message=\nญาติของท่านยังไม่กินยาตามเวลา กรุณาเตือนญาติของท่านกินยาด้วยค่ะ",
      );
    }
  }

  static notifySet(
      {required int id,
      required DateTime scheduleTime,
      String? payload,
      required String imagePath,
      required int numNotify,
      required NotifyService notifyService,
      required String? notifyTitle,
      required String? notifydetail}) async {
    await notifyService.scheduleNotify(
      channelID: "Medicine Notify",
      channelName: "Medicine",
      channelDescription: "Medicine Notification for user",
      notifyID: id,
      notifyTitle: notifyTitle,
      notifyDetail: notifydetail,
      notifyPayload: payload,
      scheduleTime: scheduleTime,
      notifyId: id,
      imagePath: imagePath,
      notifyAction: const <AndroidNotificationAction>[
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
  }

  // static function
  @pragma('vm:entry-point')
  static Future<void> medicineOnDidReceiveNotificationAndroid(
      NotificationResponse notificationResponse) async {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        var notifyID = getNotifyID(notificationResponse.payload!);
        var notifyBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
        var notifyInfo = notifyBox.getAt(notifyID);
        var status = await Get.to(
            () => NotifyHandleScreen(
                  notifyID: notifyID,
                ),
            binding: AppInfoBinding());

        switch (status) {
          case "OK":
            notifyInfo!.status = 0;
            await notifyInfo.save();
            break;
          case "PENDING":
            var notifyService = NotifyService();
            await notifyService.inintializeNotification(
              onDidReceiveNotificationAndroid:
                  medicineOnDidReceiveNotificationAndroid,
              onDidReceiveNotificationIOS: null,
            );
            await generateNewSchedule(notifyID, notifyInfo,
                notifyService: notifyService);
            break;
        }

        break;
      case NotificationResponseType.selectedNotificationAction:
        // ignore: todo
        // TODO: Handle this case. for Android
        // When action on notification is clicked
        //print(notificationResponse.actionId);
        //print(notificationResponse.payload);
        var notifyID = getNotifyID(notificationResponse.payload!);
        var notifyBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
        var notifyInfo = notifyBox.getAt(notifyID);

        switch (notificationResponse.actionId) {
          case "OK":
            // notify status -> complete
            notifyInfo!.status = 0;
            await notifyInfo.save();
            break;
          case "PENDING":
            // create notify service
            var notifyService = NotifyService();
            await notifyService.inintializeNotification(
              onDidReceiveNotificationAndroid:
                  medicineOnDidReceiveNotificationAndroid,
              onDidReceiveNotificationIOS: null,
            );
            await generateNewSchedule(notifyID, notifyInfo,
                notifyService: notifyService);
            break;
        }
        break;
    }
  }

  @pragma('vm:entry-point')
  static Future<void> appointmentOnDidReceiveNotificationAndroid(
      NotificationResponse notificationResponse) async {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        var notifyService = NotifyService();
        await notifyService.inintializeNotification(
            onDidReceiveNotificationIOS: null,
            onDidReceiveNotificationAndroid:
                appointmentOnDidReceiveNotificationAndroid);

        var payload = jsonDecode(notificationResponse.payload!);
        var dateDisplay = payload['dateDisplay'];
        var timeDisplay = payload['timeDisplay'];
        await Get.defaultDialog(
            title: 'แจ้งเตือนนัดหมายพบแพทย์',
            middleText: 'วันที่ $dateDisplay\nเวลา $timeDisplay',
            middleTextStyle: const TextStyle(
              fontSize: 16,
            ),
            confirm: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      await createNewDoctorAppointmentNotification(payload,
                          notifyService: notifyService);
                      Get.back();
                    },
                    child: const Text(
                      'แจ้งเตือนอีกครั้ง',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'ไม่ต้องแจ้งเตือน',
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              ),
            ));
        break;
      case NotificationResponseType.selectedNotificationAction:
        // ignore: todo
        // TODO: Handle this case.
        // When action on notification is clicked
        //print(notificationResponse.actionId);
        //print(notificationResponse.payload);
        // var notifyID = getNotifyID(notificationResponse.payload!);
        // var notifyBox = Hive.box<NotifyInfoModel>('user_notify_info');
        // var notifyInfo = notifyBox.getAt(notifyID);
        if (notificationResponse.actionId == "OK") {
          // // notify status -> complete
          // notifyInfo!.status = 0;
          // notifyInfo.save();
          //print(notificationResponse.payload);
        }
        if (notificationResponse.actionId == "PENDING") {
          var notifyService = NotifyService();
          await notifyService.inintializeNotification(
              onDidReceiveNotificationIOS: null,
              onDidReceiveNotificationAndroid:
                  appointmentOnDidReceiveNotificationAndroid);

          var payload = jsonDecode(notificationResponse.payload!);
          await createNewDoctorAppointmentNotification(payload,
              notifyService: notifyService);
        }
        break;
    }
  }

  static Future<void> createNewDoctorAppointmentNotification(dynamic payload,
      {required NotifyService notifyService}) async {
    int appointmentID = payload['id'];
    var appointmentDateTime = DateTime.parse(payload['appointmentDateTime']);
    int delayDays = payload['delayDays'];
    var dateDisplay = payload['dateDisplay'];
    var timeDisplay = payload['timeDisplay'];

    if (delayDays == 1) {
      return;
    }
    switch (delayDays) {
      case 7:
        delayDays = 3; // notify before 3 day
        break;
      case 3:
        delayDays = 1; // notify before 1 day
        break;
    }
    // set notify again
    DateTime notifyTime =
        appointmentDateTime.subtract(Duration(minutes: delayDays)); // test

    await setAppointmentNotify(
      notifyService: notifyService,
      notifyID: appointmentID,
      notifyTime: notifyTime,
      appointmentTime: appointmentDateTime,
      delayDays: delayDays,
      dateDisplay: dateDisplay,
      timeDisplay: timeDisplay,
    );
  }

  static Future<void> setAppointmentNotify({
    required int notifyID,
    required DateTime notifyTime,
    required DateTime appointmentTime,
    required int delayDays,
    required String dateDisplay,
    required String timeDisplay,
    required NotifyService notifyService,
  }) async {
    var payload = json.encode(
      {
        "id": notifyID,
        "appointmentDateTime": appointmentTime.toString(),
        "delayDays": delayDays,
        "dateDisplay": dateDisplay,
        "timeDisplay": timeDisplay,
      },
    );
    //var notifyState = Get.find<NotificationState>();

    await notifyService.inintializeNotification(
      onDidReceiveNotificationAndroid:
          appointmentOnDidReceiveNotificationAndroid,
      onDidReceiveNotificationIOS: null,
    );
    await notifyService.requestPermission();
    await notifyService.scheduleDoctorAppointmentNotify(
      notifyID: notifyID,
      title: 'มีนัดพบแพทย์',
      detail: 'วันที่ $dateDisplay \nเวลา $timeDisplay',
      notifyDate: notifyTime,
      payload: payload,
      actions: const <AndroidNotificationAction>[
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
      ],
    );
  }
}
