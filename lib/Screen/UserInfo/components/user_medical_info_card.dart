import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/user_info_model.dart';
import 'editbutton_user_medical_info.dart';
import 'texteditor_user_medical_info.dart';
import 'user_medical_info.dart';

class UserMedicalInfoCard extends StatelessWidget {
  const UserMedicalInfoCard({
    super.key,
    required this.userInfo,
  });

  final UserInfo? userInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 2,
        color: Colors.yellow.shade200,
        child: Stack(
          children: [
            const UserMedicalInfo(),
            Positioned(
              top: 8,
              right: 8,
              child: EditButtonUserMedicalInfo(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        title: const Center(
                          child: Text(
                            'ระบุข้อมูลสุขภาพ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        content: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: TextFieldUserMedicalInfo(
                            userInfo: userInfo,
                          ),
                        ),
                      );
                    },
                  );
                },
                userInfo: userInfo,
              ),
            ),
            const SizedBox(
              height: 8.0,
            )
          ],
        ),
      ),
    );
  }
}
