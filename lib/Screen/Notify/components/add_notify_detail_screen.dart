//import 'dart:html';

import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // for datetime formatting
import 'package:tanya_app_v1/GetXBinding/medicine_state_binding.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/Services/notification_handling.dart';
import 'package:tanya_app_v1/constants.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import '../../../Model/medicine_information.dart';
import '../../../Model/notify_information.dart';
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

class _AddNotifyDetailScreenState extends State<AddNotifyDetailScreen> {
  //int numberOfNotifyTimeItem = 0;
  //var notifyStateController = Get.put(NotificationState());

  NotifyInformation notifyInformation = NotifyInformation();
  //NotifyService notifyService = NotifyService(); // notification services
  late DateTime startDate;
  late DateTime endDate;
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

  //List<bool> peroidDateSelected = [false, true, true, true, true, true, true];
  bool periodMondaySelected = false;
  bool periodTuesdaySelected = false;
  bool periodWednesdaySelected = false;
  bool periodThursdaySelected = false;
  bool periodFridaySelected = false;
  bool periodSaturdaySelected = false;
  bool periodSundaySelected = false;

  TextStyle get titleStyle {
    return const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  void initState() {
    super.initState();

    startDate = DateTime(widget.selectedDate.year, widget.selectedDate.month,
        widget.selectedDate.day);
    endDate = DateTime(widget.selectedDate.year, widget.selectedDate.month,
        widget.selectedDate.day, 23, 59, 59);
    selectedStartNotifyDateController.text =
        DateFormat.yMMMd('th_TH').formatInBuddhistCalendarThai(startDate);
    selectedEndNotifyDateController.text =
        DateFormat.yMMMd('th_TH').formatInBuddhistCalendarThai(endDate);
    notifyInformation.startDate = startDate;
    notifyInformation.endDate = endDate;
    if (widget.medicineData != null) setMedicineState(widget.medicineData!);
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

  // เริ่มการแจ้งเตือน
  selectStartDateNotify() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: notifyInformation.startDate!,
      firstDate: DateTime(2022),
      lastDate: DateTime(2032),
    );
    if (pickerDate != null) {
      var pickerStartDate =
          DateTime(pickerDate.year, pickerDate.month, pickerDate.day, 0, 0, 0);
      setState(() {
        selectedStartNotifyDateController.text = DateFormat.yMMMd('th_TH')
            .formatInBuddhistCalendarThai(pickerStartDate);
        notifyInformation.startDate = pickerStartDate;
      });

      if (pickerDate.isAfter(notifyInformation.endDate!)) {
        setState(() {
          var tEndDate = DateTime(
              pickerDate.year, pickerDate.month, pickerDate.day, 23, 59, 59);
          selectedEndNotifyDateController.text =
              DateFormat.yMMMd('th_TH').formatInBuddhistCalendarThai(tEndDate);
          notifyInformation.endDate = tEndDate;
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
      var pickerEndDate = DateTime(
          pickerDate.year, pickerDate.month, pickerDate.day, 23, 59, 59);
      setState(() {
        selectedEndNotifyDateController.text = DateFormat.yMMMd('th_TH')
            .formatInBuddhistCalendarThai(pickerEndDate);
        notifyInformation.endDate = pickerEndDate;
      });
      if (pickerDate.isBefore(notifyInformation.startDate!)) {
        var tStartDate = DateTime(
            pickerDate.year, pickerDate.month, pickerDate.day, 0, 0, 0);
        setState(() {
          selectedStartNotifyDateController.text = DateFormat.yMMMd('th_TH')
              .formatInBuddhistCalendarThai(tStartDate);
          notifyInformation.startDate = tStartDate;
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
    //String autoName = "<type>ยา";
    String typeName = "";
    switch (notifyInfo.selectedMedicine!.type) {
      case "pills":
      case "water":
        typeName = "กิน";
        break;
      case "arrow":
        typeName = "ฉีด";
        break;
      case "drop":
        typeName = "หยด";
        break;
    }
    return "$typeNameยา ${notifyInfo.selectedMedicine!.name}";
  }

  // ตกลง
  makeNotify() async {
    // notify Init
    // var notifyService = await notifyInit();

    // notification List
    var startDate = notifyInformation.startDate!;
    var endDate = notifyInformation.endDate!;
    var days = endDate.difference(startDate).inDays + 1;

    //var notifyState = Get.find<NotificationState>();

    var notifyService = NotifyService();
    await notifyService.inintializeNotification(
      onDidReceiveNotification: NotificationHandeling.onDidReceiveNotification,
    );
    await notifyService.requestPermission(); //request permission

    if (notifyInformation.enableMorningTime) {
      generateNotifySchedule(
        notifyService: notifyService,
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
        notifyService: notifyService,
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
        notifyService: notifyService,
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
        notifyService: notifyService,
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

      //if (nextDate.isAfter(now)) {
      if (periodDays.every((selected) => selected == false)) {
        // not selected generate every days
        await generateNotifyItem(
          specificDate: nextDate,
          specificTime: scheduleTime,
          boxNotify: boxNotify,
          date: date,
          day: day,
          notifyService: notifyService,
          createNotify: nextDate.isAfter(now),
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
            createNotify: nextDate.isAfter(now),
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
            createNotify: nextDate.isAfter(now),
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
            createNotify: nextDate.isAfter(now),
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
            createNotify: nextDate.isAfter(now),
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
            createNotify: nextDate.isAfter(now),
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
            createNotify: nextDate.isAfter(now),
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
            createNotify: nextDate.isAfter(now),
          );
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
    required bool createNotify,
    required NotifyService notifyService,
  }) async {
    MedicineInfo medicineInfo =
        notifyInformation.selectedMedicine!.asMedicineInfo();
    String notifyName = notifyNameController.text.isEmpty
        ? "${_displayPrefixType(medicineInfo.type)}ยา ${medicineInfo.name}"
        : notifyNameController.text;
    String notifyDetail = notifyDetailController.text.isEmpty
        ? "อย่าลืม${_displayPrefixType(medicineInfo.type)}ยา"
        : notifyDetailController.text;

    var notifyData = NotifyInfoModel(
      name: notifyName,
      description: notifyDetail,
      medicineInfo: notifyInformation.selectedMedicine!.asMedicineInfo(),
      date: specificDate,
      time: TimeOfDayModel(
        hour: specificTime.hour,
        minute: specificTime.minute,
      ),
    );
    var notifyID = await boxNotify.add(notifyData);

    // set notification
    if (createNotify) {
      // Convert string payload
      var notifyPayload = jsonEncode({
        "channelName": "medicine",
        "notifyID": notifyID,
        "notifyInfo": notifyData.toJson(),
      });

      await notifyService.scheduleMedicineNotify(
        notifyID: notifyID,
        notifyTitle: notifyName,
        notifyDetail: notifyDetail,
        notifyPayload: notifyPayload,
        scheduleTime: date.add(
          Duration(days: day),
        ),
        imagePath: notifyData.medicineInfo.picture_path!,
      );

      // notifySet(
      //   notifyName: notifyName,
      //   notifyDetail: notifyDetail,
      //   notifyService: notifyService,
      //   id: dataId,
      //   scheduleTime: date.add(
      //     Duration(days: day),
      //   ),
      //   payload: notifyPayload,
      //   numNotify: notifyData.status,
      //   imagePath: notifyData.medicineInfo.picture_path!,
      // );
    }
  }

  _displayPrefixType(String type) {
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

  // notifySet(
  //     {required int id,
  //     required DateTime scheduleTime,
  //     String? payload,
  //     required String imagePath,
  //     required int numNotify,
  //     required NotifyService notifyService,
  //     required String notifyName,
  //     required String notifyDetail}) async {
  //   await notifyService.scheduleMedicineNotify(
  //     notifyID: id,
  //     notifyTitle: notifyName,
  //     notifyDetail: notifyDetail,
  //     notifyPayload: payload,
  //     scheduleTime: scheduleTime,
  //     notifyId: id,
  //     imagePath: imagePath,
  //   );
  // }

  TextStyle get periodDayTextStyly {
    return const TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
  }

  Future<NotifyService> notifyInit() async {
    // var notifyState = Get.find<NotificationState>();
    // await notifyState.medicineNotification.value.inintializeNotification(
    //     onDidReceiveNotificationIOS: onDidReceiveLocalNotificationIOS,
    //     onDidReceiveNotificationAndroid: onDidReceiveNotificationAndroid);
    // await notifyState.medicineNotification.value.inintializeNotification(
    //     onDidReceiveNotificationIOS: null,
    //     onDidReceiveNotificationAndroid:
    //         NotificationHandeling.medicineOnDidReceiveNotificationAndroid);
    var notifyService = NotifyService();
    await notifyService.inintializeNotification(
      onDidReceiveNotification: NotificationHandeling.onDidReceiveNotification,
    );
    await notifyService.requestPermission();

    return notifyService;
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

  _displayPrefixType(String type) {
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

  _displayEatOrder(String order) {
    if (order == "before") {
      return "ก่อนอาหาร";
    } else if (order == "after") {
      return "หลังอาหาร";
    } else {
      return "";
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
                          emptyPicture,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, top: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white70,
                    ),
                    height: 100,
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
                        Text(
                            "${_displayPrefixType(medicineSelected.type)} ครั้งละ ${medicineSelected.nTake.toFraction()} ${medicineSelected.unit}"),
                        medicineSelected.order != ""
                            ? Text(_displayEatOrder(medicineSelected.order))
                            : Container(),
                        Text(_displayPeriodTime(medicineSelected.period_time)),
                      ],
                    ),
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
            fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)
        : const TextStyle(fontSize: 13, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          color: isSelected ? Colors.blue.shade400 : Colors.white,
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
