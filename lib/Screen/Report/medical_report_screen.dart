import 'dart:io';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/Screen/Report/components/selected_interval_time.dart';
import 'package:tanya_app_v1/utils/constans.dart';

class MedicineReportScreen extends StatefulWidget {
  const MedicineReportScreen({super.key});

  @override
  State<MedicineReportScreen> createState() => _MedicineReportScreenState();
}

class NotifyReport {
  String notifyName;
  String medicineName;
  String? picturePath;
  int nNotify;
  int nComplete;
  int color;
  String type;
  NotifyReport({
    required this.medicineName,
    required this.nNotify,
    required this.nComplete,
    this.picturePath,
    required this.notifyName,
    required this.color,
    required this.type,
  });
}

class _MedicineReportScreenState extends State<MedicineReportScreen> {
  //DateTime? startDateTime;
  //DateTime? endDateTime;
  List<NotifyReport>? notifyReport;

  TextEditingController timeIntervalTextController = TextEditingController();

  //final appState = Get.put(MedicineEditorState());

  reviseStartDate(DateTime startDate) {
    return DateTime(startDate.year, startDate.month, startDate.day, 0, 0);
  }

  reviseEndDate(DateTime endDate) {
    return DateTime(endDate.year, endDate.month, endDate.day, 23, 59);
  }

  checkInRangeOfTime(
      {required DateTime date,
      required DateTime start,
      required DateTime end}) {
    return date.isAfter(start) && date.isBefore(end);
  }

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
        typeText = "หยอด";
        break;
    }
    return typeText;
  }

  @override
  Widget build(BuildContext context) {
    //return GetBuilder<ReportFilterState>(builder: (reportState) {
    final reportState = Get.find<ReportFilterState>();
    var notifyInfoBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
    var notifyInfo = notifyInfoBox.values.toList();
    List<NotifyInfoModel> notifyInfoInRange = [];
    //if (appState.filterStartDate.value != null && appState.filterEndDate != null) {
    var filterStartDate = reviseStartDate(reportState.filterStartDate.value);
    var filtterEndDate = reviseEndDate(reportState.filterEndDate.value);
    notifyInfoInRange = notifyInfo.where((notify) {
      return checkInRangeOfTime(
          date: notify.date, start: filterStartDate, end: filtterEndDate);
      // if (notify.date.isAfter(filterStartDate) &&
      //     notify.date.isBefore(filtterEndDate)) {
      //   return true;
      // }
      // return false;
    }).toList();

    var medicineSet = <String>{};
    var notifySet = <String>{};
    var colorList = [];
    var medicineType = [];
    for (var notify in notifyInfoInRange) {
      medicineSet.add(notify.medicineInfo.name);
      notifySet.add(notify.name);
      //colorSet.add(notify.medicineInfo.color);
    }
    //var medicineList = medicineSet.toList();
    var notifyList = notifySet.toList();

    for (var notifyName in notifyList) {
      for (var notiInfo in notifyInfoInRange) {
        if (notiInfo.name == notifyName) {
          colorList.add(notiInfo.medicineInfo.color);
          medicineType.add(notiInfo.medicineInfo.type);
          break;
        }
      }
    }
    //var colorList = colorSet.toList();

    // find number of notify each medicine
    Map<String, int> nNotifyEachMedicine = {};
    Map<String, int> nNotifyCompleteEachMedicine = {};
    Map<String, String?> picturePathEachMedicine = {};
    Map<String, String> medicineNameEachNotify = {};

    for (var notify in notifyList) {
      nNotifyCompleteEachMedicine[notify] = 0;
      nNotifyEachMedicine[notify] = 0;
      picturePathEachMedicine[notify] = null;
      medicineNameEachNotify[notify] = '';
    }

    for (var notify in notifyInfoInRange) {
      var notifyName = notify.name;
      if (notify.status == 0) {
        nNotifyCompleteEachMedicine.update(notifyName, (value) => value + 1);
      }
      nNotifyEachMedicine.update(notifyName, (value) => value + 1);
      picturePathEachMedicine.update(
          notifyName, (value) => notify.medicineInfo.picture_path);
      medicineNameEachNotify.update(
          notifyName, (value) => notify.medicineInfo.name);
    }
    notifyReport = [];
    for (var notify in notifyList) {
      int idx = notifyList.indexOf(notify);
      notifyReport!.add(NotifyReport(
        notifyName: notify,
        medicineName: medicineNameEachNotify[notify]!,
        nComplete: nNotifyCompleteEachMedicine[notify]!,
        nNotify: nNotifyEachMedicine[notify]!,
        picturePath: picturePathEachMedicine[notify],
        color: colorList[idx],
        type: medicineType[idx],
      ));
    }
    // set time interval text
    timeIntervalTextController.text =
        '${DateFormat.yMMMMd('th').formatInBuddhistCalendarThai(reportState.filterStartDate.value)} - ${DateFormat.yMMMMd('th').formatInBuddhistCalendarThai(reportState.filterEndDate.value)}';
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                readOnly: true,
                controller: timeIntervalTextController,
                decoration: InputDecoration(
                    hintText: 'กำหนดช่วงวันและเวลา',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () async {
                        var result = await Get.defaultDialog(
                          title: 'กำหนดช่วงวันและเวลา',
                          titleStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          content: SelectedIntervalTime(
                              startDateTime: reportState.filterStartDate.value,
                              endDateTime: reportState.filterEndDate.value),
                        );
                        if (result != null) {
                          setState(() {
                            reportState.filterStartDate.value =
                                result['startDateTime'];
                            reportState.filterEndDate.value =
                                result['endDateTime'];
                            timeIntervalTextController.text =
                                '${DateFormat.yMMMMd('th').formatInBuddhistCalendarThai(reportState.filterStartDate.value)} - ${DateFormat.yMMMMd('th').formatInBuddhistCalendarThai(reportState.filterEndDate.value)}';
                          });
                        }
                      },
                    ),
                    suffixIconColor: Colors.blue.shade400,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: Platform.isAndroid
                    ? MediaQuery.of(context).size.height - 229
                    : MediaQuery.of(context).size.height - 282,
                child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: notifyReport?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 8,
                        ),
                        child: SizedBox(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            color: Color(notifyReport![index].color),
                            child: Column(
                              children: [
                                SizedBox(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        height: 142,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomLeft: Radius.circular(12)),
                                          child: notifyReport![index]
                                                          .picturePath !=
                                                      "" &&
                                                  notifyReport![index]
                                                          .picturePath !=
                                                      null
                                              ? Image.file(
                                                  File(notifyReport![index]
                                                      .picturePath!),
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  "assets/images/dummy_picture.jpg",
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 140,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                  left: 8,
                                                ),
                                                child: Text(
                                                  notifyReport![index]
                                                      .notifyName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, left: 8),
                                                child: Text(
                                                  notifyReport![index]
                                                      .medicineName,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, left: 8),
                                                child: Text(
                                                  '${getMedicineTypeText(notifyReport![index].type)}แล้ว ${notifyReport![index].nComplete} / ${notifyReport![index].nNotify} ครั้ง',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                  left: 8,
                                                  bottom: 8,
                                                ),
                                                child: Text(
                                                  'ร้อยละการ${getMedicineTypeText(notifyReport![index].type)} ${(notifyReport![index].nComplete / notifyReport![index].nNotify * 100).toStringAsFixed(0)} %',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
