import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/forTest/local_notify/style.dart';

import 'adding_notify_detail_screen.dart';

class BodyOfNotifyListScreen extends StatefulWidget {
  const BodyOfNotifyListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BodyOfNotifyListScreen> createState() => _BodyOfNotifyListScreenState();
}

class _BodyOfNotifyListScreenState extends State<BodyOfNotifyListScreen> {
  DateTime currentDate = DateTime.now();

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
                child: Center(
                  child: Text(
                    DateFormat.yMMMMd('th').format(
                      currentDate,
                    ),
                    style: subHeadingStyle,
                  ),
                ),
              ),
              AddNotifyButton(
                onTap: () {
                  Get.to(
                      () => AddNotifyDetailScreen(
                            selectedDate: currentDate,
                          ),
                      transition: Transition.leftToRightWithFade,
                      duration: const Duration(seconds: 1));
                },
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: DatePicker(
            DateTime.now(),
            width: 80,
            height: 100,
            locale: 'th_TH',
            selectedTextColor: Colors.white,
            initialSelectedDate: DateTime.now(),
            selectionColor: Colors.blue.shade500,
            onDateChange: (selectedDate) {
              setState(() {
                currentDate = selectedDate;
              });
            },
          ),
        ),
        SingleChildScrollView(
          child: Text('SingleChildScrollView'),
        )
      ],
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
