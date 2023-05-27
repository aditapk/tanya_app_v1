import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/utils/constans.dart';

class NotifyHandleScreen extends StatelessWidget {
  const NotifyHandleScreen({
    required this.notifyID,
    super.key,
  });
  final int notifyID;

  NotifyInfoModel? getNotifyInfo(int notifyID) {
    var notifyBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
    var notifyInfo = notifyBox.getAt(notifyID);
    return notifyInfo;
  }

  String getNTake(double nTake) {
    if (nTake % 1 == 0) {
      return nTake.toInt().toString();
    } else {
      return Fraction.fromDouble(nTake).toString();
    }
  }

  final TextStyle textStyle = const TextStyle(
    fontSize: 18,
  );

  getPeriodTime(List<bool> periodOfTime) {
    List<String> periodList = [];
    for (int i = 0; i < periodOfTime.length; i++) {
      if (periodOfTime[i] == true) {
        if (i == 0) {
          periodList.add('เช้า');
        }
        if (i == 1) {
          periodList.add('กลางวัน');
        }
        if (i == 2) {
          periodList.add('เย็น');
        }
        if (i == 3) {
          periodList.add('ก่อนนอน');
        }
      }
    }
    return periodList.join(', ');
  }

  getType(String type) {
    if (type == 'pills' || type == 'water') {
      return 'รับประทาน';
    }
    if (type == 'arrow') {
      return 'ใช้ฉีด';
    }
    if (type == 'drop') {
      return 'ใช้หยด';
    }
  }

  @override
  Widget build(BuildContext context) {
    var notifyInfo = getNotifyInfo(notifyID);
    return Scaffold(
      appBar: AppBar(
        title: const Text('แจ้งเตือนกินยา'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                            File(notifyInfo!.medicineInfo.picture_path!)),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'รายการ : ${notifyInfo.name}',
                              style: textStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'รายละเอียด : ${notifyInfo.description}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'เวลา : ${TimeOfDay(hour: notifyInfo.time.hour, minute: notifyInfo.time.minute).format(context)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: Color(notifyInfo.medicineInfo.color),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "ชื่อยา : ${notifyInfo.medicineInfo.name}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'รายละเอียด : ${notifyInfo.medicineInfo.description}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${getType(notifyInfo.medicineInfo.type)} ${getNTake(notifyInfo.medicineInfo.nTake)} ${notifyInfo.medicineInfo.unit} (${notifyInfo.medicineInfo.period_time.where((element) => element == true).length} เวลา)",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        getPeriodTime(notifyInfo
                                            .medicineInfo.period_time),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                      onPressed: () async {
                                        // notifyInfo.status = 0;
                                        // await notifyInfo.save();
                                        Get.back(result: "OK");
                                      },
                                      child: const Text(
                                        'รับทราบ',
                                        style: TextStyle(fontSize: 18),
                                      ))),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Get.back(result: "PENDING");
                                  },
                                  child: const Text(
                                    'เลื่อนไปก่อน',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
