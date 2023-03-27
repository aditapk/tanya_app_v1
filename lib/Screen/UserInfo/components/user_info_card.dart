import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Model/user_info_model.dart';
import 'editbutton_user_info.dart';
import 'texteditor_user_info.dart';
import 'user_avatar_picture.dart';
import 'user_info_widget.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.userInfo,
  });

  final UserInfo? userInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.blue.shade100,
        elevation: 2,
        child: Column(
          children: [
            UserAvatarPicture(),
            Stack(
              children: [
                UserInfoWidget(),
                Positioned(
                  top: 8,
                  right: 8,
                  child: EditButtonUserInfo(
                    userInfo: userInfo,
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
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
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}
