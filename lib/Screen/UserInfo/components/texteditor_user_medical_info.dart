import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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
  TextEditingController fPGTextController = TextEditingController();
  TextEditingController hbA1cTextController = TextEditingController();
  TextEditingController creatinineTextController = TextEditingController();
  TextEditingController gFRTextController = TextEditingController();
  TextEditingController totalCholesterolTextController =
      TextEditingController();
  TextEditingController triglycerideTextController = TextEditingController();
  TextEditingController hDLcTextController = TextEditingController();
  TextEditingController lDLcTextController = TextEditingController();
  TextEditingController aSTTextController = TextEditingController();
  TextEditingController aLTTextController = TextEditingController();
  TextEditingController aLPTextController = TextEditingController();
  TextEditingController t3TextController = TextEditingController();
  TextEditingController freeT3TextController = TextEditingController();
  TextEditingController freeT4TextController = TextEditingController();
  TextEditingController tSHTextController = TextEditingController();
  TextEditingController otherCheckupTextController = TextEditingController();

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
        pressureHighTextController.text =
            widget.userInfo!.pressure!.split('/')[0];
        pressureLowTextController.text =
            widget.userInfo!.pressure!.split('/')[1];
      }
      if (widget.userInfo!.fPG != null) {
        fPGTextController.text = widget.userInfo!.fPG.toString();
      }
      if (widget.userInfo!.hbA1c != null) {
        hbA1cTextController.text = widget.userInfo!.hbA1c.toString();
      }
      if (widget.userInfo!.creatinine != null) {
        creatinineTextController.text = widget.userInfo!.creatinine.toString();
      }
      if (widget.userInfo!.gFR != null) {
        gFRTextController.text = widget.userInfo!.gFR.toString();
      }
      if (widget.userInfo!.totalCholesterol != null) {
        totalCholesterolTextController.text =
            widget.userInfo!.totalCholesterol.toString();
      }
      if (widget.userInfo!.triglyceride != null) {
        triglycerideTextController.text =
            widget.userInfo!.triglyceride.toString();
      }
      if (widget.userInfo!.hDLc != null) {
        hDLcTextController.text = widget.userInfo!.hDLc.toString();
      }
      if (widget.userInfo!.lDLc != null) {
        lDLcTextController.text = widget.userInfo!.lDLc.toString();
      }
      if (widget.userInfo!.aST != null) {
        aSTTextController.text = widget.userInfo!.aST.toString();
      }
      if (widget.userInfo!.aLT != null) {
        aLTTextController.text = widget.userInfo!.aLT.toString();
      }
      if (widget.userInfo!.aLP != null) {
        aLPTextController.text = widget.userInfo!.aLP.toString();
      }
      if (widget.userInfo!.t3 != null) {
        t3TextController.text = widget.userInfo!.t3.toString();
      }
      if (widget.userInfo!.freeT3 != null) {
        freeT3TextController.text = widget.userInfo!.freeT3.toString();
      }
      if (widget.userInfo!.freeT4 != null) {
        freeT4TextController.text = widget.userInfo!.freeT4.toString();
      }
      if (widget.userInfo!.tSH != null) {
        tSHTextController.text = widget.userInfo!.tSH.toString();
      }
      if (widget.userInfo!.otherCheckup != null) {
        otherCheckupTextController.text = widget.userInfo!.otherCheckup!;
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
          TextInputSingle(
            text: 'น้ำหนัก (กิโลกรัม)',
            controller: weightTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'ส่วนสูง (เซนติเมตร)',
            controller: hightTextController,
            multiLineSting: false,
          ),
          TextInfoDouble(
            text: 'ความดันโลหิต (มิลลิเมตร ปรอท)',
            leftController: pressureHighTextController,
            rightController: pressureLowTextController,
          ),
          TextInputSingle(
            text: 'น้ำตาลขณะอดอาหาร (FPG)',
            controller: fPGTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'น้ำตาลสะสม (HbA1c)',
            controller: hbA1cTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'ค่าไต (Creatinine)',
            controller: creatinineTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'อัตราการกรองของไต (GFR)',
            controller: gFRTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'คลอเลสเตอรอล (Total cholesterol)',
            controller: totalCholesterolTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'ไตรกลีเซอไรด์ (Triglyceride)',
            controller: triglycerideTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'เอชดีแอล (HDL-c)',
            controller: hDLcTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'แอลดีแอล (LDL-c)',
            controller: lDLcTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'AST',
            controller: aSTTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'ALT',
            controller: aLTTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'ALP',
            controller: aLPTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'T3',
            controller: t3TextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'Free T3',
            controller: freeT3TextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'Free T4',
            controller: freeT4TextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'TSH',
            controller: tSHTextController,
            multiLineSting: false,
          ),
          TextInputSingle(
            text: 'ผลตรวจอื่นๆ',
            controller: otherCheckupTextController,
            multiLineSting: true,
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
                    widget.userInfo!.lastUpdate = DateTime.now();

                    if (weightTextController.text.isNotEmpty) {
                      widget.userInfo!.weight =
                          double.parse(weightTextController.text);
                    } else {
                      widget.userInfo!.weight = null;
                    }

                    if (hightTextController.text.isNotEmpty) {
                      widget.userInfo!.hight =
                          double.parse(hightTextController.text);
                    } else {
                      widget.userInfo!.hight = null;
                    }
                    if (pressureHighTextController.text.isNotEmpty &&
                        pressureLowTextController.text.isNotEmpty) {
                      widget.userInfo!.pressure =
                          '${pressureHighTextController.text}/${pressureLowTextController.text}';
                    } else {
                      widget.userInfo!.pressure = null;
                    }

                    if (fPGTextController.text.isNotEmpty) {
                      widget.userInfo!.fPG =
                          double.parse(fPGTextController.text);
                    } else {
                      widget.userInfo!.fPG = null;
                    }
                    if (hbA1cTextController.text.isNotEmpty) {
                      widget.userInfo!.hbA1c =
                          double.parse(hbA1cTextController.text);
                    } else {
                      widget.userInfo!.hbA1c = null;
                    }
                    if (creatinineTextController.text.isNotEmpty) {
                      widget.userInfo!.creatinine =
                          double.parse(creatinineTextController.text);
                    } else {
                      widget.userInfo!.creatinine = null;
                    }
                    if (gFRTextController.text.isNotEmpty) {
                      widget.userInfo!.gFR =
                          double.parse(gFRTextController.text);
                    } else {
                      widget.userInfo!.gFR = null;
                    }
                    if (totalCholesterolTextController.text.isNotEmpty) {
                      widget.userInfo!.totalCholesterol =
                          double.parse(totalCholesterolTextController.text);
                    } else {
                      widget.userInfo!.totalCholesterol = null;
                    }
                    if (triglycerideTextController.text.isNotEmpty) {
                      widget.userInfo!.triglyceride =
                          double.parse(triglycerideTextController.text);
                    } else {
                      widget.userInfo!.triglyceride = null;
                    }
                    if (hDLcTextController.text.isNotEmpty) {
                      widget.userInfo!.hDLc =
                          double.parse(hDLcTextController.text);
                    } else {
                      widget.userInfo!.hDLc = null;
                    }
                    if (lDLcTextController.text.isNotEmpty) {
                      widget.userInfo!.lDLc =
                          double.parse(lDLcTextController.text);
                    } else {
                      widget.userInfo!.lDLc = null;
                    }
                    if (aSTTextController.text.isNotEmpty) {
                      widget.userInfo!.aST =
                          double.parse(aSTTextController.text);
                    } else {
                      widget.userInfo!.aST = null;
                    }
                    if (aLTTextController.text.isNotEmpty) {
                      widget.userInfo!.aLT =
                          double.parse(aLTTextController.text);
                    } else {
                      widget.userInfo!.aLT = null;
                    }
                    if (aLPTextController.text.isNotEmpty) {
                      widget.userInfo!.aLP =
                          double.parse(aLPTextController.text);
                    } else {
                      widget.userInfo!.aLP = null;
                    }
                    if (t3TextController.text.isNotEmpty) {
                      widget.userInfo!.t3 = double.parse(t3TextController.text);
                    } else {
                      widget.userInfo!.t3 = null;
                    }
                    if (freeT3TextController.text.isNotEmpty) {
                      widget.userInfo!.freeT3 =
                          double.parse(freeT3TextController.text);
                    } else {
                      widget.userInfo!.freeT3 = null;
                    }
                    if (freeT4TextController.text.isNotEmpty) {
                      widget.userInfo!.freeT4 =
                          double.parse(freeT4TextController.text);
                    } else {
                      widget.userInfo!.freeT4 = null;
                    }
                    if (tSHTextController.text.isNotEmpty) {
                      widget.userInfo!.tSH =
                          double.parse(tSHTextController.text);
                    } else {
                      widget.userInfo!.tSH = null;
                    }
                    if (otherCheckupTextController.text.isNotEmpty) {
                      widget.userInfo!.otherCheckup =
                          otherCheckupTextController.text;
                    } else {
                      widget.userInfo!.otherCheckup = null;
                    }

                    await widget.userInfo!.save();
                  } else {
                    // not have init info
                    var userInfoBox = Hive.box<UserInfo>('user_info');
                    var userInfo = userInfoBox.get(0);
                    if (userInfo != null) {
                      if (weightTextController.text.isNotEmpty) {
                        userInfo.weight =
                            double.parse(weightTextController.text);
                      } else {
                        userInfo.weight = null;
                      }
                      if (hightTextController.text.isNotEmpty) {
                        userInfo.hight = double.parse(hightTextController.text);
                      } else {
                        userInfo.hight = null;
                      }
                      if (pressureHighTextController.text.isNotEmpty &&
                          pressureLowTextController.text.isNotEmpty) {
                        userInfo.pressure =
                            '${pressureHighTextController.text}/${pressureLowTextController.text}';
                        userInfo.lastUpdate = DateTime.now();
                      } else {
                        userInfo.pressure = null;
                      }
                      if (fPGTextController.text.isNotEmpty) {
                        userInfo.fPG = double.parse(fPGTextController.text);
                      } else {
                        userInfo.fPG = null;
                      }
                      if (hbA1cTextController.text.isNotEmpty) {
                        userInfo.hbA1c = double.parse(hbA1cTextController.text);
                      } else {
                        userInfo.hbA1c = null;
                      }
                      if (creatinineTextController.text.isNotEmpty) {
                        userInfo.creatinine =
                            double.parse(creatinineTextController.text);
                      } else {
                        userInfo.creatinine = null;
                      }
                      if (gFRTextController.text.isNotEmpty) {
                        userInfo.gFR = double.parse(gFRTextController.text);
                      } else {
                        userInfo.gFR = null;
                      }
                      if (totalCholesterolTextController.text.isNotEmpty) {
                        userInfo.totalCholesterol =
                            double.parse(totalCholesterolTextController.text);
                      } else {
                        userInfo.totalCholesterol = null;
                      }
                      if (triglycerideTextController.text.isNotEmpty) {
                        userInfo.triglyceride =
                            double.parse(triglycerideTextController.text);
                      } else {
                        userInfo.triglyceride = null;
                      }
                      if (hDLcTextController.text.isNotEmpty) {
                        userInfo.hDLc = double.parse(hDLcTextController.text);
                      } else {
                        userInfo.hDLc = null;
                      }
                      if (lDLcTextController.text.isNotEmpty) {
                        userInfo.lDLc = double.parse(lDLcTextController.text);
                      } else {
                        userInfo.lDLc = null;
                      }
                      if (aSTTextController.text.isNotEmpty) {
                        userInfo.aST = double.parse(aSTTextController.text);
                      } else {
                        userInfo.aST = null;
                      }
                      if (aLTTextController.text.isNotEmpty) {
                        userInfo.aLT = double.parse(aLTTextController.text);
                      } else {
                        userInfo.aLT = null;
                      }
                      if (aLPTextController.text.isNotEmpty) {
                        userInfo.aLP = double.parse(aLPTextController.text);
                      } else {
                        userInfo.aLP = null;
                      }
                      if (t3TextController.text.isNotEmpty) {
                        userInfo.t3 = double.parse(t3TextController.text);
                      } else {
                        userInfo.t3 = null;
                      }
                      if (freeT3TextController.text.isNotEmpty) {
                        userInfo.freeT3 =
                            double.parse(freeT3TextController.text);
                      } else {
                        userInfo.freeT3 = null;
                      }
                      if (freeT4TextController.text.isNotEmpty) {
                        userInfo.freeT4 =
                            double.parse(freeT4TextController.text);
                      } else {
                        userInfo.freeT4 = null;
                      }
                      if (tSHTextController.text.isNotEmpty) {
                        userInfo.tSH = double.parse(tSHTextController.text);
                      } else {
                        userInfo.tSH = null;
                      }
                      if (otherCheckupTextController.text.isNotEmpty) {
                        userInfo.otherCheckup = otherCheckupTextController.text;
                      } else {
                        userInfo.otherCheckup = null;
                      }
                      await userInfo.save();
                    } else {
                      UserInfo userNewInfo = UserInfo(
                        weight: weightTextController.text.isNotEmpty
                            ? double.parse(weightTextController.text)
                            : null,
                        hight: hightTextController.text.isNotEmpty
                            ? double.parse(hightTextController.text)
                            : null,
                        pressure: pressureHighTextController.text.isNotEmpty &&
                                pressureLowTextController.text.isNotEmpty
                            ? '${pressureLowTextController.text}/${pressureHighTextController.text}'
                            : null,
                        lastUpdate:
                            pressureHighTextController.text.isNotEmpty &&
                                    pressureLowTextController.text.isNotEmpty
                                ? DateTime.now()
                                : null,
                        fPG: fPGTextController.text.isNotEmpty
                            ? double.parse(fPGTextController.text)
                            : null,
                        hbA1c: hbA1cTextController.text.isNotEmpty
                            ? double.parse(hbA1cTextController.text)
                            : null,
                        creatinine: creatinineTextController.text.isNotEmpty
                            ? double.parse(creatinineTextController.text)
                            : null,
                        gFR: gFRTextController.text.isNotEmpty
                            ? double.parse(gFRTextController.text)
                            : null,
                        totalCholesterol: totalCholesterolTextController
                                .text.isNotEmpty
                            ? double.parse(totalCholesterolTextController.text)
                            : null,
                        triglyceride: triglycerideTextController.text.isNotEmpty
                            ? double.parse(triglycerideTextController.text)
                            : null,
                        hDLc: hDLcTextController.text.isNotEmpty
                            ? double.parse(hDLcTextController.text)
                            : null,
                        lDLc: lDLcTextController.text.isNotEmpty
                            ? double.parse(lDLcTextController.text)
                            : null,
                        aST: aSTTextController.text.isNotEmpty
                            ? double.parse(aSTTextController.text)
                            : null,
                        aLT: aLTTextController.text.isNotEmpty
                            ? double.parse(aLTTextController.text)
                            : null,
                        aLP: aLPTextController.text.isNotEmpty
                            ? double.parse(aLPTextController.text)
                            : null,
                        t3: t3TextController.text.isNotEmpty
                            ? double.parse(t3TextController.text)
                            : null,
                        freeT3: freeT3TextController.text.isNotEmpty
                            ? double.parse(freeT3TextController.text)
                            : null,
                        freeT4: freeT4TextController.text.isNotEmpty
                            ? double.parse(freeT4TextController.text)
                            : null,
                        tSH: tSHTextController.text.isNotEmpty
                            ? double.parse(tSHTextController.text)
                            : null,
                        otherCheckup: otherCheckupTextController.text.isNotEmpty
                            ? otherCheckupTextController.text
                            : null,
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

class TextInfoDouble extends StatelessWidget {
  const TextInfoDouble({
    super.key,
    required this.text,
    required this.leftController,
    required this.rightController,
  });
  final TextStyle textStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  final String text;
  final TextEditingController leftController;
  final TextEditingController rightController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
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
                    controller: leftController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                    controller: rightController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'ยังไม่ระบุ',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextInputSingle extends StatelessWidget {
  const TextInputSingle({
    required this.text,
    super.key,
    required this.controller,
    required this.multiLineSting,
  });
  final String text;
  final TextEditingController controller;
  final bool multiLineSting;

  final TextStyle textStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: textStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            multiLineSting
                ? TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'ยังไม่ระบุ',
                    ),
                  )
                : TextFormField(
                    keyboardType: TextInputType.number,
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'ยังไม่ระบุ',
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
