import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanya_app_v1/Screen/UserInfo/components/header_widget.dart';

import '../../../Model/user_info_model.dart';
import 'editbutton_user_medical_info.dart';
import 'texteditor_user_medical_info.dart';
import 'user_medical_info.dart';

class UserMedicalInfoCard extends StatelessWidget {
  const UserMedicalInfoCard({
    super.key,
    required this.userInfo,
    required this.showcaseKey,
  });

  final UserInfo? userInfo;
  final GlobalKey showcaseKey;

  editHealthCareData() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          HeaderWidget(
            text: "ข้อมูลสุขภาพ",
            userInfo: userInfo,
            color: Colors.pink.shade200,
            editButton: EditButtonUserMedicalInfo(
              showcaseKey: showcaseKey,
              userInfo: userInfo,
              onPressed: editHealthCareData,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: UserMedicalInfo(),
          ),
        ],
      ),
    );
  }
}
// !don't delete
// Positioned(
            //   top: 14,
            //   right: 8,
            //   child: EditButtonUserMedicalInfo(
            //     onPressed: () async {
            //       showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return AlertDialog(
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(20)),
            //             title: const Center(
            //               child: Text(
            //                 'ระบุข้อมูลสุขภาพ',
            //                 style: TextStyle(
            //                   fontSize: 20,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ),
            //             content: SingleChildScrollView(
            //               scrollDirection: Axis.vertical,
            //               child: TextFieldUserMedicalInfo(
            //                 userInfo: userInfo,
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //     userInfo: userInfo,
            //   ),
            // ),
            // const SizedBox(
            //   height: 8.0,
            // )