//import 'dart:html';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // for datetime formatting
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';

import '../../../Model/user_info_model.dart';
import '../../../Services/notify_services.dart';
import '../../MedicineInformation/to_choose_medicine_info_list.dart';
import '../notify_handle_screen.dart'; // for random variable

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';

import 'package:http/http.dart' as http;

class AddNotifyDetailScreen extends StatefulWidget {
  const AddNotifyDetailScreen({
    super.key,
    required this.selectedDate,
  });

  final DateTime selectedDate;

  @override
  State<AddNotifyDetailScreen> createState() => _AddNotifyDetailScreenState();
}

class MedicineInformation {
  String? name;
  String? description;
  String? type;
  String? unit;
  double? nTake;
  String? order;
  List<bool>? periodTime;
  String? picturePath;
  int? color;

  MedicineInfo asMedicineInfo() {
    return MedicineInfo(
      name: name!,
      description: description!,
      type: type!,
      unit: unit!,
      nTake: nTake!,
      order: order!,
      period_time: periodTime!,
      picture_path: picturePath,
      color: color!,
    );
  }

  MedicineInformation({
    this.name,
    this.description,
    this.type,
    this.unit,
    this.nTake,
    this.order,
    this.periodTime,
    this.picturePath,
    this.color,
  });
}

class NotifyInformation {
  String? name;
  String? detail;
  DateTime? startDate;
  DateTime? endDate;
  MedicineInformation? selectedMedicine;
  TimeOfDay? morningTime;
  TimeOfDay? lunchTime;
  TimeOfDay? eveningTime;
  TimeOfDay? beforeToBedTime;

  bool get enableMorningTime {
    return morningTime != null ? true : false;
  }

  bool get enableLunchTime {
    return lunchTime != null ? true : false;
  }

  bool get enableEveningTime {
    return eveningTime != null ? true : false;
  }

  bool get enableBeforeToBedTime {
    return beforeToBedTime != null ? true : false;
  }

  NotifyInformation({
    this.name,
    this.detail,
    this.startDate,
    this.endDate,
    this.selectedMedicine,
    this.morningTime,
    this.lunchTime,
    this.eveningTime,
    this.beforeToBedTime,
  });
}

class NofifyEachDayInformation {
  String? name;
  String? detail;
  String medicineInformation;
  String date;
  String time;
  String status;
  int numberOfNotify;
  NofifyEachDayInformation({
    this.name,
    this.detail,
    required this.medicineInformation,
    required this.date,
    required this.time,
    required this.status,
    required this.numberOfNotify,
  });
}

class _AddNotifyDetailScreenState extends State<AddNotifyDetailScreen> {
  //int numberOfNotifyTimeItem = 0;

  NotifyInformation notifyInformation = NotifyInformation();
  NotifyService notifyServices = NotifyService(); // notification services

  // State variable
  TextEditingController notifyNameController = TextEditingController();
  TextEditingController notifyDetailController = TextEditingController();
  TextEditingController selectedStartNotifyDateController =
      TextEditingController();
  TextEditingController selectedEndNotifyDateController =
      TextEditingController();
  MedicineInformation selectedMedicine = MedicineInformation();
  TextEditingController selectedMedicineController = TextEditingController();

  TextEditingController notifyMorningTimeController = TextEditingController();
  TextEditingController notifyLunchTimeController = TextEditingController();
  TextEditingController notifyEveningTimeController = TextEditingController();
  TextEditingController notifyBeforetoBedTimeController =
      TextEditingController();

  // ---
  getNotifyID(String payload) {
    var notifyInfoObject = jsonDecode(payload);
    return notifyInfoObject["notifyID"];
  }

  void onDidReceiveLocalNotificationIOS(
      int id, String? title, String? body, String? payload) async {
    //print("$id, $title");
  }

  generateNewSchedule(int notifyID, NotifyInfoModel? notifyInfo) async {
    var date = notifyInfo!.date;
    var now = DateTime.now();
    var minuteDiff = now.difference(date).inMinutes;
    if (minuteDiff <= 60) {
      var nextDateTime = now.add(const Duration(minutes: 15));
      // Convert string payload
      var notifyPayload = jsonEncode({
        "notifyID": notifyID,
        "notifyInfo": notifyInfo.toJson(),
      });
      notifySet(
        id: notifyID,
        scheduleTime: nextDateTime,
        payload: notifyPayload,
        numNotify: notifyInfo.status,
        imagePath: notifyInfo.medicineInfo.picture_path!,
      );
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text(
            "คำเตือน!",
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
              "ไม่สามารถเลื่อนการแจ้งเตือนได้ เนื่องจากล่วงเลยกินยามามากกว่า 1 ชั่วโมงแล้ว"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("OK"),
            )
          ],
        ),
      );

      // แจ้งเตือนไปยังผู้ดูแล
      await notifyToCarePerson();
    }
  }

  void onDidReceiveNotificationAndroid(
      NotificationResponse notificationResponse) async {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        // ignore: todo
        // TODO: Handle this case. for Android, IOS
        // When click on notification
        // .notificationResponseType
        // .id
        // .actonId
        // .input
        // .payload
        //print(notificationResponse.payload);
        var notifyID = getNotifyID(notificationResponse.payload!);
        var notifyBox = Hive.box<NotifyInfoModel>('user_notify_info');
        var notifyInfo = notifyBox.getAt(notifyID);
        var status = await Get.to(() => NotifyHandleScreen(
              notifyID: notifyID,
            ));

        if (status == "OK") {
          notifyInfo!.status = 0;
          notifyInfo.save();
        }
        if (status == "PENDING") {
          generateNewSchedule(notifyID, notifyInfo);
        }

        break;
      case NotificationResponseType.selectedNotificationAction:
        // ignore: todo
        // TODO: Handle this case. for Android
        // When action on notification is clicked
        //print(notificationResponse.actionId);
        //print(notificationResponse.payload);
        var notifyID = getNotifyID(notificationResponse.payload!);
        var notifyBox = Hive.box<NotifyInfoModel>('user_notify_info');
        var notifyInfo = notifyBox.getAt(notifyID);

        if (notificationResponse.actionId == "OK") {
          // notify status -> complete
          notifyInfo!.status = 0;
          notifyInfo.save();
        }
        if (notificationResponse.actionId == "PENDING") {
          generateNewSchedule(notifyID, notifyInfo);
          // set notify again
          // set notification
          // var date = notifyInfo!.date;
          // var now = DateTime.now();
          // var minuteDiff = now.difference(date).inMinutes;
          // if (minuteDiff <= 60) {
          //   var nextDateTime = now.add(const Duration(minutes: 15));
          //   // Convert string payload
          //   var notifyPayload = jsonEncode({
          //     "notifyID": notifyID,
          //     "notifyInfo": notifyInfo.toJson(),
          //   });
          //   notifySet(
          //     id: notifyID,
          //     scheduleTime: nextDateTime,
          //     payload: notifyPayload,
          //     numNotify: notifyInfo.status,
          //     imagePath: notifyInfo.medicineInfo.picture_path!,
          //   );
          // } else {
          //   Get.dialog(
          //     AlertDialog(
          //       title: const Text(
          //         "คำเตือน!",
          //         style: TextStyle(color: Colors.red),
          //       ),
          //       content: const Text(
          //           "ไม่สามารถเลื่อนการแจ้งเตือนได้ เนื่องจากล่วงเลยกินยามามากกว่า 1 ชั่วโมงแล้ว"),
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //             Get.back();
          //           },
          //           child: const Text("OK"),
          //         )
          //       ],
          //     ),
          //   );

          //   // แจ้งเตือนไปยังผู้ดูแล
          //   await notifyToCarePerson();
          // }
        }
        break;
    }
  }

  notifyToCarePerson() async {
    // LINE notify
    var userInfoBox = Hive.box<UserInfo>('user_info');
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

  //List<bool> peroidDateSelected = [false, true, true, true, true, true, true];
  bool periodMondaySelected = false;
  bool periodTuesdaySelected = false;
  bool periodWednesdaySelected = false;
  bool periodThursdaySelected = false;
  bool periodFridaySelected = false;
  bool periodSaturdaySelected = false;
  bool periodSundaySelected = false;

  @override
  void initState() {
    super.initState();

    // intial notification service
    notifyServices.inintializeNotification(
      onDidReceiveNotificationAndroid: onDidReceiveNotificationAndroid,
      onDidReceiveNotificationIOS: onDidReceiveLocalNotificationIOS,
    );
    notifyServices.requestPermission();

    // selectedStartNotifyDate = widget.selectedDate;
    // selectedEndNotifyDate = widget.selectedDate;
    selectedStartNotifyDateController.text = DateFormat.yMMMd('th_TH')
        .formatInBuddhistCalendarThai(widget.selectedDate);
    selectedEndNotifyDateController.text = DateFormat.yMMMd('th_TH')
        .formatInBuddhistCalendarThai(widget.selectedDate);
    notifyInformation.startDate = widget.selectedDate;
    notifyInformation.endDate = widget.selectedDate;
  }

  // เริ่มการแจ้งเตือน
  selectStartDateNotify() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: notifyInformation.startDate!,
      firstDate: DateTime(2022),
      lastDate: DateTime(2032),
    );
    if (pickerDate != null) {
      setState(() {
        selectedStartNotifyDateController.text =
            DateFormat.yMMMd('th_TH').formatInBuddhistCalendarThai(pickerDate);
        notifyInformation.startDate = pickerDate;
      });

      if (pickerDate.isAfter(notifyInformation.endDate!)) {
        setState(() {
          selectedEndNotifyDateController.text = DateFormat.yMMMd('th_TH')
              .formatInBuddhistCalendarThai(pickerDate);
          notifyInformation.endDate = pickerDate;
        });
      }
    }
  }

  // สิ้นสุดการแจ้งเตือน
  selectEndDateNotify() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: notifyInformation.endDate!,
      firstDate: DateTime(2022),
      lastDate: DateTime(2032),
    );
    if (pickerDate != null) {
      setState(() {
        selectedEndNotifyDateController.text =
            DateFormat.yMMMd('th_TH').formatInBuddhistCalendarThai(pickerDate);
        notifyInformation.endDate = pickerDate;
      });
      if (pickerDate.isBefore(notifyInformation.startDate!)) {
        setState(() {
          selectedStartNotifyDateController.text = DateFormat.yMMMd('th_TH')
              .formatInBuddhistCalendarThai(pickerDate);
          notifyInformation.startDate = pickerDate;
        });
      }
    }
  }

  //เลือกรายการยา
  selectMedicineItem() async {
    var result = await Get.to(() => const ToChooseMedicine());
    // update field after choose
    if (result != null) {
      setState(() {
        notifyInformation.selectedMedicine = MedicineInformation(
            name: result.name,
            description: result.description,
            type: result.type,
            unit: result.unit,
            order: result.order,
            nTake: result.nTake,
            periodTime: result.period_time,
            picturePath: result.picture_path,
            color: result.color);

        if (result.period_time[0]) {
          notifyInformation.morningTime = const TimeOfDay(hour: 8, minute: 0);
          notifyMorningTimeController.text =
              notifyInformation.morningTime!.format(context);
        } else {
          notifyInformation.morningTime = null;
          notifyMorningTimeController.text = "";
        }
        if (result.period_time[1]) {
          notifyInformation.lunchTime = const TimeOfDay(hour: 12, minute: 0);
          notifyLunchTimeController.text =
              notifyInformation.lunchTime!.format(context);
        } else {
          notifyInformation.lunchTime = null;
          notifyLunchTimeController.text = "";
        }

        if (result.period_time[2]) {
          notifyInformation.eveningTime = const TimeOfDay(hour: 17, minute: 0);
          notifyEveningTimeController.text =
              notifyInformation.eveningTime!.format(context);
        } else {
          notifyInformation.eveningTime = null;
          notifyEveningTimeController.text = "";
        }

        if (result.period_time[3]) {
          notifyInformation.beforeToBedTime =
              const TimeOfDay(hour: 21, minute: 0);
          notifyBeforetoBedTimeController.text =
              notifyInformation.beforeToBedTime!.format(context);
        } else {
          notifyInformation.beforeToBedTime = null;
          notifyBeforetoBedTimeController.text = "";
        }

        // update text controller
        selectedMedicineController.text = result.name;
      });
    }
  }

  // เช้า
  selectNotifyMorningTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: notifyInformation.morningTime!,
    );
    if (newTime != null) {
      setState(() {
        notifyInformation.morningTime = newTime;
        notifyMorningTimeController.text =
            notifyInformation.morningTime!.format(context);
      });
    }
  }

  // กลางวัน
  selectNotifyLunchTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: notifyInformation.lunchTime!,
    );
    if (newTime != null) {
      setState(() {
        notifyInformation.lunchTime = newTime;
        notifyLunchTimeController.text =
            notifyInformation.lunchTime!.format(context);
      });
    }
  }

  // เย็น
  selectNotifyEveningTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: notifyInformation.eveningTime!,
    );
    if (newTime != null) {
      setState(() {
        notifyInformation.eveningTime = newTime;
        notifyEveningTimeController.text =
            notifyInformation.eveningTime!.format(context);
      });
    }
  }

  // ก่อนนอน
  selectNotifyBeforetoBedTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: notifyInformation.beforeToBedTime!,
    );
    if (newTime != null) {
      setState(() {
        notifyInformation.beforeToBedTime = newTime;
        notifyBeforetoBedTimeController.text =
            notifyInformation.beforeToBedTime!.format(context);
      });
    }
  }

  DateTime cleanTimeOfDay(DateTime datetime) {
    DateTime dateCleanTime = DateTime(
      datetime.year,
      datetime.month,
      datetime.day,
      0,
      0,
    );
    return dateCleanTime;
  }

  // ตกลง
  makeNotify() {
    // notification List
    var startDate = cleanTimeOfDay(notifyInformation.startDate!);
    var endDate = cleanTimeOfDay(notifyInformation.endDate!);
    var days = endDate.difference(startDate).inDays + 1;

    if (notifyInformation.enableMorningTime) {
      generateNotifySchedule(
        startDate: startDate,
        nDate: days,
        scheduleTime: notifyInformation.morningTime!,
        periodDays: [
          periodMondaySelected,
          periodTuesdaySelected,
          periodWednesdaySelected,
          periodThursdaySelected,
          periodFridaySelected,
          periodSaturdaySelected,
          periodSundaySelected,
        ],
      );
    }
    if (notifyInformation.enableLunchTime) {
      generateNotifySchedule(
        startDate: startDate,
        nDate: days,
        scheduleTime: notifyInformation.lunchTime!,
        periodDays: [
          periodMondaySelected,
          periodTuesdaySelected,
          periodWednesdaySelected,
          periodThursdaySelected,
          periodFridaySelected,
          periodSaturdaySelected,
          periodSundaySelected,
        ],
      );
    }
    if (notifyInformation.enableEveningTime) {
      generateNotifySchedule(
        startDate: startDate,
        nDate: days,
        scheduleTime: notifyInformation.eveningTime!,
        periodDays: [
          periodMondaySelected,
          periodTuesdaySelected,
          periodWednesdaySelected,
          periodThursdaySelected,
          periodFridaySelected,
          periodSaturdaySelected,
          periodSundaySelected,
        ],
      );
    }
    if (notifyInformation.enableBeforeToBedTime) {
      generateNotifySchedule(
        startDate: startDate,
        nDate: days,
        scheduleTime: notifyInformation.beforeToBedTime!,
        periodDays: [
          periodMondaySelected,
          periodTuesdaySelected,
          periodWednesdaySelected,
          periodThursdaySelected,
          periodFridaySelected,
          periodSaturdaySelected,
          periodSundaySelected,
        ],
      );
    }
    Get.back();
  }

  // generate notify schedule
  generateNotifySchedule({
    required DateTime startDate,
    required int nDate,
    required List<bool> periodDays,
    required TimeOfDay scheduleTime,
  }) async {
    var date = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      scheduleTime.hour,
      scheduleTime.minute,
    );

    var now = DateTime.now();

    var boxNotify = Hive.box<NotifyInfoModel>('user_notify_info');
    for (int day = 0; day < nDate; day++) {
      DateTime nextDate = date.add(Duration(days: day));

      if (nextDate.isAfter(now)) {
        if (periodDays.every((selected) => selected == false)) {
          // not selected generate every days
          await generateNotifyItem(
            specificDate: nextDate,
            specificTime: scheduleTime,
            boxNotify: boxNotify,
            date: date,
            day: day,
          );
        } else {
          if (periodDays[0] && (nextDate.weekday == DateTime.monday)) {
            // generate every Monday
            await generateNotifyItem(
              specificDate: nextDate,
              specificTime: scheduleTime,
              boxNotify: boxNotify,
              date: date,
              day: day,
            );
          }
          if (periodDays[1] && (nextDate.weekday == DateTime.tuesday)) {
            // generate every Tuesday
            await generateNotifyItem(
              specificDate: nextDate,
              specificTime: scheduleTime,
              boxNotify: boxNotify,
              date: date,
              day: day,
            );
          }
          if (periodDays[2] && (nextDate.weekday == DateTime.wednesday)) {
            // generate every Wednesday
            await generateNotifyItem(
              specificDate: nextDate,
              specificTime: scheduleTime,
              boxNotify: boxNotify,
              date: date,
              day: day,
            );
          }
          if (periodDays[3] && (nextDate.weekday == DateTime.thursday)) {
            // generate every Thursday
            await generateNotifyItem(
              specificDate: nextDate,
              specificTime: scheduleTime,
              boxNotify: boxNotify,
              date: date,
              day: day,
            );
          }
          if (periodDays[4] && (nextDate.weekday == DateTime.friday)) {
            // generate every Friday
            await generateNotifyItem(
              specificDate: nextDate,
              specificTime: scheduleTime,
              boxNotify: boxNotify,
              date: date,
              day: day,
            );
          }
          if (periodDays[5] && (nextDate.weekday == DateTime.saturday)) {
            // generate every Saturday
            await generateNotifyItem(
              specificDate: nextDate,
              specificTime: scheduleTime,
              boxNotify: boxNotify,
              date: date,
              day: day,
            );
          }
          if (periodDays[6] && (nextDate.weekday == DateTime.sunday)) {
            // generate every Sunday
            await generateNotifyItem(
              specificDate: nextDate,
              specificTime: scheduleTime,
              boxNotify: boxNotify,
              date: date,
              day: day,
            );
          }
        }
      }
    }
  }

  Future<void> generateNotifyItem({
    required DateTime specificDate,
    required TimeOfDay specificTime,
    required Box<NotifyInfoModel> boxNotify,
    required DateTime date,
    required int day,
  }) async {
    var notifyData = NotifyInfoModel(
      name: notifyNameController.text,
      description: notifyDetailController.text,
      medicineInfo: notifyInformation.selectedMedicine!.asMedicineInfo(),
      date: specificDate,
      time: TimeOfDayModel(
        hour: specificTime.hour,
        minute: specificTime.minute,
      ),
    );
    var dataId = await boxNotify.add(notifyData);

    // Convert string payload
    var notifyPayload = jsonEncode({
      "notifyID": dataId,
      "notifyInfo": notifyData.toJson(),
    });
    // set notification
    notifySet(
      id: dataId,
      scheduleTime: date.add(
        Duration(days: day),
      ),
      payload: notifyPayload,
      numNotify: notifyData.status,
      imagePath: notifyData.medicineInfo.picture_path!,
    );
  }

  notifySet(
      {required int id,
      required DateTime scheduleTime,
      String? payload,
      required String imagePath,
      required int numNotify}) {
    notifyServices.scheduleNotify(
      channelID: "Medicine Notify",
      channelName: "Medicine",
      channelDescription: "Medicine Notification for user",
      notifyID: id,
      notifyTitle: notifyNameController.text,
      notifyDetail: notifyDetailController.text,
      notifyPayload: payload,
      notifyTicker: "Notify Ticker",
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

  TextStyle get periodDayTextStyly {
    return const TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มรายการแจ้งเตือน'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 8.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFieldEditor(
                title: "รายการ",
                hintText: "รายการแจ้งเตือน",
                controller: notifyNameController,
              ),
              TextFieldEditor(
                title: "รายละเอียด",
                hintText: "รายละเอียดการแจ้งเตือน",
                controller: notifyDetailController,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFieldEditor(
                      title: "เริ่มการแจ้งเตือน",
                      hintText: DateFormat.yMd('th_TH').format(
                        notifyInformation.startDate!,
                      ),
                      controller: selectedStartNotifyDateController,
                      widget: IconButton(
                        onPressed: selectStartDateNotify,
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFieldEditor(
                      title: "สิ้นสุดการแจ้งเตือน",
                      hintText: DateFormat.yMMMd('th_TH')
                          .formatInBuddhistCalendarThai(
                        notifyInformation.endDate!,
                      ),
                      controller: selectedEndNotifyDateController,
                      widget: IconButton(
                        onPressed: selectEndDateNotify,
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  PeriodDateSeletedCard(
                    text: 'จันทร์',
                    isSelected: periodMondaySelected,
                    onTap: () {
                      setState(() {
                        periodMondaySelected = !periodMondaySelected;
                      });
                    },
                  ),
                  PeriodDateSeletedCard(
                    text: 'อังคาร',
                    isSelected: periodTuesdaySelected,
                    onTap: () {
                      setState(() {
                        periodTuesdaySelected = !periodTuesdaySelected;
                      });
                    },
                  ),
                  PeriodDateSeletedCard(
                    text: 'พุธ',
                    isSelected: periodWednesdaySelected,
                    onTap: () {
                      setState(() {
                        periodWednesdaySelected = !periodWednesdaySelected;
                      });
                    },
                  ),
                  PeriodDateSeletedCard(
                    text: 'พฤหัส',
                    isSelected: periodThursdaySelected,
                    onTap: () {
                      setState(() {
                        periodThursdaySelected = !periodThursdaySelected;
                      });
                    },
                  ),
                  PeriodDateSeletedCard(
                    text: 'ศุกร์',
                    isSelected: periodFridaySelected,
                    onTap: () {
                      setState(() {
                        periodFridaySelected = !periodFridaySelected;
                      });
                    },
                  ),
                  PeriodDateSeletedCard(
                    text: 'เสาร์',
                    isSelected: periodSaturdaySelected,
                    onTap: () {
                      setState(() {
                        periodSaturdaySelected = !periodSaturdaySelected;
                      });
                    },
                  ),
                  PeriodDateSeletedCard(
                    text: 'อาทิตย์',
                    isSelected: periodSundaySelected,
                    onTap: () {
                      setState(() {
                        periodSundaySelected = !periodSundaySelected;
                      });
                    },
                  ),
                ],
              ),
              TextFieldEditor(
                controller: selectedMedicineController,
                title: "รายการยา",
                hintText: "เลือกรายการยา",
                widget: IconButton(
                  onPressed: selectMedicineItem,
                  icon: const Icon(
                    Icons.list_alt_outlined,
                    color: Colors.blue,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFieldEditor(
                      title: "เช้า",
                      hintText: "",
                      controller: notifyMorningTimeController,
                      widget: IconButton(
                        onPressed: notifyInformation.morningTime != null
                            ? selectNotifyMorningTime
                            : null,
                        icon: Icon(
                          Icons.access_alarm_outlined,
                          color: notifyInformation.morningTime != null
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFieldEditor(
                      title: "กลางวัน",
                      hintText: "",
                      controller: notifyLunchTimeController,
                      widget: IconButton(
                        onPressed: notifyInformation.lunchTime != null
                            ? selectNotifyLunchTime
                            : null,
                        icon: Icon(
                          Icons.access_alarm_outlined,
                          color: notifyInformation.lunchTime != null
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFieldEditor(
                      title: "เย็น",
                      hintText: "",
                      controller: notifyEveningTimeController,
                      widget: IconButton(
                        onPressed: notifyInformation.eveningTime != null
                            ? selectNotifyEveningTime
                            : null,
                        icon: Icon(
                          Icons.access_alarm_outlined,
                          color: notifyInformation.eveningTime != null
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFieldEditor(
                      title: "ก่อนนอน",
                      hintText: "",
                      controller: notifyBeforetoBedTimeController,
                      widget: IconButton(
                        onPressed: notifyInformation.beforeToBedTime != null
                            ? selectNotifyBeforetoBedTime
                            : null,
                        icon: Icon(
                          Icons.access_alarm_outlined,
                          color: notifyInformation.beforeToBedTime != null
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: makeNotify,
                          child: const Text(
                            'ตกลง',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'ยกเลิก',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get titleStyle {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }
}

class PeriodDateSeletedCard extends StatelessWidget {
  const PeriodDateSeletedCard({
    required this.isSelected,
    required this.text,
    this.onTap,
    super.key,
  });

  final bool isSelected;
  final String text;
  final Function()? onTap;

  TextStyle periodDayTextStyly(bool isSelected) {
    return isSelected
        ? const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
        : const TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: isSelected ? Colors.blue.shade400 : Colors.grey.shade400,
          child: SizedBox(
            height: 50,
            child: Center(
              child: Text(
                text,
                style: periodDayTextStyly(isSelected),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldEditor extends StatelessWidget {
  const TextFieldEditor({
    super.key,
    required this.title,
    required this.hintText,
    this.controller,
    this.widget,
  });

  final String title;
  final String hintText;
  final TextEditingController? controller;
  final Widget? widget;

  //
  TextStyle get titleStyle {
    return const TextStyle(
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle get subtitleStyle {
    return const TextStyle(
      fontSize: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget == null ? false : true,
                    style: subtitleStyle,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: subtitleStyle,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: widget,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NotifyTimeWidget extends StatelessWidget {
  const NotifyTimeWidget({
    super.key,
    required this.titleNotifyTime,
    required this.hintText,
    required this.onPressed,
  });

  final List<String> titleNotifyTime;
  final List<String> hintText;
  final List<Function()?> onPressed;

  //titleNotifyTime = ["เช้า","กลางวัน", "เย็น", "ก่อนนอน"];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: titleNotifyTime.length,
      itemBuilder: (context, index) => TextFieldEditor(
        title: titleNotifyTime[index],
        hintText: hintText[index],
        widget: IconButton(
          onPressed: onPressed[index],
          icon: const Icon(
            Icons.access_alarm_outlined,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
