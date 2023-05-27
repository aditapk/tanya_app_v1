//import 'dart:html';

import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // for datetime formatting
import 'package:tanya_app_v1/GetXBinding/medicine_state_binding.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/Services/notification_handling.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import '../../../Controller/medicine_info_controller.dart';
import '../../../Services/notify_services.dart';
import '../../MedicineInformation/to_choose_medicine_info_list.dart';
// for random variable

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';

class AddNotifyDetailScreen extends StatefulWidget {
  const AddNotifyDetailScreen({
    super.key,
    required this.selectedDate,
    this.medicineData,
  });

  final DateTime selectedDate;
  final MedicineInfo? medicineData;

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
  int? id;

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
      id: id!,
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
    this.id,
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
  NotifyService notifyService = NotifyService(); // notification services
  //final medicineInfoState = Get.find<MedicineEditorState>();

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

  // // ---
  // getNotifyID(String payload) {
  //   var notifyInfoObject = jsonDecode(payload);
  //   return notifyInfoObject["notifyID"];
  // }

  // void onDidReceiveLocalNotificationIOS(
  //     int id, String? title, String? body, String? payload) async {
  //   //print("$id, $title");
  // }

  // generateNewSchedule(int notifyID, NotifyInfoModel? notifyInfo,
  //     {required NotifyService notifyService}) async {
  //   var date = notifyInfo!.date;
  //   var now = DateTime.now();
  //   var minuteDiff = now.difference(date).inMinutes;
  //   if (minuteDiff <= 1) {
  //     var nextDateTime = now.add(const Duration(seconds: 10));
  //     // Convert string payload
  //     var notifyPayload = jsonEncode({
  //       "notifyID": notifyID,
  //       "notifyInfo": notifyInfo.toJson(),
  //     });
  //     notifySet(
  //       notifyService: notifyService,
  //       id: notifyID,
  //       scheduleTime: nextDateTime,
  //       payload: notifyPayload,
  //       numNotify: notifyInfo.status,
  //       imagePath: notifyInfo.medicineInfo.picture_path!,
  //     );
  //   } else {
  //     Get.dialog(
  //       AlertDialog(
  //         title: const Text(
  //           "คำเตือน!",
  //           style: TextStyle(color: Colors.red),
  //         ),
  //         content: const Text(
  //             "ไม่สามารถเลื่อนการแจ้งเตือนได้ เนื่องจากล่วงเลยกินยามามากกว่า 1 ชั่วโมงแล้ว"),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Get.back();
  //             },
  //             child: const Text("OK"),
  //           )
  //         ],
  //       ),
  //     );

  //     // แจ้งเตือนไปยังผู้ดูแล
  //     await notifyToCarePerson();
  //   }
  // }

  // Future<void> onDidReceiveNotificationAndroid(
  //     NotificationResponse notificationResponse) async {
  //   switch (notificationResponse.notificationResponseType) {
  //     case NotificationResponseType.selectedNotification:
  //       // ignore: todo
  //       // When click on notification
  //       // .notificationResponseType
  //       // .id
  //       // .actonId
  //       // .input
  //       // .payload
  //       //print(notificationResponse.payload);
  //       var notifyID = getNotifyID(notificationResponse.payload!);
  //       var notifyBox = Hive.box<NotifyInfoModel>('user_notify_info');
  //       var notifyInfo = notifyBox.getAt(notifyID);
  //       var status = await Get.to(
  //           () => NotifyHandleScreen(
  //                 notifyID: notifyID,
  //               ),
  //           binding: appInfoBinding());

  //       switch (status) {
  //         case "OK":
  //           notifyInfo!.status = 0;
  //           notifyInfo.save();
  //           break;
  //         case "PENDING":
  //           await notifyService.inintializeNotification(
  //             onDidReceiveNotificationAndroid: onDidReceiveNotificationAndroid,
  //             onDidReceiveNotificationIOS: onDidReceiveLocalNotificationIOS,
  //           );
  //           generateNewSchedule(notifyID, notifyInfo,
  //               notifyService: notifyService);
  //           break;
  //       }

  //       break;
  //     case NotificationResponseType.selectedNotificationAction:
  //       // ignore: todo
  //       // When action on notification is clicked
  //       //print(notificationResponse.actionId);
  //       //print(notificationResponse.payload);
  //       var notifyID = getNotifyID(notificationResponse.payload!);
  //       var notifyBox = Hive.box<NotifyInfoModel>('user_notify_info');
  //       var notifyInfo = notifyBox.getAt(notifyID);

  //       switch (notificationResponse.actionId) {
  //         case "OK":
  //           // notify status -> complete
  //           notifyInfo!.status = 0;
  //           notifyInfo.save();
  //           break;
  //         case "PENDING":
  //           // create notify service
  //           await notifyService.inintializeNotification(
  //             onDidReceiveNotificationAndroid: onDidReceiveNotificationAndroid,
  //             onDidReceiveNotificationIOS: onDidReceiveLocalNotificationIOS,
  //           );
  //           generateNewSchedule(notifyID, notifyInfo,
  //               notifyService: notifyService);
  //           break;
  //       }
  //       break;
  //   }
  // }

  // notifyToCarePerson() async {
  //   // LINE notify
  //   var userInfoBox = Hive.box<UserInfo>('user_info');
  //   var userInfo = userInfoBox.get(0);

  //   if (userInfo?.lineToken != null) {
  //     Uri lineNotifyUrl = Uri.https('notify-api.line.me', 'api/notify');
  //     await http.post(
  //       lineNotifyUrl,
  //       headers: {
  //         "Authorization": "Bearer ${userInfo?.lineToken}",
  //         "Content-Type": "application/x-www-form-urlencoded",
  //       },
  //       body:
  //           "message=\nญาติของท่านยังไม่กินยาตามเวลา กรุณาเตือนญาติของท่านกินยาด้วยค่ะ",
  //     );
  //   }
  // }

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
    // medicineInfoState.notifyServices.value.inintializeNotification(
    //   onDidReceiveNotificationAndroid: onDidReceiveNotificationAndroid,
    //   onDidReceiveNotificationIOS: onDidReceiveLocalNotificationIOS,
    // );
    // medicineInfoState.notifyServices.value.requestPermission();
    selectedStartNotifyDateController.text = DateFormat.yMMMd('th_TH')
        .formatInBuddhistCalendarThai(widget.selectedDate);
    selectedEndNotifyDateController.text = DateFormat.yMMMd('th_TH')
        .formatInBuddhistCalendarThai(widget.selectedDate);
    notifyInformation.startDate = widget.selectedDate;
    notifyInformation.endDate = widget.selectedDate;
    if (widget.medicineData != null) setMedicineState(widget.medicineData!);
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

  setMedicineState(MedicineInfo medicineData) {
    notifyInformation.selectedMedicine = MedicineInformation(
        name: medicineData.name,
        description: medicineData.description,
        type: medicineData.type,
        unit: medicineData.unit,
        order: medicineData.order,
        nTake: medicineData.nTake,
        periodTime: medicineData.period_time,
        picturePath: medicineData.picture_path,
        color: medicineData.color,
        id: medicineData.id);

    if (medicineData.period_time[0]) {
      notifyInformation.morningTime = const TimeOfDay(hour: 8, minute: 0);
      notifyMorningTimeController.text = "8:00 AM";
      //notifyInformation.morningTime!.hourOfPeriod;
    } else {
      notifyInformation.morningTime = null;
      notifyMorningTimeController.text = "";
    }
    if (medicineData.period_time[1]) {
      notifyInformation.lunchTime = const TimeOfDay(hour: 12, minute: 0);
      notifyLunchTimeController.text = "12:00 PM";
      //notifyInformation.lunchTime!.format(context);
    } else {
      notifyInformation.lunchTime = null;
      notifyLunchTimeController.text = "";
    }

    if (medicineData.period_time[2]) {
      notifyInformation.eveningTime = const TimeOfDay(hour: 17, minute: 0);
      notifyEveningTimeController.text = "5:00 PM";
      //notifyInformation.eveningTime!.format(context);
    } else {
      notifyInformation.eveningTime = null;
      notifyEveningTimeController.text = "";
    }

    if (medicineData.period_time[3]) {
      notifyInformation.beforeToBedTime = const TimeOfDay(hour: 21, minute: 0);
      notifyBeforetoBedTimeController.text = "9:00 PM";
      //notifyInformation.beforeToBedTime!.format(context);
    } else {
      notifyInformation.beforeToBedTime = null;
      notifyBeforetoBedTimeController.text = "";
    }

    // update text controller
    selectedMedicineController.text = medicineData.name;
  }

  //เลือกรายการยา
  selectMedicineItem() async {
    var result = await Get.to(
      () => const ToChooseMedicine(),
      binding: AppInfoBinding(),
    );
    // update field after choose
    if (result != null) {
      setState(() {
        setMedicineState(result);
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

  autofillName(NotifyInformation notifyInfo) {
    String autoName = "<type>ยา";
    switch (notifyInfo.selectedMedicine!.type) {
      case "pills":
      case "water":
        autoName = autoName.replaceAll("<type>", "กิน");
        break;
      case "arrow":
        autoName = autoName.replaceAll("<type>", "ฉีด");
        break;
      case "drop":
        autoName = autoName.replaceAll("<type>", "หยอด");
        break;
    }
    return "$autoName ${notifyInfo.selectedMedicine!.name}";
  }

  autofillDetail(NotifyInformation notifyInfo) {
    String autoDetail = notifyInfo.selectedMedicine!.description == null ||
            notifyInfo.selectedMedicine!.description!.isEmpty
        ? "ไม่ระบุรายละเอียดยา"
        : notifyInfo.selectedMedicine!.description!;
    return autoDetail;
  }

  // ตกลง
  makeNotify() async {
    // notify Init
    await notifyInit();

    // notification List
    var startDate = cleanTimeOfDay(notifyInformation.startDate!);
    var endDate = cleanTimeOfDay(notifyInformation.endDate!);
    var days = endDate.difference(startDate).inDays + 1;

    var notifyState = Get.find<NotificationState>();

    if (notifyInformation.enableMorningTime) {
      generateNotifySchedule(
        notifyService: notifyState.medicineNotification.value,
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
        notifyService: notifyState.medicineNotification.value,
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
        notifyService: notifyState.medicineNotification.value,
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
        notifyService: notifyState.medicineNotification.value,
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
    Get.back(result: true);
  }

  // generate notify schedule
  generateNotifySchedule({
    required DateTime startDate,
    required int nDate,
    required List<bool> periodDays,
    required TimeOfDay scheduleTime,
    required NotifyService notifyService,
  }) async {
    var date = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      scheduleTime.hour,
      scheduleTime.minute,
    );

    var now = DateTime.now();

    var boxNotify = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
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
            notifyService: notifyService,
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
              notifyService: notifyService,
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
              notifyService: notifyService,
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
              notifyService: notifyService,
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
              notifyService: notifyService,
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
              notifyService: notifyService,
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
              notifyService: notifyService,
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
              notifyService: notifyService,
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
    required NotifyService notifyService,
  }) async {
    var notifyData = NotifyInfoModel(
      name: notifyNameController.text.isNotEmpty
          ? notifyNameController.text
          : autofillName(notifyInformation),
      description: notifyDetailController.text.isNotEmpty
          ? notifyDetailController.text
          : autofillDetail(notifyInformation),
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
      notifyService: notifyService,
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
      required int numNotify,
      required NotifyService notifyService}) async {
    await notifyService.scheduleNotify(
      channelID: "Medicine Notify",
      channelName: "Medicine",
      channelDescription: "Medicine Notification for user",
      notifyID: id,
      notifyTitle: notifyNameController.text,
      notifyDetail: notifyDetailController.text,
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

  TextStyle get periodDayTextStyly {
    return const TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
  }

  Future<void> notifyInit() async {
    var notifyState = Get.find<NotificationState>();
    // await notifyState.medicineNotification.value.inintializeNotification(
    //     onDidReceiveNotificationIOS: onDidReceiveLocalNotificationIOS,
    //     onDidReceiveNotificationAndroid: onDidReceiveNotificationAndroid);
    await notifyState.medicineNotification.value.inintializeNotification(
        onDidReceiveNotificationIOS: null,
        onDidReceiveNotificationAndroid:
            NotificationHandeling.medicineOnDidReceiveNotificationAndroid);
    await notifyState.medicineNotification.value.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    //if (widget.medicineData != null) setMedicineState(widget.medicineData!);
    // initial notify
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
              MedicineSelectedCard(
                medicineSelected:
                    notifyInformation.selectedMedicine!.asMedicineInfo(),
              ),
              TextInputEditor(
                controller: notifyNameController,
                labelText: 'รายการแจ้งเตือน',
              ),
              TextInputEditor(
                controller: notifyDetailController,
                labelText: 'รายละเอียดการแจ้งเตือน',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
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
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
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
                            Get.back(result: false);
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

class TextInputEditor extends StatelessWidget {
  const TextInputEditor({
    super.key,
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelText: labelText,
        ),
      ),
    );
  }
}

class MedicineSelectedCard extends StatelessWidget {
  const MedicineSelectedCard({
    super.key,
    required this.medicineSelected,
  });
  final MedicineInfo medicineSelected;

  final String emptyPicture = "assets/images/dummy_picture.jpg";

  _displayPrefixType(String type) {
    if (type == "pills" || type == "water") {
      return "รับประทาน";
    } else if (type == "arrow") {
      return "ใช้ฉีด";
    } else if (type == "drop") {
      return "ใช้หยด";
    }
  }

  _displayEatOrder(String order) {
    if (order == "before") {
      return "ก่อนอาหาร";
    } else if (order == "after") {
      return "หลังอาหาร";
    }
  }

  _displayPeriodTime(List<bool> periodTime) {
    List<String> display = [];
    if (periodTime[0]) {
      display.add("เช้า");
    }
    if (periodTime[1]) {
      display.add("กลางวัน");
    }
    if (periodTime[2]) {
      display.add("เย็น");
    }
    if (periodTime[3]) {
      display.add("ก่อนนอน");
    }
    if (display.isNotEmpty) {
      return display.join(", ");
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        left: 3,
        right: 3,
      ),
      child: SizedBox(
        child: Card(
          color: Color(medicineSelected.color),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: medicineSelected.picture_path != '' &&
                          medicineSelected.picture_path != null
                      ? Image.file(
                          File(medicineSelected.picture_path!),
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        )
                      : Image.asset(
                          "assets/images/dummy_picture.jpg",
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicineSelected.name,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        medicineSelected.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                              "${_displayPrefixType(medicineSelected.type)}   ${medicineSelected.nTake.toFraction()}"),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(medicineSelected.unit)
                        ],
                      ),
                      medicineSelected.order != ""
                          ? Text(_displayEatOrder(medicineSelected.order))
                          : Container(),
                      Text(_displayPeriodTime(medicineSelected.period_time)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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
              child: AutoSizeText(
                text,
                style: periodDayTextStyly(isSelected),
                maxLines: 1,
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
    this.title,
    required this.hintText,
    this.controller,
    this.widget,
  });

  final String? title;
  final String hintText;
  final TextEditingController? controller;
  final Widget? widget;

  //
  TextStyle get titleStyle {
    return const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
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
          title != null
              ? AutoSizeText(
                  title!,
                  style: titleStyle,
                  maxLines: 1,
                )
              : Container(),
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
