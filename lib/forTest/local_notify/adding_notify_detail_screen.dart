// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:intl/intl.dart'; // for datetime formatting
// import 'dart:math'; // for random variable

// class AddNotifyDetailScreen extends StatefulWidget {
//   AddNotifyDetailScreen({
//     super.key,
//     required this.selectedDate,
//   });

//   DateTime selectedDate;

//   @override
//   State<AddNotifyDetailScreen> createState() => _AddNotifyDetailScreenState();
// }

// class _AddNotifyDetailScreenState extends State<AddNotifyDetailScreen> {
//   int numberOfNotifyTimeItem = 0;

//   // State variable
//   late TextEditingController notifyName;
//   late TextEditingController notifyDetail;
//   late DateTime selectedStartNotifyDate;
//   late DateTime selectedEndNotifyDate;
//   late String seletedMedicine;
//   late TimeOfDay notifyMorningTime;
//   late TimeOfDay notifyLunchTime;
//   late TimeOfDay notifyEveningTime;
//   late TimeOfDay notifyBeforetoBedTime;

//   bool enableNotifyMoningTime = true;
//   bool enableNotifyLunchTime = false;
//   bool enableNotifyEveningTime = false;
//   bool enableNotifyBeforetoBedTime = true;
//   // ---

//   // test
//   List<List<String>> testNotifyTimeList = [
//     ["เช้า"],
//     ["เช้า", "กลางวัน"],
//     ["เช้า", "เย็น"],
//     ["กลางวัน", "เย็น", "ก่อนนอน"]
//   ];
//   List<TextFieldEditor> notifyTimeWidgetList = [];
//   List<DateTime> _notifyTimeList = [];
//   List<TextEditingController> _timeControllerList = [];
//   // ---

//   @override
//   void initState() {
//     super.initState();
//     selectedStartNotifyDate = widget.selectedDate;
//     selectedEndNotifyDate = widget.selectedDate;
//     notifyName = TextEditingController();
//     notifyDetail = TextEditingController();
//     notifyMorningTime = const TimeOfDay(hour: 8, minute: 0);
//     notifyLunchTime = const TimeOfDay(hour: 12, minute: 0);
//     notifyEveningTime = const TimeOfDay(hour: 17, minute: 0);
//     notifyBeforetoBedTime = const TimeOfDay(hour: 21, minute: 0);
//   }

//   // เริ่มการแจ้งเตือน
//   selectStartDateNotify() async {
//     DateTime? pickerDate = await showDatePicker(
//       context: context,
//       initialDate: selectedStartNotifyDate,
//       firstDate: DateTime(2022),
//       lastDate: DateTime(2032),
//     );
//     if (pickerDate != null) {
//       setState(() {
//         selectedStartNotifyDate = pickerDate;
//       });

//       if (pickerDate.isAfter(selectedEndNotifyDate)) {
//         setState(() {
//           selectedEndNotifyDate = pickerDate;
//         });
//       }
//     }
//   }

//   // สิ้นสุดการแจ้งเตือน
//   selectEndDateNotify() async {
//     DateTime? pickerDate = await showDatePicker(
//       context: context,
//       initialDate: selectedEndNotifyDate,
//       firstDate: DateTime(2022),
//       lastDate: DateTime(2032),
//     );
//     if (pickerDate != null) {
//       setState(() {
//         selectedEndNotifyDate = pickerDate;
//       });
//       if (pickerDate.isBefore(selectedStartNotifyDate)) {
//         setState(() {
//           selectedStartNotifyDate = pickerDate;
//         });
//       }
//     }
//   }

//   //เลือกรายการยา
//   selectMedicineItem() {
//     print('goto page for selecting medicine information list');
//   }

//   // เช้า
//   selectNotifyMorningTime() async {
//     final TimeOfDay? newTime = await showTimePicker(
//       context: context,
//       initialTime: notifyMorningTime,
//     );
//     if (newTime != null) {
//       setState(() {
//         notifyMorningTime = newTime;
//       });
//     }
//   }

//   // กลางวัน
//   selectNotifyLunchTime() async {
//     final TimeOfDay? newTime = await showTimePicker(
//       context: context,
//       initialTime: notifyLunchTime,
//     );
//     if (newTime != null) {
//       setState(() {
//         notifyLunchTime = newTime;
//       });
//     }
//   }

//   // เย็น
//   selectNotifyEveningTime() async {
//     final TimeOfDay? newTime = await showTimePicker(
//       context: context,
//       initialTime: notifyEveningTime,
//     );
//     if (newTime != null) {
//       setState(() {
//         notifyEveningTime = newTime;
//       });
//     }
//   }

//   // ก่อนนอน
//   selectNotifyBeforetoBedTime() async {
//     final TimeOfDay? newTime = await showTimePicker(
//       context: context,
//       initialTime: notifyBeforetoBedTime,
//     );
//     if (newTime != null) {
//       setState(() {
//         notifyBeforetoBedTime = newTime;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('เพิ่มรายการแจ้งเตือน'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(
//           left: 8.0,
//           right: 8.0,
//           top: 8.0,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextFieldEditor(
//                 title: "รายการ",
//                 hintText: "รายการแจ้งเตือน",
//                 controller: notifyName,
//               ),
//               TextFieldEditor(
//                 title: "รายละเอียด",
//                 hintText: "รายละเอียดการแจ้งเตือน",
//                 controller: notifyDetail,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFieldEditor(
//                       title: "เริ่มการแจ้งเตือน",
//                       hintText: DateFormat.yMd('th_TH').format(
//                         selectedStartNotifyDate,
//                       ),
//                       widget: IconButton(
//                         onPressed: selectStartDateNotify,
//                         icon: const Icon(
//                           Icons.calendar_month_outlined,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: TextFieldEditor(
//                       title: "สิ้นสุดการแจ้งเตือน",
//                       hintText: DateFormat.yMd('th_TH').format(
//                         selectedEndNotifyDate,
//                       ),
//                       widget: IconButton(
//                         onPressed: selectEndDateNotify,
//                         icon: const Icon(
//                           Icons.calendar_month_outlined,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               TextFieldEditor(
//                 title: "รายการยา",
//                 hintText: "เลือกรายการยา",
//                 widget: IconButton(
//                   onPressed: selectMedicineItem,
//                   icon: const Icon(
//                     Icons.list_alt_outlined,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFieldEditor(
//                       title: "เช้า",
//                       hintText: notifyMorningTime.format(context),
//                       widget: IconButton(
//                         onPressed: enableNotifyMoningTime
//                             ? selectNotifyMorningTime
//                             : null,
//                         icon: Icon(
//                           Icons.access_alarm_outlined,
//                           color: enableNotifyMoningTime
//                               ? Colors.blue
//                               : Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: TextFieldEditor(
//                       title: "กลางวัน",
//                       hintText: notifyLunchTime.format(context),
//                       widget: IconButton(
//                         onPressed: enableNotifyLunchTime
//                             ? selectNotifyLunchTime
//                             : null,
//                         icon: Icon(
//                           Icons.access_alarm_outlined,
//                           color:
//                               enableNotifyLunchTime ? Colors.blue : Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFieldEditor(
//                       title: "เย็น",
//                       hintText: notifyEveningTime.format(context),
//                       widget: IconButton(
//                         onPressed: enableNotifyEveningTime
//                             ? selectNotifyEveningTime
//                             : null,
//                         icon: Icon(
//                           Icons.access_alarm_outlined,
//                           color: enableNotifyEveningTime
//                               ? Colors.blue
//                               : Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: TextFieldEditor(
//                       title: "ก่อนนอน",
//                       hintText: notifyBeforetoBedTime.format(context),
//                       widget: IconButton(
//                         onPressed: enableNotifyBeforetoBedTime
//                             ? selectNotifyBeforetoBedTime
//                             : null,
//                         icon: Icon(
//                           Icons.access_alarm_outlined,
//                           color: enableNotifyBeforetoBedTime
//                               ? Colors.blue
//                               : Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: SizedBox(
//                         height: 52,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           onPressed: () {},
//                           child: Text('ตกลง'),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 16,
//                     ),
//                     Expanded(
//                       child: SizedBox(
//                         height: 52,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12))),
//                           onPressed: () {
//                             Get.back();
//                           },
//                           child: Text('ยกเลิก'),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   TextStyle get titleStyle {
//     return const TextStyle(
//       fontSize: 20,
//       fontWeight: FontWeight.bold,
//     );
//   }
// }

// class TextFieldEditor extends StatelessWidget {
//   TextFieldEditor({
//     super.key,
//     required this.title,
//     required this.hintText,
//     this.controller,
//     this.widget,
//   });

//   String title;
//   String hintText;
//   TextEditingController? controller;
//   Widget? widget;

//   //
//   TextStyle get titleStyle {
//     return const TextStyle(
//       fontWeight: FontWeight.bold,
//     );
//   }

//   TextStyle get subtitleStyle {
//     return const TextStyle(
//       fontSize: 16,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: titleStyle,
//           ),
//           Container(
//             margin: const EdgeInsets.only(top: 8.0),
//             padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//             height: 52,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey, width: 1.0),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     readOnly: widget == null ? false : true,
//                     style: subtitleStyle,
//                     controller: controller,
//                     decoration: InputDecoration(
//                       hintText: hintText,
//                       hintStyle: subtitleStyle,
//                       focusedBorder: const UnderlineInputBorder(
//                         borderSide: BorderSide.none,
//                       ),
//                       enabledBorder: const UnderlineInputBorder(
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   child: widget,
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class NotifyTimeWidget extends StatelessWidget {
//   NotifyTimeWidget({
//     super.key,
//     required this.titleNotifyTime,
//     required this.hintText,
//     required this.onPressed,
//   });

//   List<String> titleNotifyTime;
//   List<String> hintText;
//   List<Function()?> onPressed;

//   //titleNotifyTime = ["เช้า","กลางวัน", "เย็น", "ก่อนนอน"];
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: titleNotifyTime.length,
//       itemBuilder: (context, index) => TextFieldEditor(
//         title: titleNotifyTime[index],
//         hintText: hintText[index],
//         widget: IconButton(
//           onPressed: onPressed[index],
//           icon: const Icon(
//             Icons.access_alarm_outlined,
//             color: Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }
// }
