import 'dart:io';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/Screen/Report/components/selected_interval_time.dart';

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
  NotifyReport({
    required this.medicineName,
    required this.nNotify,
    required this.nComplete,
    this.picturePath,
    required this.notifyName,
    required this.color,
  });
}

class _MedicineReportScreenState extends State<MedicineReportScreen> {
  //DateTime? startDateTime;
  //DateTime? endDateTime;
  List<NotifyReport>? notifyReport;

  TextEditingController timeIntervalTextController = TextEditingController();

  final appState = Get.put(MedicineEditorState());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MedicineEditorState>(builder: (appState) {
      //final appState = Get.find<MedicineEditorState>();
      var notifyInfoBox = Hive.box<NotifyInfoModel>('user_notify_info');
      var notifyInfo = notifyInfoBox.values.toList();
      List<NotifyInfoModel> notifyInfoInRange = [];
      //if (appState.filterStartDate.value != null && appState.filterEndDate != null) {
      notifyInfoInRange = notifyInfo.where((notify) {
        if (notify.date.isAfter(appState.filterStartDate.value) &&
            notify.date.isBefore(appState.filterEndDate.value)) {
          return true;
        }
        return false;
      }).toList();

      var medicineSet = <String>{};
      var notifySet = <String>{};
      var colorSet = <int>{};
      for (var notify in notifyInfoInRange) {
        medicineSet.add(notify.medicineInfo.name);
        notifySet.add(notify.name);
        colorSet.add(notify.medicineInfo.color);
      }
      //var medicineList = medicineSet.toList();
      var notifyList = notifySet.toList();
      var colorList = colorSet.toList();

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
        ));
      }
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
                                startDateTime: appState.filterStartDate.value,
                                endDateTime: appState.filterEndDate.value),
                          );
                          if (result != null) {
                            setState(() {
                              appState.filterStartDate.value =
                                  result['startDateTime'];
                              appState.filterEndDate.value =
                                  result['endDateTime'];
                              timeIntervalTextController.text =
                                  '${DateFormat.yMMMMd('th').formatInBuddhistCalendarThai(appState.filterStartDate.value)} - ${DateFormat.yMMMMd('th').formatInBuddhistCalendarThai(appState.filterEndDate.value)}';
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
                              elevation: 1,
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
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12)),
                                            child: Image.file(
                                              File(notifyReport![index]
                                                  .picturePath!),
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8,
                                                    left: 8,
                                                  ),
                                                  child: Text(
                                                    'แจ้งเตือน ${notifyReport![index].notifyName}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8, left: 8),
                                                  child: Text(
                                                    'ยา ${notifyReport![index].medicineName}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8, left: 8),
                                                  child: Text(
                                                    'รับประทานแล้ว ${notifyReport![index].nComplete}/${notifyReport![index].nNotify} ครั้ง',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 8,
                                                    left: 8,
                                                    bottom: 8,
                                                  ),
                                                  child: Text(
                                                    'เปอร์เซนต์การรับประทาน ${(notifyReport![index].nComplete / notifyReport![index].nNotify * 100).toStringAsFixed(0)} %',
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
    });
  }
}
