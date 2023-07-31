import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tanya_app_v1/utils/user_info_utils.dart';
import '../../../Model/user_info_model.dart';

class EditButtonUserInfo extends StatelessWidget {
  const EditButtonUserInfo({
    super.key,
    required this.userInfo,
    required this.onPressed,
    required this.showcaseKey,
  });

  final UserInfo? userInfo;
  final Function()? onPressed;
  final GlobalKey showcaseKey;

  checkPersonalInfo(UserInfo? userInfo) {
    if (userInfo != null) {
      if (!UserInfoUtils.isNullPersonalInfo(userInfo)) {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Showcase(
        key: showcaseKey,
        targetBorderRadius: BorderRadius.circular(20),
        description: checkPersonalInfo(userInfo)
            ? "แก้ไขข้อมูลทั่วไป"
            : "เพิ่มข้อมูลทั่วไป",
        child: GestureDetector(
          onTap: onPressed,
          child: CircleAvatar(
            backgroundColor: Colors.white54,
            radius: 20,
            child: checkPersonalInfo(userInfo)
                ? const Icon(Icons.edit)
                : const Icon(Icons.add),
          ),
        ));
  }
}
