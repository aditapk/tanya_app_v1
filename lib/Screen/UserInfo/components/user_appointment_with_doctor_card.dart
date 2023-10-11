import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tanya_app_v1/Screen/UserInfo/components/header_widget.dart';

import '../../../Model/user_info_model.dart';
import 'appointment_with_doctor_info.dart';
import 'doctor_appointment_editor.dart';

class UserAppointmentWithDoctorCard extends StatelessWidget {
  const UserAppointmentWithDoctorCard({
    super.key,
    required this.userInfo,
    required this.showcaseKey,
  });
  final UserInfo? userInfo;
  final GlobalKey showcaseKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(
          userInfo: userInfo,
          color: Colors.green.shade200,
          text: 'ข้อมูลนัดพบแพทย์',
          editButton: DoctorAppointmentAddingButton(
            showcaseKey: showcaseKey,
          ),
        ),
        const AppointmentWithDoctorInfo(),
      ],
    );
  }
}

class DoctorAppointmentAddingButton extends StatelessWidget {
  const DoctorAppointmentAddingButton({
    super.key,
    required this.showcaseKey,
  });

  final GlobalKey showcaseKey;
  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showcaseKey,
      targetBorderRadius: BorderRadius.circular(20),
      description: "เพิ่มข้อมูลนัดพบแพทย์",
      child: GestureDetector(
        onTap: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Center(
                    child: Text(
                      'เพิ่มข้อมูลนัดพบแพทย์',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  content: const SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DoctorAppointmentEditor(),
                  ),
                );
              });
        },
        child: const CircleAvatar(
          backgroundColor: Colors.white54,
          radius: 20,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
