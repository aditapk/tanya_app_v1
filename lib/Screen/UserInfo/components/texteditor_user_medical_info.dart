import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../Model/user_info_model.dart';
import 'texteditor_user_info.dart';

class TextFieldUserMedicalInfo extends StatefulWidget {
  const TextFieldUserMedicalInfo({this.userInfo, super.key});
  final UserInfo? userInfo;

  @override
  State<TextFieldUserMedicalInfo> createState() =>
      _TextFieldUserMedicalInfoState();
}

class _TextFieldUserMedicalInfoState extends State<TextFieldUserMedicalInfo> {
  TextEditingController weightTextController = TextEditingController();
  TextEditingController hightTextController = TextEditingController();
  TextEditingController pressureHighTextController = TextEditingController();
  TextEditingController pressureLowTextController = TextEditingController();

  isInt(double num) {
    if (num % 1 == 0) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.userInfo != null) {
      if (widget.userInfo!.weight != null) {
        if (isInt(widget.userInfo!.weight!)) {
          weightTextController.text =
              widget.userInfo!.weight!.toInt().toString();
        } else {
          weightTextController.text = widget.userInfo!.weight.toString();
        }
      }
      if (widget.userInfo!.hight != null) {
        if (isInt(widget.userInfo!.hight!)) {
          hightTextController.text = widget.userInfo!.hight!.toInt().toString();
        } else {
          hightTextController.text = widget.userInfo!.hight.toString();
        }
      }
      if (widget.userInfo!.pressure != null) {
        pressureLowTextController.text =
            widget.userInfo!.pressure!.split('/')[0];
        pressureHighTextController.text =
            widget.userInfo!.pressure!.split('/')[1];
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
            'น้ำหนัก (กิโลกรัม)',
            style: TextFieldUserInfo.textHeaderStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: weightTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'ยังไม่ระบุ',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'ส่วนสูง (เซนติเมตร)',
            style: TextFieldUserInfo.textHeaderStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: hightTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'ยังไม่ระบุ',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'ความดันโลหิต (มิลลิเมตร ปรอท)',
            style: TextFieldUserInfo.textHeaderStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: pressureLowTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'ยังไม่ระบุ',
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: pressureHighTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'ยังไม่ระบุ',
                  ),
                ),
              ),
            ],
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
                  if (widget.userInfo != null) {
                    // have init info
                    widget.userInfo!.weight =
                        double.parse(weightTextController.text);
                    widget.userInfo!.hight =
                        double.parse(hightTextController.text);
                    widget.userInfo!.pressure =
                        '${pressureLowTextController.text}/${pressureHighTextController.text}';
                    widget.userInfo!.lastUpdate = DateTime.now();

                    await widget.userInfo!.save();
                  } else {
                    // not have init info
                    var userInfoBox = Hive.box<UserInfo>('user_info');
                    var userInfo = userInfoBox.get(0);
                    if (userInfo != null) {
                      userInfo.weight = double.parse(weightTextController.text);
                      userInfo.hight = double.parse(hightTextController.text);
                      userInfo.pressure =
                          '${pressureLowTextController.text}/${pressureHighTextController.text}';
                      userInfo.lastUpdate = DateTime.now();
                      await userInfo.save();
                    } else {
                      UserInfo userNewInfo = UserInfo(
                        weight: double.parse(weightTextController.text),
                        hight: double.parse(hightTextController.text),
                        pressure:
                            '${pressureLowTextController.text}/${pressureHighTextController.text}',
                        lastUpdate: DateTime.now(),
                      );
                      await userInfoBox.add(userNewInfo);
                    }
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
