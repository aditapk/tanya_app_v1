import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SelectedIntervalTime extends StatefulWidget {
  const SelectedIntervalTime({
    super.key,
    this.startDateTime,
    this.endDateTime,
  });
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  @override
  State<SelectedIntervalTime> createState() => _SelectedIntervalTimeState();
}

class _SelectedIntervalTimeState extends State<SelectedIntervalTime> {
  final TextStyle? headerStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  TextEditingController startDateTextController = TextEditingController();
  TextEditingController endDateTextController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    //widget.startDateTime = widget.startDateTime ?? DateTime.now();
    //widget.endDateTime = widget.endDateTime ?? DateTime.now().add(const Duration(days: 1));
    if (widget.startDateTime != null) {
      startDate = DateTime(
        widget.startDateTime!.year,
        widget.startDateTime!.month,
        widget.startDateTime!.day,
        0,
        0,
      );
    }
    if (widget.endDateTime != null) {
      endDate = DateTime(
        widget.endDateTime!.year,
        widget.endDateTime!.month,
        widget.endDateTime!.day,
        0,
        0,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.startDateTime != null) {
      startDateTextController.text =
          DateFormat.yMMMMd('th').formatInBuddhistCalendarThai(startDate);
    }
    if (widget.endDateTime != null) {
      endDateTextController.text =
          DateFormat.yMMMMd('th').formatInBuddhistCalendarThai(endDate);
    }
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 20, left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'เริ่มวันที่',
                style: headerStyle,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                readOnly: true,
                controller: startDateTextController,
                decoration: InputDecoration(
                    hintText: 'ยังไม่ระบุ',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      onPressed: () async {
                        // choose start date
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2032),
                        );
                        if (selectedDate != null) {
                          startDateTextController.text = DateFormat.yMMMMd('th')
                              .formatInBuddhistCalendarThai(selectedDate);

                          startDate = selectedDate;
                        }
                      },
                    ),
                    suffixIconColor: Colors.blue.shade400,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 30, left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ถึงวันที่',
                style: headerStyle,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                readOnly: true,
                controller: endDateTextController,
                decoration: InputDecoration(
                    hintText: 'ยังไม่ระบุ',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month_outlined),
                      onPressed: () async {
                        // choose start date
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2032),
                        );
                        if (selectedDate != null) {
                          endDateTextController.text = DateFormat.yMMMMd('th')
                              .formatInBuddhistCalendarThai(selectedDate);

                          endDate = selectedDate;
                        }
                      },
                    ),
                    suffixIconColor: Colors.blue.shade400,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (startDateTextController.text.isEmpty ||
                    endDateTextController.text.isEmpty) {
                  Get.defaultDialog(
                      title: 'ผิดพลาด',
                      middleText: 'กรุณากำหนดข้อมูลให้ครบถ้วน');
                  return;
                }
                var startDateTime = startDate;
                var endDateTime = endDate;
                Get.back(result: {
                  "startDateTime": startDateTime,
                  "endDateTime": endDateTime
                });
              },
              child: const Text(
                'ตกลง',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
