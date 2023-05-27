import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tanya_app_v1/Model/notify_report.dart';
import 'package:tanya_app_v1/constants.dart';

class MedicineReportCard extends StatelessWidget {
  const MedicineReportCard({super.key, required this.notifyReport});

  final NotifyReport notifyReport;

  String getMedicineTypeText(String medicineType) {
    String typeText = "";
    switch (medicineType) {
      case "pills":
      case "water":
        typeText = "กิน";
        break;
      case "arrow":
        typeText = "ฉีด";
        break;
      case "drop":
        typeText = "หยอด/พ่น";
        break;
    }
    return typeText;
  }

  bool completed(NotifyReport notifyReport) {
    return (notifyReport.nComplete / notifyReport.nNotify) == 1;
  }

  autofillNotifyName(NotifyReport notifyReport) {
    return notifyReport.notifyName.isNotEmpty
        ? notifyReport.notifyName
        : "กินยา ${notifyReport.medicineName}";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 5,
        ),
        child: SizedBox(
          height: 135,
          width: MediaQuery.of(context).size.width,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            color: Color(notifyReport.color),
            child: SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white54,
                      height: 135,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          left: 8,
                          bottom: 8,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(notifyReport.color),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  notifyReport.medicineName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  autofillNotifyName(notifyReport),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${getMedicineTypeText(notifyReport.type)}แล้ว ${notifyReport.nComplete} / ${notifyReport.nNotify} ครั้ง',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'ร้อยละการ${getMedicineTypeText(notifyReport.type)} ${(notifyReport.nComplete / notifyReport.nNotify * 100).toStringAsFixed(0)} %',
                                  style: const TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 127,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        color: Colors.white54),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MedicineImage(
                            notifyReport: notifyReport,
                            width: 120,
                            height: 82,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                !completed(notifyReport)
                                    ? Icons.check_box_outline_blank
                                    : Icons.check_box,
                                color: !completed(notifyReport)
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                completed(notifyReport)
                                    ? "ครบแลัว"
                                    : "เหลืออีก ${notifyReport.nNotify - notifyReport.nComplete} ครั้ง",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: completed(notifyReport)
                                        ? Colors.green
                                        : Colors.red),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

class MedicineImage extends StatelessWidget {
  const MedicineImage({
    super.key,
    required this.notifyReport,
    required this.width,
    required this.height,
  });

  final NotifyReport notifyReport;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            notifyReport.picturePath != "" && notifyReport.picturePath != null
                ? Image.file(
                    File(notifyReport.picturePath!),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    emptyPicture,
                    fit: BoxFit.cover,
                  ),
      ),
    );
  }
}
