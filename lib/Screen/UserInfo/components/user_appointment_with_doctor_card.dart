import 'package:flutter/material.dart';

import 'appointment_with_doctor_info.dart';
import 'doctor_appointment_editor.dart';

class UserAppointmentWithDoctorCard extends StatelessWidget {
  const UserAppointmentWithDoctorCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 2,
        color: Colors.green.shade100,
        child: Stack(
          children: const [
            AppointmentWithDoctorInfo(),
            Positioned(
              top: 8,
              right: 8,
              child: DoctorAppointmentAddingButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorAppointmentAddingButton extends StatelessWidget {
  const DoctorAppointmentAddingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
