//import 'dart:html';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // for datetime formatting
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'dart:math';

import '../../../Services/notify_services.dart';
import '../../MedicineInformation/to_choose_medicine_info_list.dart';
import '../notify_handle_screen.dart'; // for random variable

class AddNotifyDetailScreen extends StatefulWidget {
  AddNotifyDetailScreen({
    super.key,
    required this.selectedDate,
  });

  DateTime selectedDate;

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

  MedicineInfo asMedicineInfo() {
    return MedicineInfo(
        name: name!,
        description: description!,
        type: type!,
        unit: unit!,
        nTake: nTake!,
        order: order!,
        period_time: periodTime!,
        picture_path: picturePath);
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

  // test
  // List<List<String>> testNotifyTimeList = [
  //   ["เช้า"],
  //   ["เช้า", "กลางวัน"],
  //   ["เช้า", "เย็น"],
  //   ["กลางวัน", "เย็น", "ก่อนนอน"]
  // ];
  // List<TextFieldEditor> notifyTimeWidgetList = [];
  // List<DateTime> _notifyTimeList = [];
  // List<TextEditingController> _timeControllerList = [];
  // ---
  getNotifyID(String payload) {
    var notifyInfoObject = jsonDecode(payload);
    return notifyInfoObject["notifyID"];
  }

  void onDidReceiveLocalNotificationIOS(
      int id, String? title, String? body, String? payload) async {
    // TODO
    print("$id, $title");
  }

  void onDidReceiveNotificationAndroid(
      NotificationResponse notificationResponse) async {
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        // TODO: Handle this case.
        // When click on notification
        // .notificationResponseType
        // .id
        // .actonId
        // .input
        // .payload
        var notifyID = getNotifyID(notificationResponse.payload!);
        Get.to(() => NotifyHandleScreen(
              notifyID: notifyID,
            ));

        break;
      case NotificationResponseType.selectedNotificationAction:
        // TODO: Handle this case.
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
          // set notify again
          // set notification
          var date = notifyInfo!.date;
          var now = DateTime.now();
          var minuteDiff = now.difference(date).inSeconds;
          if (minuteDiff <= 35) {
            var nextDateTime = now.add(const Duration(seconds: 15));
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
          }
        }
        break;
    }
  }

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
    selectedStartNotifyDateController.text =
        DateFormat.yMd('th_TH').format(widget.selectedDate);
    selectedEndNotifyDateController.text =
        DateFormat.yMd('th_TH').format(widget.selectedDate);
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
            DateFormat.yMd('th_TH').format(pickerDate);
        notifyInformation.startDate = pickerDate;
      });

      if (pickerDate.isAfter(notifyInformation.endDate!)) {
        setState(() {
          selectedEndNotifyDateController.text =
              DateFormat.yMd('th_TH').format(pickerDate);
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
            DateFormat.yMd('th_TH').format(pickerDate);
        notifyInformation.endDate = pickerDate;
      });
      if (pickerDate.isBefore(notifyInformation.startDate!)) {
        setState(() {
          selectedStartNotifyDateController.text =
              DateFormat.yMd('th_TH').format(pickerDate);
          notifyInformation.startDate = pickerDate;
        });
      }
    }
  }

  //เลือกรายการยา
  selectMedicineItem() async {
    var result = await Get.to(
      () => ToChooseMedicine(),
      duration: Duration(seconds: 1),
      transition: Transition.leftToRightWithFade,
    );
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
            picturePath: result.picture_path);

        if (result.period_time[0]) {
          notifyInformation.morningTime = TimeOfDay(hour: 8, minute: 0);
          notifyMorningTimeController.text =
              notifyInformation.morningTime!.format(context);
        } else {
          notifyInformation.morningTime = null;
          notifyMorningTimeController.text = "";
        }
        if (result.period_time[1]) {
          notifyInformation.lunchTime = TimeOfDay(hour: 12, minute: 0);
          notifyLunchTimeController.text =
              notifyInformation.lunchTime!.format(context);
        } else {
          notifyInformation.lunchTime = null;
          notifyLunchTimeController.text = "";
        }

        if (result.period_time[2]) {
          notifyInformation.eveningTime = TimeOfDay(hour: 17, minute: 0);
          notifyEveningTimeController.text =
              notifyInformation.eveningTime!.format(context);
        } else {
          notifyInformation.eveningTime = null;
          notifyEveningTimeController.text = "";
        }

        if (result.period_time[3]) {
          notifyInformation.beforeToBedTime = TimeOfDay(hour: 21, minute: 0);
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
      generateNotifySchedule(startDate, days, notifyInformation.morningTime!);
    }
    if (notifyInformation.enableLunchTime) {
      generateNotifySchedule(startDate, days, notifyInformation.lunchTime!);
    }
    if (notifyInformation.enableEveningTime) {
      generateNotifySchedule(startDate, days, notifyInformation.eveningTime!);
    }
    if (notifyInformation.enableBeforeToBedTime) {
      generateNotifySchedule(
          startDate, days, notifyInformation.beforeToBedTime!);
    }
    Get.back();
    // schedule notification

    // write to hive database
  }

  // generate notify schedule
  generateNotifySchedule(
      DateTime startDate, int days, TimeOfDay scheduleTime) async {
    var date = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      scheduleTime.hour,
      scheduleTime.minute,
    );

    var boxNotify = Hive.box<NotifyInfoModel>('user_notify_info');
    for (int day = 0; day < days; day++) {
      // write to hive database
      var notifyData = NotifyInfoModel(
        name: notifyNameController.text,
        description: notifyDetailController.text,
        medicineInfo: notifyInformation.selectedMedicine!.asMedicineInfo(),
        date: date.add(Duration(days: day)),
        time: TimeOfDayModel(
          hour: scheduleTime.hour,
          minute: scheduleTime.minute,
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
      notifyAction: numNotify != 4
          ? const <AndroidNotificationAction>[
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
            ]
          : const <AndroidNotificationAction>[
              AndroidNotificationAction(
                'OK',
                'ตกลง',
                showsUserInterface: true,
              )
            ],
    );
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
                      hintText: DateFormat.yMd('th_TH').format(
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
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: makeNotify,
                          child: const Text('ตกลง'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('ยกเลิก'),
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

class TextFieldEditor extends StatelessWidget {
  TextFieldEditor({
    super.key,
    required this.title,
    required this.hintText,
    this.controller,
    this.widget,
  });

  String title;
  String hintText;
  TextEditingController? controller;
  Widget? widget;

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
  NotifyTimeWidget({
    super.key,
    required this.titleNotifyTime,
    required this.hintText,
    required this.onPressed,
  });

  List<String> titleNotifyTime;
  List<String> hintText;
  List<Function()?> onPressed;

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
