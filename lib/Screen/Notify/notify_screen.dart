import 'dart:io';

//import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
//import 'package:path/path.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/utils/style.dart';

import 'components/add_notify_detail_screen.dart';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  DateTime currentDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
  );

  bool morningStatPanel = false;
  bool lunchStatPanel = false;
  bool eveningStatPanel = false;
  bool beforeBedStatPanel = false;

  TextStyle get panelHaderTextStyel {
    return const TextStyle(fontSize: 20);
  }

  Color? getExpansionPanelColor(int index) {
    final List<Color> panelColor = [
      Colors.pink.shade200,
      Colors.lime.shade200,
      Colors.yellow.shade200,
      Colors.cyan.shade200,
    ];
    return panelColor[index];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // Select Current Date to show notify list
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: currentDate,
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2032),
                    );
                    setState(() {
                      currentDate = selectedDate ?? DateTime.now();
                    });
                  },
                  child: Center(
                    child: Text(
                      'วันที่ ${DateFormat.yMMMMd('th').formatInBuddhistCalendarThai(
                        currentDate,
                      )}',
                      style: subHeadingStyle,
                    ),
                  ),
                ),
              ),
              AddNotifyButton(
                onTap: () {
                  // ไปยังหน้า เพิ่มรายการแจ้งเตือน
                  Get.to(
                    () => AddNotifyDetailScreen(
                      selectedDate: currentDate,
                    ),
                  );
                },
              )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<NotifyInfoModel>('user_notify_info').listenable(),
              builder: (_, boxNotify, __) {
                if (boxNotify.values.isNotEmpty) {
                  var notifyInfoList = boxNotify.values;
                  var notifyInfoListWithCurrentDate =
                      notifyInfoList.map((e) => e).where((element) {
                    var start = currentDate;
                    var end = currentDate.add(const Duration(days: 1));
                    return element.date.isAfter(start) &&
                        element.date.isBefore(end);
                  }).toList();
                  if (notifyInfoListWithCurrentDate.isEmpty) {
                    return const EmptyNotifyList();
                  } else {
                    // medicine in morning
                    var notifyInfoListCurrentDateMorningTime =
                        notifyInfoListWithCurrentDate
                            .map((e) => e)
                            .where((element) {
                      TimeOfDay notifyTime = TimeOfDay(
                        hour: element.time.hour,
                        minute: element.time.minute,
                      );
                      if ((notifyTime.hour == 5 && notifyTime.minute >= 0) ||
                          (notifyTime.hour > 5 && notifyTime.hour <= 9)) {
                        // 5:00 -> 9:59
                        return true;
                      }
                      return false;
                    });

                    // medicine in lunch
                    var notifyInfoListCurrentDateLunchTime =
                        notifyInfoListWithCurrentDate
                            .map((e) => e)
                            .where((element) {
                      TimeOfDay notifyTime = TimeOfDay(
                        hour: element.time.hour,
                        minute: element.time.minute,
                      );
                      if ((notifyTime.hour == 10 && notifyTime.minute >= 0) ||
                          (notifyTime.hour > 10 && notifyTime.hour <= 13)) {
                        // 10:00 -> 13:59
                        return true;
                      }
                      return false;
                    });

                    // medicine in evening
                    var notifyInfoListCurrentDateEveningTime =
                        notifyInfoListWithCurrentDate
                            .map((e) => e)
                            .where((element) {
                      TimeOfDay notifyTime = TimeOfDay(
                          hour: element.time.hour, minute: element.time.minute);
                      if ((notifyTime.hour == 14 && notifyTime.minute >= 0) ||
                          (notifyTime.hour > 14 && notifyTime.hour <= 19)) {
                        // 14:00 - 19:59
                        return true;
                      }
                      return false;
                    });

                    // medicine in before to bed
                    var notifyInfoListCurrentDateBeforeBedTime =
                        notifyInfoListWithCurrentDate
                            .map((e) => e)
                            .where((element) {
                      TimeOfDay notifyTime = TimeOfDay(
                          hour: element.time.hour, minute: element.time.minute);
                      if ((notifyTime.hour == 20 && notifyTime.minute >= 0) ||
                          (notifyTime.hour > 20 && notifyTime.hour <= 23) ||
                          (notifyTime.hour >= 0 && notifyTime.hour <= 4)) {
                        // 20:00 -> 4:59
                        return true;
                      }
                      return false;
                    });

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ExpansionPanelList(
                            animationDuration:
                                const Duration(milliseconds: 1000),
                            expansionCallback: (panelIndex, isExpanded) {
                              if (panelIndex == 0) {
                                // selected on panel morning
                                setState(() {
                                  morningStatPanel = !morningStatPanel;
                                });
                              }
                              if (panelIndex == 1) {
                                // selected on panel lunch
                                setState(() {
                                  lunchStatPanel = !lunchStatPanel;
                                });
                              }
                              if (panelIndex == 2) {
                                // selected on panel evening
                                setState(() {
                                  eveningStatPanel = !eveningStatPanel;
                                });
                              }
                              if (panelIndex == 3) {
                                // selected on panel before bed
                                setState(() {
                                  beforeBedStatPanel = !beforeBedStatPanel;
                                });
                              }
                            },
                            children: [
                              ExpansionPanel(
                                  backgroundColor: getExpansionPanelColor(0),
                                  canTapOnHeader: true,
                                  isExpanded: morningStatPanel,
                                  headerBuilder: (context, isExpanded) =>
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "เช้า (${notifyInfoListCurrentDateMorningTime.length} รายการ)",
                                            style: panelHaderTextStyel,
                                          ),
                                        ),
                                      ),
                                  body: notifyInfoListCurrentDateMorningTime
                                          .isNotEmpty
                                      ? MedicineListInMorning(
                                          notifyInfoListCurrentDateMorningTime:
                                              notifyInfoListCurrentDateMorningTime,
                                        )
                                      : Container()),
                              ExpansionPanel(
                                  backgroundColor: getExpansionPanelColor(1),
                                  canTapOnHeader: true,
                                  isExpanded: lunchStatPanel,
                                  headerBuilder: (context, isExpanded) =>
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "กลางวัน (${notifyInfoListCurrentDateLunchTime.length} รายการ)",
                                            style: panelHaderTextStyel,
                                          ),
                                        ),
                                      ),
                                  body: notifyInfoListCurrentDateLunchTime
                                          .isNotEmpty
                                      ? MedicineListInLunch(
                                          notifyInfoListCurrentDateLunchTime:
                                              notifyInfoListCurrentDateLunchTime,
                                        )
                                      : Container()),
                              ExpansionPanel(
                                  backgroundColor: getExpansionPanelColor(2),
                                  canTapOnHeader: true,
                                  isExpanded: eveningStatPanel,
                                  headerBuilder: (context, isExpanded) =>
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "เย็น (${notifyInfoListCurrentDateEveningTime.length} รายการ)",
                                            style: panelHaderTextStyel,
                                          ),
                                        ),
                                      ),
                                  body: notifyInfoListCurrentDateEveningTime
                                          .isNotEmpty
                                      ? MedicineListInEvening(
                                          notifyInfoListCurrentDateEveningTime:
                                              notifyInfoListCurrentDateEveningTime,
                                        )
                                      : Container()),
                              ExpansionPanel(
                                  backgroundColor: getExpansionPanelColor(3),
                                  canTapOnHeader: true,
                                  isExpanded: beforeBedStatPanel,
                                  headerBuilder: (context, isExpanded) =>
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "ก่อนนอน (${notifyInfoListCurrentDateBeforeBedTime.length} รายการ)",
                                            style: panelHaderTextStyel,
                                          ),
                                        ),
                                      ),
                                  body: notifyInfoListCurrentDateBeforeBedTime
                                          .isNotEmpty
                                      ? MedicineListInBeforeBed(
                                          notifyInfoListCurrentDateBeforeBedTime:
                                              notifyInfoListCurrentDateBeforeBedTime,
                                        )
                                      : Container()),
                            ],
                          ),
                        ),
                      ),
                    );
                    // SingleChildScrollView(
                    //   child: Column(
                    //     children: [
                    //       notifyInfoListCurrentDateMorningTime.isNotEmpty
                    //           ? MedicineListInMorning(
                    //               notifyInfoListCurrentDateMorningTime:
                    //                   notifyInfoListCurrentDateMorningTime,
                    //             )
                    //           : Container(),
                    //       notifyInfoListCurrentDateLunchTime.isNotEmpty
                    //           ? MedicineInLunch(
                    //               notifyInfoListCurrentDateLunchTime:
                    //                   notifyInfoListCurrentDateLunchTime)
                    //           : Container(),
                    //       notifyInfoListCurrentDateEveningTime.isNotEmpty
                    //           ? MedicineInEvening(
                    //               notifyInfoListCurrentDateEveningTime:
                    //                   notifyInfoListCurrentDateEveningTime)
                    //           : Container(),
                    //       notifyInfoListCurrentDateBeforeBedTime.isNotEmpty
                    //           ? MedicineInBeforeBed(
                    //               notifyInfoListCurrentDateBeforeBedTime:
                    //                   notifyInfoListCurrentDateBeforeBedTime)
                    //           : Container(),
                    //     ],
                    //   ),
                    // );
                  }
                } else {
                  return const EmptyNotifyList();
                }
              },
            ),
          ),
        )
      ],
    );
  }
}

class MedicineListInBeforeBed extends StatelessWidget {
  const MedicineListInBeforeBed({
    super.key,
    required this.notifyInfoListCurrentDateBeforeBedTime,
  });

  final Iterable<NotifyInfoModel> notifyInfoListCurrentDateBeforeBedTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          children: notifyInfoListCurrentDateBeforeBedTime.map((notifyInfo) {
            return NotifyCard(
              notifyInfo: notifyInfo,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class MedicineListInEvening extends StatelessWidget {
  const MedicineListInEvening({
    super.key,
    required this.notifyInfoListCurrentDateEveningTime,
  });

  final Iterable<NotifyInfoModel> notifyInfoListCurrentDateEveningTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          children: notifyInfoListCurrentDateEveningTime.map((notifyInfo) {
            return NotifyCard(
              notifyInfo: notifyInfo,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class MedicineListInLunch extends StatelessWidget {
  const MedicineListInLunch({
    super.key,
    required this.notifyInfoListCurrentDateLunchTime,
  });

  final Iterable<NotifyInfoModel> notifyInfoListCurrentDateLunchTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          children: notifyInfoListCurrentDateLunchTime.map((notifyInfo) {
            return NotifyCard(
              notifyInfo: notifyInfo,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class MedicineListInMorning extends StatelessWidget {
  const MedicineListInMorning({
    super.key,
    required this.notifyInfoListCurrentDateMorningTime,
  });

  final Iterable<NotifyInfoModel> notifyInfoListCurrentDateMorningTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          children: notifyInfoListCurrentDateMorningTime.map((notifyInfo) {
            return NotifyCard(
              notifyInfo: notifyInfo,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class EmptyNotifyList extends StatelessWidget {
  const EmptyNotifyList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Image.asset(
            "assets/images/empty_notify_list.png",
            width: 200,
            height: 200,
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "วันนี้ไม่มีรายการแจ้งเตือน",
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}

class NotifyCard extends StatelessWidget {
  NotifyCard({
    required this.notifyInfo,
    super.key,
  });
  NotifyInfoModel notifyInfo;

  final String _emptyPicture = "assets/images/dummy_picture.jpg";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Stack(
        children: [
          Card(
            elevation: 3.0,
            color: notifyInfo.status == 0
                ? Colors.green.shade300
                : Colors.blue.shade300,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: SizedBox(
              height: 220,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notifyInfo.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(notifyInfo.description),
                            Text(
                              "เวลา ${TimeOfDay(
                                hour: notifyInfo.time.hour,
                                minute: notifyInfo.time.minute,
                              ).format(context)}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(notifyInfo.medicineInfo.color),
                              ),
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: MedicineInfoOnCard(
                                              notifyInfo: notifyInfo),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: notifyInfo.medicineInfo
                                                          .picture_path ==
                                                      '' ||
                                                  notifyInfo.medicineInfo
                                                          .picture_path ==
                                                      null
                                              ? Image.asset(
                                                  _emptyPicture,
                                                  fit: BoxFit.cover,
                                                  height: 110,
                                                )
                                              : Image.file(
                                                  File(notifyInfo.medicineInfo
                                                      .picture_path!),
                                                  fit: BoxFit.cover,
                                                  height: 110,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child: ClipRRect(
                  //         borderRadius: BorderRadius.circular(20),
                  //         child: notifyInfo.medicineInfo.picture_path == '' ||
                  //                 notifyInfo.medicineInfo.picture_path == null
                  //             ? Image.asset(
                  //                 _emptyPicture,
                  //                 fit: BoxFit.cover,
                  //                 height: 150,
                  //               )
                  //             : Image.file(
                  //                 File(notifyInfo.medicineInfo.picture_path!),
                  //                 fit: BoxFit.cover,
                  //                 height: 150,
                  //               ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       flex: 2,
                  //       child: Container(
                  //         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  //         height: 200,
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               notifyInfo.name,
                  //               style: const TextStyle(
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //             Text(notifyInfo.description),
                  //             Text("เวลา ${TimeOfDay(
                  //               hour: notifyInfo.time.hour,
                  //               minute: notifyInfo.time.minute,
                  //             ).format(context)}"),
                  //             const Divider(
                  //               thickness: 2,
                  //             ),
                  //             MedicineInfoOnCard(notifyInfo: notifyInfo),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  ),
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: GestureDetector(
                onTap: () {
                  Get.dialog(
                    ChangeStatusWarnningDialog(notifyInfo: notifyInfo),
                  );
                },
                child: NotifyStatus(
                  notifyInfo: notifyInfo,
                )),
          )
        ],
      ),
    );
  }
}

class MedicineInfoOnCard extends StatelessWidget {
  const MedicineInfoOnCard({
    super.key,
    required this.notifyInfo,
  });

  final NotifyInfoModel notifyInfo;

  getHowtoEat(NotifyInfoModel notifyInfo) {
    String type = notifyInfo.medicineInfo.type;
    var nTake = notifyInfo.medicineInfo.nTake;
    var period =
        notifyInfo.medicineInfo.period_time.where((e) => e == true).length;
    String periodThai = '$period เวลา';
    String nTakeStr;
    if (nTake % 1 == 0) {
      nTakeStr = nTake.toInt().toString();
    } else {
      nTakeStr = Fraction.fromDouble(nTake).toString();
    }
    var unit = notifyInfo.medicineInfo.unit;
    String prefixType = (type == 'pills' || type == 'water')
        ? "รับประทาน"
        : (type == 'arrow')
            ? "ใช้ฉีด"
            : "ใช้หยด";
    return "$prefixType $nTakeStr $unit ($periodThai)";
  }

  getOrderInThai(NotifyInfoModel notifyInfo) {
    var order = notifyInfo.medicineInfo.order;

    String orderThai = order == "before" ? "ก่อนอาหาร" : "หลังอาหาร";
    return orderThai;
  }

  getPeroidInThai(NotifyInfoModel notifyInfo) {
    var period = notifyInfo.medicineInfo.period_time;

    List<String> periodStrList = [];
    for (int i = 0; i < period.length; i++) {
      if (period[i]) {
        switch (i) {
          case 0:
            periodStrList.add('เช้า');
            break;
          case 1:
            periodStrList.add('กลางวัน');
            break;
          case 2:
            periodStrList.add('เย็น');
            break;
          case 3:
            periodStrList.add('ก่อนนอน');
            break;
        }
      }
    }
    return periodStrList.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notifyInfo.medicineInfo.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          notifyInfo.medicineInfo.description,
        ),
        Text(
          getHowtoEat(notifyInfo),
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          getOrderInThai(notifyInfo),
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          getPeroidInThai(notifyInfo),
          style: const TextStyle(fontSize: 16),
        )
      ],
    );
  }
}

class ChangeStatusWarnningDialog extends StatelessWidget {
  const ChangeStatusWarnningDialog({
    super.key,
    required this.notifyInfo,
  });

  final NotifyInfoModel notifyInfo;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'คำเตือน!',
        style: TextStyle(color: Colors.red),
      ),
      content: notifyInfo.status != 0
          ? const Text('คุณแน่ใจใช่ไหมว่าได้กินยาเรียบร้อยแล้ว')
          : const Text('คุณแน่ใจใช่ไหมว่ายังไม่ได้กินยา'),
      actions: [
        TextButton(
          onPressed: () async {
            if (notifyInfo.status == 0) {
              notifyInfo.status = 1;
            } else {
              notifyInfo.status = 0;
            }
            await notifyInfo.save();
            Get.back();
          },
          child: const Text("ตกลง"),
        ),
        TextButton(
          onPressed: () async {
            // print("Cancel");
            // notifyInfo.status = 1;
            // await notifyInfo.save();
            // Get.back();
          },
          child: const Text("ยกเลิก"),
        )
      ],
    );
  }
}

class NotifyStatus extends StatelessWidget {
  const NotifyStatus({
    super.key,
    required this.notifyInfo,
  });

  final NotifyInfoModel notifyInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 45,
      padding: const EdgeInsets.all(8),
      decoration: notifyInfo.status == 0
          ? BoxDecoration(
              color: Colors.green.shade200,
              border: Border.all(color: Colors.transparent),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
            )
          : BoxDecoration(
              color: Colors.blue.shade100,
              border: Border.all(color: Colors.transparent),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12))),
      child: notifyInfo.status == 0
          ? const Text(
              "กินยาแล้ว",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          : const Text(
              "ยังไม่กินยา",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
    );
  }
}

class AddNotifyButton extends StatelessWidget {
  AddNotifyButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(), padding: EdgeInsets.all(10)),

        onPressed: onTap,
        child: const Icon(
          Icons.add,
          size: 35,
        ),
        // RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(25))),
      ),
    );
    // GestureDetector(
    //   onTap: onTap,
    //   child: Container(
    //     padding: const EdgeInsets.only(
    //       left: 8,
    //       right: 8,
    //     ),
    //     height: 50,
    //     alignment: Alignment.center,
    //     decoration: BoxDecoration(
    //       color: Colors.blue,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: const Text('+ เพิ่มรายการ'),
    //   ),
    // );
  }
}
