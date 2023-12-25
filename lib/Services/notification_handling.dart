import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tanya_app_v1/Services/notify_services.dart';
import 'package:tanya_app_v1/home_app_screen.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import '../Controller/medicine_info_controller.dart';
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

  static createNotify(
      {required int notifyID,
      required NotifyInfoModel notifyInfo,
      required NotifyService notifyService,
      required DateTime nextDateTime}) async {
    var notifyPayload = jsonEncode({
      "channelName": "medicine",
      "notifyID": notifyID,
      "notifyInfo": notifyInfo.toJson(),
    });

    await notifyService.inintializeNotification(
        onDidReceiveNotification: onDidReceiveNotification);

    await notifyService.scheduleMedicineNotify(
      notifyID: notifyID,
      notifyTitle: notifyInfo.name,
      notifyDetail: notifyInfo.description,
      notifyPayload: notifyPayload,
      scheduleTime: nextDateTime,
      imagePath: notifyInfo.medicineInfo.picture_path!,
    );
  }

  static Future<void> generateNewSchedule(
    int notifyID,
    NotifyInfoModel? notifyInfo, {
    required NotifyService notifyService,
  }) async {
    var orgNotifyDate = notifyInfo!.date;
    var clickNotifyDate = DateTime.now();
    //var now = DateTime.now();
    const int minutes = 60;
    var secondDiff = clickNotifyDate.difference(orgNotifyDate).inSeconds.abs();
    if (secondDiff <= 15 * minutes) {
      var duration = const Duration(minutes: 15);
      var nextNotifyDateTime = orgNotifyDate.add(duration);
      //debugPrint("next 15 minutes, $nextNotifyDateTime");
      await createNotify(
          nextDateTime: nextNotifyDateTime,
          notifyID: notifyID,
          notifyInfo: notifyInfo,
          notifyService: notifyService);
    } else if (secondDiff > 15 * minutes && secondDiff <= 30 * minutes) {
      var duration = const Duration(minutes: 30);
      var nextNotifyDateTime = orgNotifyDate.add(duration);
      //debugPrint("next 30 minutes, $nextNotifyDateTime");
      await createNotify(
          nextDateTime: nextNotifyDateTime,
          notifyID: notifyID,
          notifyInfo: notifyInfo,
          notifyService: notifyService);
    } else if (secondDiff > 30 * minutes && secondDiff <= 45 * minutes) {
      var duration = const Duration(minutes: 45);
      var nextNotifyDateTime = orgNotifyDate.add(duration);
      //debugPrint("next 45 minutes, $nextNotifyDateTime");
      await createNotify(
          nextDateTime: nextNotifyDateTime,
          notifyID: notifyID,
          notifyInfo: notifyInfo,
          notifyService: notifyService);
    } else if (secondDiff > 45 * minutes && secondDiff <= 60 * minutes) {
      var duration = const Duration(minutes: 60);
      var nextNotifyDateTime = orgNotifyDate.add(duration);
      //debugPrint("next 60 minutes, $nextNotifyDateTime");
      await createNotify(
          nextDateTime: nextNotifyDateTime,
          notifyID: notifyID,
          notifyInfo: notifyInfo,
          notifyService: notifyService);
    } else if (secondDiff > 60 * minutes) {
      //debugPrint("message to care person");
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
      await Get.dialog(
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
              onPressed: () async {
                notifyInfo.status = 0;
                await notifyInfo.save();
                Get.back();
              },
              child: const Text("ตกลง"),
            ),
            TextButton(
              onPressed: () async {
                await notifyToCarePerson();
                Get.back();
              },
              child: const Text("ยังก่อน"),
            ),
          ],
        ),
      );
    }
    // if (minuteDiff <= 60) {
    // var now = DateTime.now();
    // var nowZeroSecond =
    //     DateTime(now.year, now.month, now.day, now.hour, now.minute, 0);
    // var nextDateTime = nowZeroSecond.add(const Duration(minutes: 15));

    // // Convert string payload
    // var notifyPayload = jsonEncode({
    //   "channelName": "medicine",
    //   "notifyID": notifyID,
    //   "notifyInfo": notifyInfo.toJson(),
    // });

    // await notifyService.inintializeNotification(
    //     onDidReceiveNotification: onDidReceiveNotification);

    // await notifyService.scheduleMedicineNotify(
    //   notifyID: notifyID,
    //   notifyTitle: notifyInfo.name,
    //   notifyDetail: notifyInfo.description,
    //   notifyPayload: notifyPayload,
    //   scheduleTime: nextDateTime,
    //   imagePath: notifyInfo.medicineInfo.picture_path!,
    // );
    // } else {
    //   var result = await Get.dialog(
    //     AlertDialog(
    //       title: const Text(
    //         "คำเตือน!",
    //         style: TextStyle(color: Colors.red),
    //       ),
    //       content: Text(
    //         "ไม่สามารถเลื่อนการแจ้งเตือนได้\nเนื่องจากเลยกินยามา 1 ชั่วโมงแล้ว\nกรุณา$typeTextยาตอนนี้",
    //         textAlign: TextAlign.center,
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Get.back(result: "ตกลง");
    //           },
    //           child: const Text("ตกลง"),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             Get.back(result: "ยังก่อน");
    //           },
    //           child: const Text("ยังก่อน"),
    //         ),
    //       ],
    //     ),
    //   );
    //   switch (result) {
    //     case "ตกลง":
    //       notifyInfo.status = 0;
    //       await notifyInfo.save();
    //       break;
    //     case "ยังก่อน":
    //       // แจ้งเตือนไปยังผู้ดูแล
    //       await notifyToCarePerson();
    //       break;
    //   }
    // }
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
            "message=\nญาติของท่านยังไม่กินยาหรือฉีดยาตามเวลาที่กำหนด กรุณาเตือนญาติของท่านด้วยค่ะ",
      );
    }
  }

  static Future<void> updateNotifyStatus(int notifyID) async {
    var notifyBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
    if (!notifyBox.isOpen) {
      notifyBox = await Hive.openBox(HiveDatabaseName.NOTIFY_INFO);
    }
    var notifyInfo = notifyBox.get(notifyID);
    if (notifyInfo != null) {
      notifyInfo.status = 0;
      await notifyInfo.save();
    } else {
      await Get.defaultDialog(
        title: "Error",
        middleText: "notify ID is not found",
      );
    }
  }

  static getNotifyInfo(notifyID) async {
    var notifyBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
    if (!notifyBox.isOpen) {
      notifyBox = await Hive.openBox(HiveDatabaseName.NOTIFY_INFO);
    }
    return notifyBox.get(notifyID);
  }

  // static function
  //@pragma('vm:entry-point')
  static void onDidReceiveNotification(
      NotificationResponse notificationResponse) async {
    //debugPrint('onDidReceiveNotification');
    var pageController = Get.find<PageState>();
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        // get channel name
        var payloadJson = jsonDecode(notificationResponse.payload!);

        var channelName = payloadJson["channelName"];

        if (channelName == "medicine") {
          var notifyID = payloadJson["notifyID"];
          String status = await Get.to(
              () => NotifyHandleScreen(
                    notifyID: notifyID,
                  ),
              binding: AppInfoBinding());
          if (status == "OK") {
            await updateNotifyStatus(notifyID);

            // go to Medicine State List on Home Screen
            pageController.changePageto(1);
          } else if (status == "PENDING") {
            var notifyInfo = await getNotifyInfo(notifyID);
            await generateNewSchedule(notifyID, notifyInfo,
                notifyService: NotifyService());
          }
        } else if (channelName == "doctorAppointment") {
          //implement
          var dateDisplay = payloadJson['dateDisplay'];
          var timeDisplay = payloadJson['timeDisplay'];
          var delaysDay = payloadJson['delayDays'];

          await Get.defaultDialog(
            title: 'แจ้งเตือนนัดหมายพบแพทย์',
            middleText: 'วันที่ $dateDisplay\nเวลา $timeDisplay',
            middleTextStyle: const TextStyle(
              fontSize: 16,
            ),
            confirm: delaysDay > 1
                ? Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () async {
                            // var appointmentNotifyService = NotifyService();
                            // await appointmentNotifyService.inintializeNotification(
                            //     onDidReceiveNotificationIOS: null,
                            //     onDidReceiveNotificationAndroid:
                            //         appointmentOnDidReceiveNotificationAndroid);
                            await createNewDoctorAppointmentNotification(
                                payloadJson);
                            Get.back();
                          },
                          child: const Text(
                            'แจ้งเตือนอีกครั้ง',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              // do nothing
                              Get.back();
                            },
                            child: const Text(
                              'ไม่ต้องแจ้งเตือน',
                              style: TextStyle(fontSize: 18),
                            )),
                      ],
                    ),
                  )
                : null,
          );
          pageController.changePageto(3);
        }

        break;
      case NotificationResponseType.selectedNotificationAction:
        var payloadJson = jsonDecode(notificationResponse.payload!);

        var channelName = payloadJson["channelName"];

        if (channelName == "medicine") {
          var notifyID = payloadJson["notifyID"];
          switch (notificationResponse.actionId) {
            case "OK":
              await updateNotifyStatus(notifyID);
              pageController.changePageto(1);
              break;
            case "PENDING":
              var notifyInfo = await getNotifyInfo(notifyID);

              // var notifyService = NotifyService();
              // await notifyService.inintializeNotification(
              //     onDidReceiveNotification: onDidReceiveNotification);

              await generateNewSchedule(notifyID, notifyInfo,
                  notifyService: NotifyService());
              break;
          }
        } else if (channelName == "doctorAppointment") {
          switch (notificationResponse.actionId) {
            case "OK":
              // do nothing
              break;
            case "PENDING":
              await createNewDoctorAppointmentNotification(payloadJson);
              break;
          }
          pageController.changePageto(3);
        }
      // // have to implement on above
      // switch (notificationResponse.actionId) {
      //   case "OK":
      //     updateNotifyStatus(notificationResponse.payload);
      //     break;
      //   case "PENDING":
      //     // create notify service
      //     var notifyService = NotifyService();
      //     await notifyService.inintializeNotification(
      //       onDidReceiveNotificationAndroid:
      //           medicineOnDidReceiveNotificationAndroid,
      //       onDidReceiveNotificationIOS: null,
      //     );
      //     var notifyInfo = await getNotifyInfo(notifyID);
      //     await generateNewSchedule(notifyID, notifyInfo,
      //         notifyService: notifyService);
      //     break;
      // }
      // break;
    }
  }

  // @pragma('vm:entry-point')
  // static void appointmentOnDidReceiveNotificationAndroid(
  //     NotificationResponse notificationResponse) async {
  //   switch (notificationResponse.notificationResponseType) {
  //     case NotificationResponseType.selectedNotification:
  //       var payload = jsonDecode(notificationResponse.payload!);
  //       var dateDisplay = payload['dateDisplay'];
  //       var timeDisplay = payload['timeDisplay'];
  //       var delaysDay = payload['delayDays'];

  //       if (delaysDay > 1) {
  //         await Get.defaultDialog(
  //           title: 'แจ้งเตือนนัดหมายพบแพทย์',
  //           middleText: 'วันที่ $dateDisplay\nเวลา $timeDisplay',
  //           middleTextStyle: const TextStyle(
  //             fontSize: 16,
  //           ),
  //           confirm: Expanded(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 TextButton(
  //                   onPressed: () async {
  //                     var appointmentNotifyService = NotifyService();
  //                     await appointmentNotifyService.inintializeNotification(
  //                         onDidReceiveNotificationIOS: null,
  //                         onDidReceiveNotificationAndroid:
  //                             appointmentOnDidReceiveNotificationAndroid);
  //                     await createNewDoctorAppointmentNotification(payload,
  //                         notifyService: appointmentNotifyService);
  //                     Get.back();
  //                   },
  //                   child: const Text(
  //                     'แจ้งเตือนอีกครั้ง',
  //                     style: TextStyle(fontSize: 18),
  //                   ),
  //                 ),
  //                 TextButton(
  //                     onPressed: () {
  //                       // do nothing
  //                       Get.back();
  //                     },
  //                     child: const Text(
  //                       'ไม่ต้องแจ้งเตือน',
  //                       style: TextStyle(fontSize: 18),
  //                     )),
  //               ],
  //             ),
  //           ),
  //         );
  //       }

  //       break;
  //     case NotificationResponseType.selectedNotificationAction:
  //       if (notificationResponse.actionId == "OK") {
  //         // do nothing
  //       }
  //       if (notificationResponse.actionId == "PENDING") {
  //         var notifyService = NotifyService();
  //         await notifyService.inintializeNotification(
  //             onDidReceiveNotificationIOS: null,
  //             onDidReceiveNotificationAndroid:
  //                 appointmentOnDidReceiveNotificationAndroid);

  //         var payload = jsonDecode(notificationResponse.payload!);
  //         await createNewDoctorAppointmentNotification(payload,
  //             notifyService: notifyService);
  //       }
  //       break;
  //   }
  // }

  static Future<void> createNewDoctorAppointmentNotification(
    dynamic payload,
  ) async {
    int appointmentID = payload['id'];
    var appointmentDateTime = DateTime.parse(payload['appointmentDateTime']);
    int delayDays = payload['delayDays'];
    var dateDisplay = payload['dateDisplay'];
    var timeDisplay = payload['timeDisplay'];

    if (delayDays == 1 || delayDays == 0) {
      return;
    } else {
      switch (delayDays) {
        case 7:
          delayDays = 3; // notify before 3 day
          break;
        case 3:
          delayDays = 1; // notify before 1 day
          break;
      }
    }

    // set notify again
    DateTime notifyTime =
        appointmentDateTime.subtract(Duration(days: delayDays)); // test

    await setAppointmentNotify(
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
  }) async {
    var payload = jsonEncode(
      {
        "channelName": "doctorAppointment",
        "id": notifyID,
        "appointmentDateTime": appointmentTime.toString(),
        "delayDays": delayDays,
        "dateDisplay": dateDisplay,
        "timeDisplay": timeDisplay,
      },
    );

    var notifyService = NotifyService();
    await notifyService.inintializeNotification(
      onDidReceiveNotification: onDidReceiveNotification,
    );

    await notifyService.requestPermission();
    await notifyService.scheduleDoctorAppointmentNotify(
      notifyID: notifyID,
      title: 'มีนัดพบแพทย์',
      detail: 'วันที่ $dateDisplay \nเวลา $timeDisplay',
      notifyDate: notifyTime,
      payload: payload,
      delayDays: delayDays,
    );
  }
}
