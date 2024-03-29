import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Model/user_info_model.dart';
import 'editbutton_user_info.dart';
import 'header_widget.dart';
import 'texteditor_user_info.dart';
import 'user_info_widget.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.userInfo,
    required this.showcaseKey,
  });

  final UserInfo? userInfo;
  final GlobalKey showcaseKey;

  editUserInfo() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Center(
              child: Text(
            'ระบุข้อมูลผู้ใช้',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: TextFieldUserInfo(
              userInfo: userInfo,
            ),
          ),
        );
      },
    );
  }

  // bool checkUserData() {
  //   var userInfoBox = Hive.box<UserInfo>(HiveDatabaseName.USER_INFO);
  //   if (userInfoBox.get(0) != null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(
          text: "ข้อมูลทั่วไป",
          userInfo: userInfo,
          color: Colors.blue.shade200,
          editButton: EditButtonUserInfo(
            showcaseKey: showcaseKey,
            userInfo: userInfo,
            onPressed: editUserInfo,
          ),
        ),
        const UserInfoWidget(),
      ],
    );
    // SizedBox(
    //   width: MediaQuery.of(context).size.width,
    //   child: Card(
    //     color: Colors.blue.shade100,
    //     elevation: 2,
    //     child: Column(
    //       children: [
    //         const UserAvatarPicture(),
    //         Stack(
    //           children: [
    //             const UserInfoWidget(),
    //             Positioned(
    //               top: 8,
    //               right: 8,
    //               child: EditButtonUserInfo(
    //                 userInfo: userInfo,
    //                 onPressed: () async {
    //                   showDialog(
    //                     context: context,
    //                     builder: (BuildContext context) {
    //                       return AlertDialog(
    //                         shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(20)),
    //                         title: const Center(
    //                             child: Text(
    //                           'ระบุข้อมูลผู้ใช้',
    //                           style: TextStyle(
    //                             fontSize: 20,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         )),
    //                         content: SingleChildScrollView(
    //                           scrollDirection: Axis.vertical,
    //                           child: TextFieldUserInfo(
    //                             userInfo: userInfo,
    //                           ),
    //                         ),
    //                       );
    //                     },
    //                   );
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 8,
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
