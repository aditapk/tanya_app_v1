import 'dart:io';

//import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
//import 'package:path/path.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/utils/style.dart';

import 'components/add_notify_detail_screen.dart';

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
                      DateFormat.yMMMMd('th').format(
                        currentDate,
                      ),
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
        // Container(
        //   padding: const EdgeInsets.only(
        //     left: 8.0,
        //     right: 8.0,
        //   ),
        //   child: DatePicker(
        //     DateTime(2023, 2, 1),
        //     width: 60,
        //     height: 100,
        //     locale: 'th_TH',
        //     selectedTextColor: Colors.white,
        //     initialSelectedDate: DateTime.now(),
        //     selectionColor: Colors.blue.shade500,
        //     onDateChange: (selectedDate) {
        //       setState(() {
        //         currentDate = selectedDate;
        //       });
        //     },
        //   ),
        // ),
        SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height - 213,
            ),
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
                    return ListView(
                      shrinkWrap: true,
                      children: notifyInfoListWithCurrentDate.map((notifyInfo) {
                        return NotifyCard(
                          notifyInfo: notifyInfo,
                        );
                      }).toList(),
                    );
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

class EmptyNotifyList extends StatelessWidget {
  const EmptyNotifyList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
              height: 160,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: notifyInfo.medicineInfo.picture_path == '' ||
                                notifyInfo.medicineInfo.picture_path == null
                            ? Image.asset(
                                _emptyPicture,
                                fit: BoxFit.cover,
                                height: 150,
                              )
                            : Image.file(
                                File(notifyInfo.medicineInfo.picture_path!),
                                fit: BoxFit.cover,
                                height: 150,
                              ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notifyInfo.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(notifyInfo.description),
                            Text("เวลา ${TimeOfDay(
                              hour: notifyInfo.time.hour,
                              minute: notifyInfo.time.minute,
                            ).format(context)}"),
                            const Divider(
                              thickness: 2,
                            ),
                            MedicineInfoOnCard(notifyInfo: notifyInfo),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
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
    var unit = notifyInfo.medicineInfo.unit;
    String prefixType = (type == 'pills' || type == 'water')
        ? "รับประทาน"
        : (type == 'arrow')
            ? "ใช้ฉีด"
            : "ใช้หยด";
    return "$prefixType $nTake $unit";
  }

  getOrderInThai(NotifyInfoModel notifyInfo) {
    var order = notifyInfo.medicineInfo.order;
    String orderThai = order == "before" ? "ก่อนอาหาร" : "หลังอาหาร";
    return orderThai;
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
            fontSize: 16,
          ),
        ),
        Text(
          notifyInfo.medicineInfo.description,
        ),
        Text(getHowtoEat(notifyInfo)),
        Text(getOrderInThai(notifyInfo)),
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
      width: 100,
      height: 40,
      padding: const EdgeInsets.all(8),
      decoration: notifyInfo.status == 0
          ? BoxDecoration(
              color: Colors.green.shade200,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8))
          : BoxDecoration(
              color: Colors.red.shade200,
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(8)),
      child: notifyInfo.status == 0
          ? const Text(
              "กินยาแล้ว",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            )
          : const Text(
              "ยังไม่กินยา",
              style: TextStyle(fontSize: 16),
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
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        onPressed: onTap,
        child: const Text("+ เพิ่มรายการ"),
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
