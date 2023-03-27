import 'package:flutter/material.dart';

import '../../../Model/user_info_model.dart';

class EditButtonUserMedicalInfo extends StatelessWidget {
  EditButtonUserMedicalInfo({
    super.key,
    required this.userInfo,
    required this.onPressed,
  });

  final UserInfo? userInfo;
  Function()? onPressed;

  checkMedicalInfo(UserInfo? userInfo) {
    if (userInfo != null) {
      if (userInfo.weight != null ||
          userInfo.hight != null ||
          userInfo.pressure != null) {
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        backgroundColor: Colors.white54,
        radius: 20,
        child: checkMedicalInfo(userInfo)
            ? const Icon(Icons.edit)
            : const Icon(Icons.add),
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
