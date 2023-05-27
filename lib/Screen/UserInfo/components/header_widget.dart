import 'package:flutter/material.dart';

import '../../../Model/user_info_model.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.userInfo,
    required this.color,
    required this.text,
    required this.editButton,
  });

  final Widget editButton;

  // bool checkExistUser() {
  //   var userInfoBox = Hive.box<UserInfo>(HiveDatabaseName.USER_INFO);
  //   if (userInfoBox.get(0) != null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  final UserInfo? userInfo;
  final Color? color;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        color: color ?? Colors.blue.shade200,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            editButton,
          ],
        ),
      ),
    );
  }
}
