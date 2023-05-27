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
      child: ValueListenableBuilder(
        valueListenable:
            Hive.box<DoctorAppointMent>(HiveDatabaseName.DOCTOR_APPOINMENT_INFO)
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

            if (doctorAppointmentList.isNotEmpty) {
              return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.shade200),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                  height: 250,
                  child: ListView.builder(
                    itemCount: doctorAppointmentList.length,
                    itemBuilder: (context, index) {
                      String appointmentDate = DateFormat.yMMMMEEEEd('th')
                          .formatInBuddhistCalendarThai(
                        doctorAppointmentList[index].appointmentTime,
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
                      return ListTile(
                        title: Text(
                          '$appointmentDate \nเวลา $appointmentTime ${nDate == 0 ? '' : '($nDate วัน)'}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return const EmptyDataAppointMentWidget();
            }

            // return Padding(
            //   padding: const EdgeInsets.only(left: 8, right: 8),
            //   child: Container(
            //     padding: const EdgeInsets.all(10),
            //     width: MediaQuery.of(context).size.width,
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.green.shade200),
            //       borderRadius: const BorderRadius.only(
            //           bottomLeft: Radius.circular(12),
            //           bottomRight: Radius.circular(12)),
            //     ),
            //     height: 200,
            //     child: SingleChildScrollView(
            //       child: doctorAppointmentList.isNotEmpty
            //           ? ListView.builder(
            //               shrinkWrap: true,
            //               itemCount: doctorAppointmentList.length,
            //               itemBuilder: (context, index) {
            //                 String appointmentDate = DateFormat.yMMMMEEEEd('th')
            //                     .formatInBuddhistCalendarThai(
            //                   doctorAppointmentList[index].appointmentTime,
            //                 );
            //                 String appointmentTime = TimeOfDay(
            //                         hour: doctorAppointmentList[index]
            //                             .appointmentTime
            //                             .hour,
            //                         minute: doctorAppointmentList[index]
            //                             .appointmentTime
            //                             .minute)
            //                     .format(context);
            //                 var nDate = doctorAppointmentList[index]
            //                     .appointmentTime
            //                     .difference(DateTime.now())
            //                     .inDays;
            //                 return SizedBox(
            //                   width: MediaQuery.of(context).size.width,
            //                   child: ListTile(
            //                     title: Text(
            //                       '$appointmentDate \nเวลา $appointmentTime ${nDate == 0 ? '' : '($nDate วัน)'}',
            //                       style: const TextStyle(fontSize: 18),
            //                     ),
            //                   ),
            //                 );
            //               },
            //             )
            //           : Container(
            //               width: MediaQuery.of(context).size.width,
            //               decoration: BoxDecoration(
            //                 border: Border.all(color: Colors.pink.shade200),
            //                 borderRadius: const BorderRadius.only(
            //                     bottomLeft: Radius.circular(12),
            //                     bottomRight: Radius.circular(12)),
            //               ),
            //               child: const Padding(
            //                 padding: EdgeInsets.only(top: 10),
            //                 child: Center(
            //                   child: Text(
            //                     'ยังไม่มีรายการนัดหมายล่วงหน้า',
            //                     style: TextStyle(fontSize: 16),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //     ),
            //   ),
            // );
          }
          return const EmptyDataAppointMentWidget();
        },
      ),
    );
  }
}

class EmptyDataAppointMentWidget extends StatelessWidget {
  const EmptyDataAppointMentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green.shade200),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text(
            'ยังไม่มีการนัดพบแพทย์',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
