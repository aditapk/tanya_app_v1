import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/Screen/Report/components/selected_interval_time.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import '../../Model/notify_report.dart';
import 'components/medicine_report_card.dart';

class MedicineReportScreen extends StatefulWidget {
  const MedicineReportScreen({super.key});

  @override
  State<MedicineReportScreen> createState() => _MedicineReportScreenState();
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

  autofillNotifyName(String notifyName, String medicineName) {
    return notifyName.isNotEmpty ? notifyName : "กินยา $medicineName";
  }

  @override
  Widget build(BuildContext context) {
    //return GetBuilder<ReportFilterState>(builder: (reportState) {
    final reportState = Get.find<ReportFilterState>();
    var notifyInfoBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
    var notifyInfo = notifyInfoBox.values.toList();
    List<NotifyInfoModel> notifyInfoInRange = [];
    //if (appState.filterStartDate.value != null && appState.filterEndDate != null) {
    reportState.filterStartDate.value =
        reviseStartDate(reportState.filterStartDate.value);
    reportState.filterEndDate.value =
        reviseEndDate(reportState.filterEndDate.value);
    var filterStartDate = reportState.filterStartDate.value;
    var filtterEndDate = reportState.filterEndDate.value;
    notifyInfoInRange = notifyInfo.where((notify) {
      return checkInRangeOfTime(
          date: notify.date, start: filterStartDate, end: filtterEndDate);
    }).toList();

    var medicineSet = <String>{};
    var notifySet = <String>{};
    var colorList = [];
    var medicineType = [];
    for (var notify in notifyInfoInRange) {
      medicineSet.add(notify.medicineInfo.name);
      notifySet.add(notify.name);
    }
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
          Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Theme.of(context).primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 10),
              child: GestureDetector(
                onTap: () async {
                  var result = await Get.defaultDialog(
                    title: 'กำหนดช่วงวันและเวลา',
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                    content: SelectedIntervalTime(
                        startDateTime: reportState.filterStartDate.value,
                        endDateTime: reportState.filterEndDate.value),
                  );
                  if (result != null) {
                    setState(() {
                      reportState.filterStartDate.value =
                          result['startDateTime'];
                      reportState.filterEndDate.value = result['endDateTime'];
                      // timeIntervalTextController.text =
                      //     '${DateFormat.yMMMd('th').formatInBuddhistCalendarThai(reportState.filterStartDate.value)}  -  ${DateFormat.yMMMd('th').formatInBuddhistCalendarThai(reportState.filterEndDate.value)}';
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timeIntervalTextController.text,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: notifyReport!.length,
                itemBuilder: (context, index) {
                  if (notifyReport!.isNotEmpty) {
                    return MedicineReportCard(
                      notifyReport: notifyReport![index],
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
      ),
    );
  }
}
