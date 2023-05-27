import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';

import '../../../Controller/medicine_info_controller.dart';
import '../../../constants.dart';

class NotifyMedicineCard extends StatelessWidget {
  NotifyMedicineCard({super.key, required this.notifyInfo});

  final NotifyInfoModel notifyInfo;

  final notifyStateController = Get.put(NotificationState());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MedicineCard(
          notifyInfo: notifyInfo,
        ),
        Positioned(
          right: 14,
          top: 9,
          child: StatusOfMedicine(
            status: notifyInfo.status == 0,
            medicineType: notifyInfo.medicineInfo.type,
            onTap: () async {
              if (notifyInfo.status == 0) {
                notifyInfo.status = 1;
              } else {
                notifyInfo.status = 0;
              }
              await notifyInfo.save();
            },
          ),
        ),
        Positioned(
          bottom: 13,
          right: 19,
          child: GestureDetector(
            child: Icon(
              Icons.delete_rounded,
              color: Colors.red.shade300,
            ),
            onTap: () async {
              var deleteConfirm = await Get.defaultDialog(
                  title: "ลบรายการแจ้งเตือน",
                  titleStyle: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                  middleText: "รายการนี้จะถูกลบออก และไม่มีการแจ้งเตือน",
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back(result: true);
                      },
                      child: const Text(
                        "ตกลง",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      child: const Text(
                        "ยกเลิก",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ]);
              if (deleteConfirm) {
                //delete from notificaion list of device
                await notifyStateController
                    .medicineNotification.value.localNotificationsPlugin
                    .cancel(notifyInfo.key);
                // delete this notifyInfo from Hive database
                await notifyInfo.delete();
              }
            },
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class StatusOfMedicine extends StatelessWidget {
  StatusOfMedicine({
    super.key,
    required this.status,
    required this.medicineType,
    this.onTap,
  });

  final bool status;
  final String medicineType;

  String get toThaiType {
    String thaiType = "";
    switch (medicineType) {
      case "pills":
      case "water":
        thaiType = "กิน";
        break;
      case "arrow":
        thaiType = "ฉีด";
        break;
      case "drop":
        thaiType = "หยอด/พ่น";
        break;
      default:
        thaiType = "not_support";
        break;
    }
    return thaiType;
  }

  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: 150,
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white70,
            border: Border.all(color: Colors.transparent),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
          ),
          child: Row(
            children: [
              Icon(
                status ? Icons.check_box_sharp : Icons.check_box_outline_blank,
                color: status ? Colors.green : Colors.red,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                status ? "$toThaiTypeแล้ว" : 'ยังไม่$toThaiType',
                style: TextStyle(
                  color: status ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: medicineType != "drop" ? 16 : 14,
                ),
              )
            ],
          )),
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({
    super.key,
    required this.notifyInfo,
  });

  final NotifyInfoModel notifyInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
      child: SizedBox(
        height: 100,
        child: Card(
          elevation: 3,
          color: Color(notifyInfo.medicineInfo.color),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: notifyInfo.medicineInfo.picture_path != null &&
                              notifyInfo.medicineInfo.picture_path != ''
                          ? Image.file(
                              File(notifyInfo.medicineInfo.picture_path!),
                              fit: BoxFit.cover,
                              height: 75,
                              width: 70,
                            )
                          : Image.asset(
                              emptyPicture,
                              fit: BoxFit.cover,
                              height: 75,
                              width: 70,
                            ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('HH:mm น.').format(notifyInfo.date),
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        notifyInfo.medicineInfo.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      getOrder(notifyInfo.medicineInfo.order).isEmpty
                          ? Text(
                              '${getThaiType(notifyInfo.medicineInfo.type)} ครั้งละ ${getNTake(notifyInfo.medicineInfo.nTake)} ${notifyInfo.medicineInfo.unit}',
                              style: const TextStyle(fontSize: 16),
                            )
                          : Text(
                              '${getOrder(notifyInfo.medicineInfo.order).isEmpty ? "" : "${getOrder(notifyInfo.medicineInfo.order)},"} ${getThaiType(notifyInfo.medicineInfo.type)} ครั้งละ ${getNTake(notifyInfo.medicineInfo.nTake)} ${notifyInfo.medicineInfo.unit}',
                              style: const TextStyle(fontSize: 16),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getNTake(double nTake) {
    if (nTake % 1 == 0) {
      return nTake.toInt();
    } else {
      return nTake;
    }
  }

  String getThaiType(String medicineType) {
    String thaiType = "";
    switch (medicineType) {
      case "pills":
      case "water":
        thaiType = "กิน";
        break;
      case "arrow":
        thaiType = "ฉีด";
        break;
      case "drop":
        thaiType = "หยอด/พ่น";
        break;
      default:
        thaiType = "not_support";
        break;
    }
    return thaiType;
  }

  String getOrder(String? order) {
    if (order != null) {
      if (order == "before") {
        return "ก่อนอาหาร";
      } else if (order == "after") {
        return "หลังอาหาร";
      } else {
        return "";
      }
    } else {
      return "";
    }
  }
}
