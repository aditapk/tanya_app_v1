import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tanya_app_v1/utils/constans.dart';
import '../../Model/user_info_model.dart';
import 'components/user_appointment_with_doctor_card.dart';
import 'components/user_avatar_picture.dart';
import 'components/user_info_card.dart';
import 'components/user_medical_info_card.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({
    super.key,
    required this.generalInfoShowCaseKey,
    required this.medicalInfoShowCaseKey,
    required this.appointmentInfoShowCaseKey,
  });

  final GlobalKey generalInfoShowCaseKey;
  final GlobalKey medicalInfoShowCaseKey;
  final GlobalKey appointmentInfoShowCaseKey;

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<UserInfo>(HiveDatabaseName.USER_INFO).listenable(),
      builder: (_, userInfoBox, __) {
        var userInfo = userInfoBox.get(0);
        return Column(
          children: [
            const UserAvatarPicture(),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  UserInfoCard(
                    showcaseKey: widget.generalInfoShowCaseKey,
                    userInfo: userInfo,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  UserMedicalInfoCard(
                    showcaseKey: widget.medicalInfoShowCaseKey,
                    userInfo: userInfo,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  UserAppointmentWithDoctorCard(
                    showcaseKey: widget.appointmentInfoShowCaseKey,
                    userInfo: userInfo,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
