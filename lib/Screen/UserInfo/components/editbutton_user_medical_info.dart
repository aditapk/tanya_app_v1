import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tanya_app_v1/utils/user_info_utils.dart';

import '../../../Model/user_info_model.dart';

class EditButtonUserMedicalInfo extends StatelessWidget {
  const EditButtonUserMedicalInfo({
    super.key,
    required this.userInfo,
    required this.onPressed,
    required this.showcaseKey,
  });

  final UserInfo? userInfo;
  final Function()? onPressed;
  final GlobalKey showcaseKey;

  checkMedicalInfo(UserInfo? userInfo) {
    if (userInfo != null) {
      if (UserInfoUtils.isNullMedicalInfo(userInfo)) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showcaseKey,
      targetBorderRadius: BorderRadius.circular(20),
      description: checkMedicalInfo(userInfo)
          ? "แก้ไขข้อมูลสุขภาพ"
          : "เพิ่มข้อมูลสุขภาพ",
      child: GestureDetector(
        onTap: onPressed,
        child: CircleAvatar(
          backgroundColor: Colors.white54,
          radius: 20,
          child: checkMedicalInfo(userInfo)
              ? const Icon(Icons.edit)
              : const Icon(Icons.add),
        ),
      ),
    );
    // ElevatedButton(
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: Colors.blue.shade400,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(12),
    //     ),
    //   ),
    //   onPressed: onPressed,
    //   child: Text(checkMedicalInfo(userInfo) ? 'แก้ไข' : 'เพิ่ม'),
    // );
  }
}
