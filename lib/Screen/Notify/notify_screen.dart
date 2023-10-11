import 'dart:io';

//import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
import 'package:get/get.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
//import 'package:path/path.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/Screen/Notify/components/notify_medicine_card.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';

import '../../constants.dart';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({
    Key? key,
    required this.showcaseKey,
  }) : super(key: key);
  final GlobalKey showcaseKey;
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

  Color dayColor(DateTime selectedDate) {
    if (selectedDate.weekday == 7) {
      return Colors.red.shade100;
    } else if (selectedDate.weekday == 1) {
      return Colors.yellow.shade100;
    } else if (selectedDate.weekday == 2) {
      return Colors.pink.shade100;
    } else if (selectedDate.weekday == 3) {
      return Colors.green.shade100;
    } else if (selectedDate.weekday == 4) {
      return Colors.orange.shade100;
    } else if (selectedDate.weekday == 5) {
      return Colors.blue.shade100;
    } else if (selectedDate.weekday == 6) {
      return Colors.purple.shade100;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: Theme.of(context).primaryColor,
          ),
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
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
                currentDate = selectedDate ?? currentDate;
              });
            },
            child: Showcase(
                key: widget.showcaseKey,
                targetBorderRadius: BorderRadius.circular(12),
                description: "เลือกดูรายการแจ้งเตือนยาในแต่ละวัน",
                child: ChooseDate(
                  currentDate: currentDate,
                )),
          ),
        ),
        ValueListenableBuilder(
          valueListenable:
              Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO)
                  .listenable(),
          builder: (_, boxNotify, __) {
            if (boxNotify.values.isNotEmpty) {
              var notifyInfoList = boxNotify.values;
              var notifyInfoListWithCurrentDate = inCurrentDate(notifyInfoList);
              if (notifyInfoListWithCurrentDate.isEmpty) {
                return const EmptyNotifyList();
              } else {
                notifyInfoListWithCurrentDate
                    .sort((a, b) => a.date.compareTo(b.date));
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: notifyInfoListWithCurrentDate.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return NotifyMedicineCard(
                        notifyInfo: notifyInfoListWithCurrentDate[index],
                      );
                    },
                  ),
                );
              }
            } else {
              return const EmptyNotifyList();
            }
          },
        )
      ],
    );
  }

  Color? getExpansionPanelColor(int index) {
    final List<Color> panelColor = [
      Colors.greenAccent.shade200,
      Colors.yellow.shade300,
      Colors.limeAccent.shade100,
      Colors.lightGreenAccent.shade200,
    ];
    return panelColor[index];
  }

  List<NotifyInfoModel> inCurrentDate(
      Iterable<NotifyInfoModel> notifyInfoList) {
    return notifyInfoList.map((e) => e).where((element) {
      var start = currentDate;
      var end = currentDate.add(const Duration(days: 1));
      return element.date.isAfter(start) && element.date.isBefore(end);
    }).toList();
  }

  TimeOfDay toTimeOfDay(TimeOfDayModel timeOfDayModel) {
    return TimeOfDay(hour: timeOfDayModel.hour, minute: timeOfDayModel.minute);
  }
}

class ChooseDate extends StatelessWidget {
  const ChooseDate({super.key, required this.currentDate});
  final DateTime currentDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            DateFormat.yMMMMEEEEd('th').formatInBuddhistCalendarThai(
              currentDate,
            ),
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class MedicineCardList extends StatelessWidget {
  const MedicineCardList({
    super.key,
    required this.notifyInfoListCurrentDate,
  });

  final Iterable<NotifyInfoModel> notifyInfoListCurrentDate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: notifyInfoListCurrentDate.map((notifyInfo) {
        return NotifyCard(
          notifyInfo: notifyInfo,
        );
      }).toList(),
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
            height: 300,
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "วันนี้ไม่มีรายการแจ้งเตือน",
            style: TextStyle(
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class NotifyCard extends StatelessWidget {
  const NotifyCard({
    required this.notifyInfo,
    super.key,
  });
  final NotifyInfoModel notifyInfo;

  //final String _emptyPicture = "assets/images/dummy_picture.jpg";
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
              height: 230,
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
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              notifyInfo.description,
                            ),
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
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: MedicineInfoOnCard(
                                            notifyInfo: notifyInfo),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: notifyInfo.medicineInfo
                                                        .picture_path ==
                                                    '' ||
                                                notifyInfo.medicineInfo
                                                        .picture_path ==
                                                    null
                                            ? Image.asset(
                                                emptyPicture,
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
                          ],
                        ),
                      )
                    ],
                  )),
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
          //'${notifyInfo.medicineInfo.description.replaceAll('\n', ' ').substring(0, notifyInfo.medicineInfo.description.length >= 40 ? 40 : notifyInfo.medicineInfo.description.length)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          getHowtoEat(notifyInfo),
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        notifyInfo.medicineInfo.order != ""
            ? Text(
                getOrderInThai(notifyInfo),
                style: const TextStyle(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : Container(),
        Text(
          getPeroidInThai(notifyInfo),
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    );
  }

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
          ? Text(
              displayStatus(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          : Text(
              displayStatus(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
    );
  }

  String displayStatus() {
    String statusDisplay;
    if (notifyInfo.status == 0) {
      statusDisplay = "<type>แล้ว";
    } else {
      statusDisplay = "ยังไม่<type>";
    }
    switch (notifyInfo.medicineInfo.type) {
      case "pills":
      case "water":
        statusDisplay = statusDisplay.replaceAll("<type>", "กิน");
        break;
      case "arrow":
        statusDisplay = statusDisplay.replaceAll("<type>", "ฉีด");
        break;
      case "drop":
        statusDisplay = statusDisplay.replaceAll("<type>", "หยอด/พ่น");
        break;
    }
    return statusDisplay;
  }
}

class AddNotifyButton extends StatelessWidget {
  const AddNotifyButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(), padding: const EdgeInsets.all(10)),
        onPressed: onTap,
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
