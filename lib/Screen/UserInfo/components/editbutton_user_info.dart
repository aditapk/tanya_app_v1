import 'package:flutter/material.dart';
import '../../../Model/user_info_model.dart';

class EditButtonUserInfo extends StatelessWidget {
  const EditButtonUserInfo({
    super.key,
    required this.userInfo,
    required this.onPressed,
  });

  final UserInfo? userInfo;
  final Function()? onPressed;

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
  }
}
