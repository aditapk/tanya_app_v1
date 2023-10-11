import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/constants.dart';
import 'package:tanya_app_v1/utils/constans.dart';

class NotifyHandleScreen extends StatelessWidget {
  const NotifyHandleScreen({
    required this.notifyID,
    super.key,
  });

  final int notifyID;

  @override
  Widget build(BuildContext context) {
    var notifyInfo = getNotifyInfo(notifyID);
    if (notifyInfo != null) {
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: notifyInfo.medicineInfo.picture_path != ""
                        ? Image.file(
                            File(notifyInfo.medicineInfo.picture_path!),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            emptyPicture,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const Divider(),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(notifyInfo.medicineInfo.color)),
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white60),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${DateFormat("HH:mm").format(notifyInfo.date)} น. ถึงเวลา${getType(notifyInfo.medicineInfo.type)}ยา ',
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "ชื่อยา : ${notifyInfo.medicineInfo.name}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'รายละเอียด : ${notifyInfo.medicineInfo.description}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              "${getType(notifyInfo.medicineInfo.type)} ครั้งละ ${getNTake(notifyInfo.medicineInfo.nTake)} ${notifyInfo.medicineInfo.unit}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green.shade400),
                                      child: const Text(
                                        'ตกลง',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        Get.back(result: "OK");
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade400),
                                      child: const Text('เลื่อนไปก่อน',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        // Future delay time
                                        // Future.delayed(
                                        //     const Duration(seconds: 10), () {
                                        //   if (notifyInfo.status == 0) {
                                        //     print('กินแล้ว');
                                        //   } else {
                                        //     print('ยังไม่กิน');
                                        //   }
                                        // });
                                        Get.back(result: "PENDING");
                                      },
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('แจ้งเตือนกินยา'),
          centerTitle: true,
        ),
        body: Center(
            child: Column(
          children: [
            const Text('ไม่พบข้อมูลแจ้งเตือนยา กรุณาติดต่อผู้ดูแลระบบ'),
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('ออกจากหน้านี้'))
          ],
        )),
      );
    }
  }

  NotifyInfoModel? getNotifyInfo(int notifyID) {
    var notifyBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
    var notifyInfo = notifyBox.get(notifyID);
    return notifyInfo;
  }

  String getNTake(double nTake) {
    if (nTake % 1 == 0) {
      return nTake.toInt().toString();
    } else {
      return nTake.toString();
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
      return 'กิน';
    }
    if (type == 'arrow') {
      return 'ฉีด';
    }
    if (type == 'drop') {
      return 'หยอด/พ่น';
    }
  }
}
