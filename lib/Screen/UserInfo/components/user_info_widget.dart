import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tanya_app_v1/utils/constans.dart';
import 'package:tanya_app_v1/utils/user_info_utils.dart';

import '../../../Model/user_info_model.dart';
import 'editbutton_user_info.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<UserInfo>(HiveDatabaseName.USER_INFO).listenable(),
      builder: (_, userInfoBox, __) {
        if (userInfoBox.values.isEmpty) {
          return const EmptyDataUserInfoWidget();
        } else {
          var userInfo = userInfoBox.get(0);
          if (!UserInfoUtils.isNullPersonalInfo(userInfo)) {
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserInfoDetail(userInfo: userInfo),
                ],
              ),
            );
          } else {
            return const EmptyDataUserInfoWidget();
          }
        }
      },
    );
  }
}

class EmptyDataUserInfoWidget extends StatelessWidget {
  const EmptyDataUserInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: const Center(
        child: Text(
          'ยังไม่ได้ระบุข้อมูลทั่วไป',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class UserInfoDetail extends StatelessWidget {
  const UserInfoDetail({
    super.key,
    required this.userInfo,
  });

  final UserInfo? userInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DisplayText(tag: "ชื่อ", value: userInfo?.name),
            DisplayText(tag: "ที่อยู่", value: userInfo?.address),
            DisplayText(tag: "แพทย์ผู้รักษา", value: userInfo?.doctorName),
            // RichText(
            //   text: TextSpan(
            //     text: 'ชื่อ ',
            //     style: const TextStyle(
            //         color: Colors.black,
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold),
            //     children: [
            //       TextSpan(
            //         text: userInfo?.name,
            //         style: const TextStyle(
            //           fontWeight: FontWeight.normal,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // RichText(
            //   text: TextSpan(
            //     text: 'ที่อยู่ ',
            //     style: const TextStyle(
            //         color: Colors.black,
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold),
            //     children: [
            //       TextSpan(
            //         text: userInfo?.address,
            //         style: const TextStyle(
            //           fontWeight: FontWeight.normal,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // RichText(
            //   text: TextSpan(
            //     text: 'แพทย์ผู้รักษา ',
            //     style: const TextStyle(
            //         color: Colors.black,
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold),
            //     children: [
            //       TextSpan(
            //         text: userInfo?.doctorName,
            //         style: const TextStyle(
            //           fontWeight: FontWeight.normal,
            //         ),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class DisplayText extends StatelessWidget {
  const DisplayText({
    super.key,
    required this.tag,
    required this.value,
  });
  final String tag;
  final String? value;
  @override
  Widget build(BuildContext context) {
    return value != null
        ? RichText(
            text: TextSpan(
              text: '$tag ',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}

class UserInfoHeader extends StatelessWidget {
  const UserInfoHeader({
    super.key,
    required this.userInfo,
    required this.onPressed,
    required this.color,
    required this.text,
    required this.showcaseKey,
  });

  final GlobalKey showcaseKey;

  bool checkExistUser() {
    var userInfoBox = Hive.box<UserInfo>(HiveDatabaseName.USER_INFO);
    if (userInfoBox.get(0) != null) {
      return true;
    } else {
      return false;
    }
  }

  final Function()? onPressed;
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
            EditButtonUserInfo(
              showcaseKey: showcaseKey,
              onPressed: onPressed,
              userInfo: userInfo,
            ),
          ],
        ),
      ),
    );
  }
}
