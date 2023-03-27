import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Model/user_info_model.dart';
import 'components/user_appointment_with_doctor_card.dart';
import 'components/user_info_card.dart';
import 'components/user_medical_info_card.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<UserInfo>('user_info').listenable(),
      builder: (_, userInfoBox, __) {
        var userInfo = userInfoBox.get(0);
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  UserInfoCard(userInfo: userInfo),
                  UserMedicalInfoCard(userInfo: userInfo),
                  const UserAppointmentWithDoctorCard(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
