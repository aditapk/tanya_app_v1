import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../../Model/user_info_model.dart';

class UserMedicalInfo extends StatelessWidget {
  const UserMedicalInfo({super.key});

  isInt(double num) {
    if (num % 1 == 0) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: Hive.box<UserInfo>('user_info').listenable(),
              builder: (_, userInfoBox, __) {
                var userInfo = userInfoBox.get(0);
                if (userInfo != null) {
                  if (userInfo.weight != null ||
                      userInfo.hight != null ||
                      userInfo.pressure != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ข้อมูลสุขภาพ (${DateFormat.yMMMMd('th').format(
                            DateTime.now(),
                          )})',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'น้ำหนัก ',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: isInt(userInfo.weight!)
                                    ? userInfo.weight!.toInt().toString()
                                    : userInfo.weight.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const TextSpan(
                                text: ' กิโลกรัม',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'ส่วนสูง ',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: isInt(userInfo.hight!)
                                    ? userInfo.hight!.toInt().toString()
                                    : userInfo.hight!.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const TextSpan(
                                text: ' เซนติเมตร',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'ดัชนีมวลกาย ',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: (userInfo.weight! /
                                        ((userInfo.hight! / 100) *
                                            (userInfo.hight! / 100)))
                                    .toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const TextSpan(
                                text: ' กิโลกรัม/ตารางเมตร',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'ความดันโลหิต ',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: userInfo.pressure,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const TextSpan(
                                text: ' มิลลิเมตร ปรอท',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'ยังไม่มีข้อมูลสุขภาพ',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'ยังไม่มีข้อมูลสุขภาพ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
