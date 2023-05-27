import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/Model/doctor_appointment.dart';
import 'package:tanya_app_v1/Services/notification_handling.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';

import '../../../Services/notify_services.dart';

class DoctorAppointmentEditor extends StatefulWidget {
  const DoctorAppointmentEditor({super.key});

  @override
  State<DoctorAppointmentEditor> createState() =>
      _DoctorAppointmentEditorState();
}

class _DoctorAppointmentEditorState extends State<DoctorAppointmentEditor> {
  TextEditingController dateTextController = TextEditingController();
  TextEditingController timeTextController = TextEditingController();
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  NotifyService appointmentService = NotifyService();

  // void onDidReceiveLocalNotificationIOS(
  //     int id, String? title, String? body, String? payload) async {
  //   // ignore: todo
  //   //print("$id, $title");
  // }

  // createNewDoctorAppointmentNotification(dynamic payload) {
  //   int appointmentID = payload['id'];
  //   var appointmentDateTime = DateTime.parse(payload['appointmentDateTime']);
  //   int delayDays = payload['delayDays'];
  //   var dateDisplay = payload['dateDisplay'];
  //   var timeDisplay = payload['timeDisplay'];

  //   if (delayDays == 1) {
  //     return;
  //   }
  //   switch (delayDays) {
  //     case 7:
  //       delayDays = 3; // notify before 3 day
  //       break;
  //     case 3:
  //       delayDays = 1; // notify before 1 day
  //       break;
  //   }
  //   // set notify again
  //   DateTime notifyTime =
  //       appointmentDateTime.subtract(Duration(days: delayDays)); // test

  //   setAppointmentNotify(
  //     notifyID: appointmentID,
  //     notifyTime: notifyTime,
  //     appointmentTime: appointmentDateTime,
  //     delayDays: delayDays,
  //     dateDisplay: dateDisplay,
  //     timeDisplay: timeDisplay,
  //   );
  // }

  // void onDidReceiveNotificationAndroid(
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
  //       //var notifyID = getNotifyID(notificationResponse.payload!);
  //       //Get.to(() => NotifyHandleScreen(
  //       //      notifyID: notifyID,
  //       //    ));
  //       var payload = jsonDecode(notificationResponse.payload!);
  //       var dateDisplay = payload['dateDisplay'];
  //       var timeDisplay = payload['timeDisplay'];
  //       Get.defaultDialog(
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
  //                   onPressed: () {
  //                     createNewDoctorAppointmentNotification(payload);
  //                     Get.back();
  //                   },
  //                   child: const Text(
  //                     'แจ้งเตือนอีกครั้ง',
  //                     style: TextStyle(fontSize: 18),
  //                   ),
  //                 ),
  //                 TextButton(
  //                     onPressed: () {
  //                       Get.back();
  //                     },
  //                     child: const Text(
  //                       'ไม่ต้องแจ้งเตือน',
  //                       style: TextStyle(fontSize: 18),
  //                     )),
  //               ],
  //             ),
  //           ));
  //       break;
  //     case NotificationResponseType.selectedNotificationAction:
  //       // ignore: todo

  //       // When action on notification is clicked
  //       //print(notificationResponse.actionId);
  //       //print(notificationResponse.payload);
  //       // var notifyID = getNotifyID(notificationResponse.payload!);
  //       // var notifyBox = Hive.box<NotifyInfoModel>('user_notify_info');
  //       // var notifyInfo = notifyBox.getAt(notifyID);
  //       if (notificationResponse.actionId == "OK") {
  //         // // notify status -> complete
  //         // notifyInfo!.status = 0;
  //         // notifyInfo.save();
  //         //print(notificationResponse.payload);
  //       }
  //       if (notificationResponse.actionId == "PENDING") {
  //         //print(notificationResponse.payload);
  //         var payload = jsonDecode(notificationResponse.payload!);
  //         createNewDoctorAppointmentNotification(payload);
  //       }
  //       break;
  //   }
  // }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();

    super.initState();
  }

  Future<int> updateToDatabase(DateTime appointmentDateTime) async {
    var doctorAppointmentBox =
        Hive.box<DoctorAppointMent>(HiveDatabaseName.DOCTOR_APPOINMENT_INFO);
    int appointmendID = await doctorAppointmentBox.add(
        DoctorAppointMent(appointmentTime: appointmentDateTime, notifyID: 0));
    var doctorAppointment = doctorAppointmentBox.get(appointmendID);
    doctorAppointment!.notifyID = appointmendID;
    await doctorAppointment.save();
    return appointmendID;
  }

  @override
  Widget build(BuildContext context) {
    dateTextController.text = DateFormat.yMMMMEEEEd('th_TH')
        .formatInBuddhistCalendarThai(selectedDate);
    timeTextController.text = selectedTime.format(context);
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'วันนัดหมาย',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: TextFormField(
              readOnly: true,
              controller: dateTextController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () async {
                    //get date
                    DateTime? pickerDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2032),
                    );
                    if (pickerDate != null) {
                      setState(() {
                        dateTextController.text = DateFormat.yMMMMEEEEd('th_TH')
                            .formatInBuddhistCalendarThai(pickerDate);
                        selectedDate = pickerDate;
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'วันที่',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'เวลานัดหมาย',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: TextFormField(
              readOnly: true,
              controller: timeTextController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () async {
                    //get time
                    final TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (newTime != null) {
                      setState(() {
                        timeTextController.text = newTime.format(context);
                        selectedTime = newTime;
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.access_alarm_outlined,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'เวลา',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  DateTime appointmentDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  //if (appointmentDateTime.isAfter(DateTime.now())) {
                  String appointmentDate = DateFormat.yMMMMEEEEd('th')
                      .formatInBuddhistCalendarThai(appointmentDateTime);
                  String appointmentTime = TimeOfDay(
                          hour: appointmentDateTime.hour,
                          minute: appointmentDateTime.minute)
                      .format(context);

                  // init notification
                  await appointmentService.inintializeNotification(
                      onDidReceiveNotificationIOS: null,
                      onDidReceiveNotificationAndroid: NotificationHandeling
                          .appointmentOnDidReceiveNotificationAndroid);

                  int delayDays = 7;
                  var notifyTime = appointmentDateTime
                      .subtract(Duration(minutes: delayDays));

                  if (notifyTime.isAfter(DateTime.now())) {
                    int appointmentID =
                        await updateToDatabase(appointmentDateTime);
                    await NotificationHandeling.setAppointmentNotify(
                      notifyService: appointmentService,
                      notifyID: appointmentID,
                      notifyTime: notifyTime,
                      appointmentTime: appointmentDateTime,
                      delayDays: delayDays,
                      dateDisplay: appointmentDate,
                      timeDisplay: appointmentTime,
                    );
                    Get.back();
                  } else {
                    Get.defaultDialog(
                        title: 'วันนัดหมายไม่ถูกต้อง',
                        content: Text(
                            'กรุณากำหนดวันนัดหมายล่วงหน้า\nอย่างน้อย 7 วัน \nวันที่ ${DateFormat.yMMMd('th').formatInBuddhistCalendarThai(DateTime.now().add(const Duration(days: 8)))} เป็นต้นไป'));
                  }
                },
                child: const Text(
                  'บันทึกนัดหมาย',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
