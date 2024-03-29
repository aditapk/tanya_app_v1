import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tanya_app_v1/utils/constans.dart';
import 'package:tanya_app_v1/utils/user_info_utils.dart';

import '../../../Model/user_info_model.dart';
import 'dart:math';

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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable:
                Hive.box<UserInfo>(HiveDatabaseName.USER_INFO).listenable(),
            builder: (_, userInfoBox, __) {
              var userInfo = userInfoBox.get(0);
              if (userInfo != null) {
                if (!UserInfoUtils.isNullMedicalInfo(userInfo)) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink.shade200),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                    ),
                    height: 250,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MedicalTagDisplay(
                              tag: 'น้ำหนัก',
                              value: userInfo.weight,
                              suffix: 'กิโลกรัม',
                            ),
                            MedicalTagDisplay(
                              tag: 'ส่วนสูง',
                              value: userInfo.hight,
                              suffix: 'เซนติเมตร',
                            ),
                            MedicalTagDisplay(
                              tag: 'ดัชนีมวลกาย',
                              value: userInfo.weight != null &&
                                      userInfo.hight != null
                                  ? (userInfo.weight! /
                                      pow(userInfo.hight! / 100, 2))
                                  : null,
                              suffix: 'กิโลกรัม/ตารางเมตร',
                            ),
                            MedicalTagDisplay(
                              tag: 'ความดันโลหิต',
                              value: userInfo.pressure,
                              suffix: 'มิลลิเมตร ปรอท',
                            ),
                            MedicalTagDisplay(
                              tag: 'น้ำตาลขณะอดอาหาร (FPG)',
                              value: userInfo.fPG,
                            ),
                            MedicalTagDisplay(
                              tag: 'น้ำตาลสะสม (HbA1c)',
                              value: userInfo.hbA1c,
                            ),
                            MedicalTagDisplay(
                              tag: 'ค่าไต (Creatinine)',
                              value: userInfo.creatinine,
                            ),
                            MedicalTagDisplay(
                              tag: 'อัตราการกรองของไต (GFR)',
                              value: userInfo.gFR,
                            ),
                            MedicalTagDisplay(
                              tag: 'คลอเลสเตอรอล (Total cholesteral)',
                              value: userInfo.totalCholesterol,
                            ),
                            MedicalTagDisplay(
                              tag: 'ไตรกลีเซอร์ไรด์ (Triglyceride)',
                              value: userInfo.triglyceride,
                            ),
                            MedicalTagDisplay(
                              tag: 'เอชดีแอล (HDL-c)',
                              value: userInfo.hDLc,
                            ),
                            MedicalTagDisplay(
                              tag: 'แอลดีแอล (LDL-c)',
                              value: userInfo.lDLc,
                            ),
                            MedicalTagDisplay(
                              tag: 'AST',
                              value: userInfo.aST,
                            ),
                            MedicalTagDisplay(
                              tag: 'ALT',
                              value: userInfo.aLT,
                            ),
                            MedicalTagDisplay(
                              tag: 'ALP',
                              value: userInfo.aLP,
                            ),
                            MedicalTagDisplay(
                              tag: 'T3',
                              value: userInfo.t3,
                            ),
                            MedicalTagDisplay(
                              tag: 'Free T3',
                              value: userInfo.freeT3,
                            ),
                            MedicalTagDisplay(
                              tag: 'Free T4',
                              value: userInfo.freeT4,
                            ),
                            MedicalTagDisplay(
                              tag: 'TSH',
                              value: userInfo.tSH,
                            ),
                            MedicalTagDisplay(
                              tag: 'ผลตรวจอื่นๆ',
                              value: userInfo.otherCheckup,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const EmptyHealtyWidget();
              }
              return const EmptyHealtyWidget();
            },
          )
        ],
      ),
    );
  }
}

class EmptyHealtyWidget extends StatelessWidget {
  const EmptyHealtyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pink.shade200),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'ยังไม่ได้ระบุข้อมูลสุขภาพ',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

class MedicalTagDisplay extends StatelessWidget {
  const MedicalTagDisplay(
      {super.key, required this.tag, this.suffix, required this.value});
  final String tag;
  final String? suffix;
  final dynamic value;

  isInt(double num) {
    if (num % 1 == 0) {
      return true;
    }
    return false;
  }

  isOnePrecision(double num) {
    if (num * 10 % 1 == 0) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return value != null
        ? RichText(
            text: TextSpan(
              text: '$tag: ',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: value is double
                      ? isInt(value!)
                          ? value!.toInt().toString()
                          : isOnePrecision(value!)
                              ? value!.toStringAsFixed(1)
                              : value!.toStringAsFixed(2)
                      : value!,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
                suffix != null
                    ? TextSpan(
                        text: ' $suffix',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    : const TextSpan(
                        text: '',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
              ],
            ),
          )
        : Container();
    // RichText(
    //     text: TextSpan(
    //       text: '$tag: ',
    //       style: const TextStyle(
    //         color: Colors.black,
    //         fontSize: 20,
    //         fontWeight: FontWeight.bold,
    //       ),
    //       children: const [
    //         TextSpan(
    //           text: 'ยังไม่มีข้อมูล',
    //           style: TextStyle(
    //             fontWeight: FontWeight.normal,
    //           ),
    //         )
    //       ],
    //     ),
    //   );
  }
}
