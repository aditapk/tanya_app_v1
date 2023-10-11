import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import '../../../Model/user_info_model.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class TextFieldUserInfo extends StatefulWidget {
  static const TextStyle textHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  final UserInfo? userInfo;
  const TextFieldUserInfo({
    required this.userInfo,
    super.key,
  });

  @override
  State<TextFieldUserInfo> createState() => _TextFieldUserInfoState();
}

class _TextFieldUserInfoState extends State<TextFieldUserInfo> {
  TextEditingController nameTextController = TextEditingController();

  TextEditingController addressTextController = TextEditingController();

  TextEditingController doctorTextController = TextEditingController();

  TextEditingController lineTokenTextController = TextEditingController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    if (widget.userInfo != null) {
      if (widget.userInfo!.name != null) {
        nameTextController.text = widget.userInfo!.name!;
      }
      if (widget.userInfo!.address != null) {
        addressTextController.text = widget.userInfo!.address!;
      }
      if (widget.userInfo!.doctorName != null) {
        doctorTextController.text = widget.userInfo!.doctorName!;
      }
      if (widget.userInfo!.lineToken != null) {
        lineTokenTextController.text = widget.userInfo!.lineToken!;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ชื่อ',
            style: TextFieldUserInfo.textHeaderStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: nameTextController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'ยังไม่ระบุ',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'ที่อยู่',
            style: TextFieldUserInfo.textHeaderStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: addressTextController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: 'ยังไม่ระบุ',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'แพทย์ผู้รักษา',
            style: TextFieldUserInfo.textHeaderStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: doctorTextController,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              hintText: 'ยังไม่ระบุ',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'แจ้งเตือนผ่าน LINE (token)',
            style: TextFieldUserInfo.textHeaderStyle,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, right: 10),
                  child: TextFormField(
                    controller: lineTokenTextController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'ยังไม่ระบุ',
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      // test for send notify via http
                      Uri lineNotifyUrl =
                          Uri.https('notify-api.line.me', 'api/notify');
                      var response = await http.post(
                        lineNotifyUrl,
                        headers: {
                          "Authorization":
                              "Bearer ${lineTokenTextController.text}",
                          "Content-Type": "application/x-www-form-urlencoded",
                        },
                        body:
                            "message=\nข้อความแสดงว่าการทดสอบการแจ้งเตือนผ่าน LINE Notify สำเร็จ",
                      );
                      if (response.statusCode == 200) {
                        Get.defaultDialog(
                            title: 'ทดสอบการแจ้งเตือน', middleText: 'สำเร็จ');
                      } else {
                        Get.defaultDialog(
                            title: 'ผิดพลาด',
                            middleText: 'ทดสอบการแจ้งเตือนไม่สำเร็จ');
                      }
                    },
                    child: const AutoSizeText(
                      'ลอง',
                      maxLines: 1,
                    ),
                  ),
                ),
              ))
            ],
          ),
          TextButton(
            onPressed: () async {
              final Uri url = Uri.parse(Introduction.DOCUMENT_LINK);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                // have some problem for open url
              }
            },
            child: const Text(
              'ขั้นตอนวิธีการสร้าง LINE token',
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (widget.userInfo == null) {
                    var userInfoBox =
                        Hive.box<UserInfo>(HiveDatabaseName.USER_INFO);
                    var userInfo = userInfoBox.get(0);
                    if (userInfo != null) {
                      // case add picture before personal info
                      userInfo.name = nameTextController.text;
                      userInfo.address = addressTextController.text;
                      userInfo.doctorName = doctorTextController.text;
                      userInfo.lineToken = lineTokenTextController.text;
                      await userInfo.save();
                    } else {
                      // case add personal info before picture
                      var userInfoNew = UserInfo(
                        name: nameTextController.text.isNotEmpty
                            ? nameTextController.text
                            : null,
                        address: addressTextController.text.isNotEmpty
                            ? addressTextController.text
                            : null,
                        doctorName: doctorTextController.text.isNotEmpty
                            ? doctorTextController.text
                            : null,
                        lineToken: lineTokenTextController.text.isNotEmpty
                            ? lineTokenTextController.text
                            : null,
                      );
                      await userInfoBox.add(userInfoNew);
                    }
                  } else {
                    if (nameTextController.text.isNotEmpty) {
                      widget.userInfo!.name = nameTextController.text;
                    } else {
                      widget.userInfo!.name = null;
                    }

                    if (addressTextController.text.isNotEmpty) {
                      widget.userInfo!.address = addressTextController.text;
                    } else {
                      widget.userInfo!.address = null;
                    }

                    if (doctorTextController.text.isNotEmpty) {
                      widget.userInfo!.doctorName = doctorTextController.text;
                    } else {
                      widget.userInfo!.doctorName = null;
                    }

                    if (lineTokenTextController.text.isNotEmpty) {
                      widget.userInfo!.lineToken = lineTokenTextController.text;
                    } else {
                      widget.userInfo!.lineToken = null;
                    }

                    await widget.userInfo!.save();
                  }

                  Get.back();
                },
                child: const Text(
                  'บันทึกข้อมูล',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
