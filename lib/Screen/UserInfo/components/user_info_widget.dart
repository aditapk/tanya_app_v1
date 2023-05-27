import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import '../../../Model/user_info_model.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable:
                  Hive.box<UserInfo>(HiveDatabaseName.USER_INFO).listenable(),
              builder: (_, userInfoBox, __) {
                if (userInfoBox.values.isEmpty) {
                  return const Center(
                    child: Text(
                      'ยังไม่มีข้อมูลผู้ใช้งาน',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                } else {
                  var userInfo = userInfoBox.get(0);
                  if (userInfo?.name != null &&
                      userInfo?.address != null &&
                      userInfo?.doctorName != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'ชื่อ ',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: userInfo?.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'ที่อยู่ ',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: userInfo?.address,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'แพทย์ผู้รักษา ',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: userInfo?.doctorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return const Center(
                      child: Text(
                    'ยังไม่มีข้อมูลผู้ใช้งาน',
                    style: TextStyle(fontSize: 20),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
