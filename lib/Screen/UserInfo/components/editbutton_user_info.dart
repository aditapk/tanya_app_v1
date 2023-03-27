import 'package:flutter/material.dart';
import '../../../Model/user_info_model.dart';

class EditButtonUserInfo extends StatelessWidget {
  EditButtonUserInfo({
    super.key,
    required this.userInfo,
    required this.onPressed,
  });

  final UserInfo? userInfo;
  Function()? onPressed;

  checkPersonalInfo(UserInfo? userInfo) {
    if (userInfo != null) {
      if (userInfo.name != null ||
          userInfo.address != null ||
          userInfo.doctorName != null) {
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
        child: checkPersonalInfo(userInfo)
            ? const Icon(Icons.edit)
            : const Icon(Icons.add),
      ),
    );
    // ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: Colors.blue.shade400,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(25),
    //       ),
    //     ),
    //     onPressed: onPressed,
    //     child: checkPersonalInfo(userInfo)
    //         ? Center(
    //             child: Icon(
    //             Icons.edit_document,
    //             color: Colors.black,
    //           ))
    //         : Center(child: Icon(Icons.add))
    //     //Text(checkPersonalInfo(userInfo) ? 'แก้ไข' : 'เพิ่ม'),
    //     );
  }
}
