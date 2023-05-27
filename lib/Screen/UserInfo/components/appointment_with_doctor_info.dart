import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/Model/doctor_appointment.dart';
import 'package:tanya_app_v1/utils/constans.dart';

class AppointmentWithDoctorInfo extends StatelessWidget {
  const AppointmentWithDoctorInfo({
    super.key,
  });
  static const TextStyle textHeaderStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: Hive.box<DoctorAppointMent>(
                      HiveDatabaseName.DOCTOR_APPOINMENT_INFO)
                  .listenable(),
              builder: (_, doctorAppointmentBox, __) {
                if (doctorAppointmentBox.values.isNotEmpty) {
                  var doctorAppointment = doctorAppointmentBox.values;
                  var doctorAppointmentList = doctorAppointment.toList();
                  doctorAppointmentList.sort(
                    (a, b) => a.appointmentTime.compareTo(b.appointmentTime),
                  );
                  doctorAppointmentList.retainWhere((appointment) =>
                      appointment.appointmentTime.isAfter(DateTime.now()));
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ข้อมูลนัดพบแพทย์',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          doctorAppointmentList.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: doctorAppointmentList.length,
                                  itemBuilder: (context, index) {
                                    String appointmentDate =
                                        DateFormat.yMMMMEEEEd('th')
                                            .formatInBuddhistCalendarThai(
                                      doctorAppointmentList[index]
                                          .appointmentTime,
                                    );
                                    String appointmentTime = TimeOfDay(
                                            hour: doctorAppointmentList[index]
                                                .appointmentTime
                                                .hour,
                                            minute: doctorAppointmentList[index]
                                                .appointmentTime
                                                .minute)
                                        .format(context);
                                    var nDate = doctorAppointmentList[index]
                                        .appointmentTime
                                        .difference(DateTime.now())
                                        .inDays;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListTile(
                                          title: Text(
                                            '$appointmentDate \nเวลา $appointmentTime ${nDate == 0 ? '' : '($nDate วัน)'}',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          // trailing: nDate == 0
                                          //     ? const Text(
                                          //         '(วันนี้)',
                                          //         style: TextStyle(
                                          //             fontSize: 20,
                                          //             color: Colors.red),
                                          //         textAlign: TextAlign.center,
                                          //       )
                                          //     : Text(
                                          //         '(อีก $nDate วัน)',
                                          //         style: const TextStyle(
                                          //             fontSize: 20,
                                          //             color: Colors.red),
                                          //         textAlign: TextAlign.center,
                                          //       ),
                                          // IconButton(
                                          //   icon: const Icon(Icons.delete),
                                          //   onPressed: () async {
                                          //     // delete appointment
                                          //     var notifyID = doctorAppointmentBox
                                          //         .get(
                                          //             doctorAppointmentList[index]
                                          //                 .notifyID)!
                                          //         .notifyID;
                                          //     doctorAppointmentBox
                                          //         .delete(notifyID);
                                          //     // calcel notify

                                          //   },
                                          // ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Center(
                                    child: Text(
                                      'ยังไม่มีรายการนัดหมายล่วงหน้า',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'ยังไม่มีข้อมูลนัดพบแพทย์',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
