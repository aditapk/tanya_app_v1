import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/Model/doctor_appointment.dart';
import 'package:tanya_app_v1/Services/notification_handling.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';

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
  // NotifyService appointmentService = NotifyService();
  //var notifyStateController = Get.put(NotificationState());

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

  saveAppointment() async {
    DateTime appointmentDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    var now = DateTime.now();

    String appointmentDate = DateFormat.yMMMMEEEEd('th')
        .formatInBuddhistCalendarThai(appointmentDateTime);
    String appointmentTime = TimeOfDay(
            hour: appointmentDateTime.hour, minute: appointmentDateTime.minute)
        .format(context);

    // var nDays = appointmentDateTime.difference(now).inDays;
    // var nMinites = appointmentDateTime.difference(now).inMinutes;

    if (appointmentDateTime.isBefore(now)) {
      // can't notify
      Get.defaultDialog(
        title: 'วันเวลานัดหมายไม่ถูกต้อง',
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        content: const Text(
          'วันและเวลานัดหมายต้องเป็นวันและเวลาล่วงหน้า',
          textAlign: TextAlign.center,
        ),
      );
    } else {
      var tAppointmentdate = DateTime(appointmentDateTime.year,
          appointmentDateTime.month, appointmentDateTime.day, 0, 0);
      var tCurrentdate = DateTime(now.year, now.month, now.day, 0, 0);
      var nDays = tAppointmentdate.difference(tCurrentdate).inDays;

      late DateTime notifyDateTime;
      late int delays;
      if (nDays >= 7) {
        delays = 7;
        notifyDateTime = appointmentDateTime.subtract(Duration(days: delays));
      } else if (nDays >= 3 && nDays < 7) {
        delays = 3;
        notifyDateTime = appointmentDateTime.subtract(Duration(days: delays));
      } else if (nDays >= 1 && nDays < 3) {
        delays = 1;
        notifyDateTime = appointmentDateTime.subtract(Duration(days: delays));
      } else {
        delays = 1;
        notifyDateTime = appointmentDateTime;
      }

      int appointmentID = await updateToDatabase(appointmentDateTime);

      await NotificationHandeling.setAppointmentNotify(
        notifyID: appointmentID,
        notifyTime: notifyDateTime,
        appointmentTime: appointmentDateTime,
        delayDays: delays,
        dateDisplay: appointmentDate,
        timeDisplay: appointmentTime,
      );
      Get.back();
    }

    // await NotificationHandeling.setAppointmentNotify(
    //   notifyService: notifyStateController.appointmentNotification.value,
    //   notifyID: appointmentID,
    //   notifyTime: appointmentDateTime,
    //   appointmentTime: appointmentDateTime,
    //   delayDays: 1,
    //   dateDisplay: appointmentDate,
    //   timeDisplay: appointmentTime,
    // );

    // int delayDays = 7;
    // var notifyTime = appointmentDateTime.subtract(Duration(days: delayDays));

    // if (notifyTime.isAfter(DateTime.now())) {
    //   int appointmentID = await updateToDatabase(appointmentDateTime);
    //   await NotificationHandeling.setAppointmentNotify(
    //     notifyService: appointmentService,
    //     notifyID: appointmentID,
    //     notifyTime: notifyTime,
    //     appointmentTime: appointmentDateTime,
    //     delayDays: delayDays,
    //     dateDisplay: appointmentDate,
    //     timeDisplay: appointmentTime,
    //   );
    //   Get.back();
    // } else {
    //   Get.defaultDialog(
    //     title: 'วันนัดหมายไม่ถูกต้อง',
    //     titleStyle: const TextStyle(fontWeight: FontWeight.bold),
    //     content: Text(
    //       'กรุณากำหนดวันนัดหมายล่วงหน้า\nอย่างน้อย 7 วัน โดยกำหนดตั้งแต่\nวันที่ ${DateFormat.yMMMd('th').formatInBuddhistCalendarThai(DateTime.now().add(const Duration(days: 8)))} เป็นต้นไป',
    //       textAlign: TextAlign.center,
    //     ),
    //   );
    // }
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
                    color: Colors.green,
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
                    color: Colors.green,
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
                onPressed: saveAppointment,
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
