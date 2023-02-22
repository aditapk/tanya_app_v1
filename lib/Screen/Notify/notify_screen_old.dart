// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:tanya_app_v1/GetXBinding/medicine_state_binding.dart';
// import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_list_screen/medicine_list_screen.dart';
// import 'package:tanya_app_v1/api/notification_api.dart';
// import 'package:tanya_app_v1/forTest/local_notify/notify.dart';
// //import 'package:tanya_app/constants.dart';

// class NotifyScreen extends StatefulWidget {
//   const NotifyScreen({super.key});

//   @override
//   State<NotifyScreen> createState() => _NotifyScreenState();
// }

// class _NotifyScreenState extends State<NotifyScreen> {
//   // ----------- Variable ------------ //

//   late CalendarFormat calendarFormat;
//   late DateTime selectedDate;
//   late DateTime currentDate;

//   //final List<NotifyInformation> _notifyinfo = List<NotifyInformation>();

//   // ---------- Function ------------ //

//   @override
//   void initState() {
//     super.initState();
//     calendarFormat = CalendarFormat.week;
//     selectedDate = DateTime.now();
//     currentDate = DateTime.now();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const NavigationMenu(),
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.black),
//         backgroundColor: Colors.lightBlue,
//         automaticallyImplyLeading: true,
//         actions: const [
//           Icon(
//             Icons.notifications,
//             color: Colors.black,
//           ),
//           SizedBox(width: 10)
//         ],
//         title: const Text(
//           'รายการแจ้งเตือน',
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           CalendarCard(),
//           const SizedBox(height: 10),
//           NotifyListView(),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // int a = 1;
//           // int b = 2;
//           // print(a + b);
//           /*
//           setState(() {
//             _dummyListState = !_dummyListState;
//           });
//           */
//           //Get.toNamed("/addMedicineInformation");
//           Get.to(TestLocalNotify());
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   // --------- Build Widget Function -------------- //

//   // AppBar
//   //PreferredSizeWidget _buildAppBar(BuildContext context) => AppBarReminer();

//   // Body Screen
//   // Widget _buildBody(BuildContext context) => Column(
//   //       mainAxisAlignment: MainAxisAlignment.start,
//   //       children: [
//   //         CalendarCard(),
//   //         const SizedBox(height: 10),
//   //         NotifyListView(),
//   //       ],
//   //     );

//   // // dummy state
//   // final bool _dummyListState = false;
//   // Widget _handleNotifyList(BuildContext context) {
//   //   final bool isempty = !_dummyListState;
//   //   if (isempty) {
//   //     return _buildEmptyNotifyList(context);
//   //   }
//   //   return const Text('List');
//   // }

//   // Body:Part> Calendar
//   // Widget _buildCalendar(BuildContext context) {
//   //   //initializeDateFormatting('th');
//   //   return TableCalendar(
//   //     locale: 'th',
//   //     focusedDay: currentDate,
//   //     calendarFormat: calendarFormat,
//   //     firstDay: DateTime(2020),
//   //     lastDay: DateTime(2023),
//   //     onFormatChanged: (format) {
//   //       setState(() {
//   //         calendarFormat = format;
//   //       });
//   //     },
//   //     startingDayOfWeek: StartingDayOfWeek.monday,
//   //     headerStyle: const HeaderStyle(
//   //       headerMargin: EdgeInsets.all(10),
//   //       titleCentered: true,
//   //       leftChevronVisible: false,
//   //       rightChevronVisible: false,
//   //       formatButtonShowsNext: false,
//   //     ),
//   //     calendarStyle: CalendarStyle(
//   //       todayDecoration: BoxDecoration(
//   //         color: Colors.green.shade400,
//   //         shape: BoxShape.circle,
//   //       ),
//   //       selectedDecoration: BoxDecoration(
//   //         color: Colors.blue.shade400,
//   //         shape: BoxShape.circle,
//   //       ),
//   //     ),
//   //     selectedDayPredicate: (day) {
//   //       return isSameDay(selectedDate, day);
//   //     },
//   //     onDaySelected: (selectedDay, focusedDay) {
//   //       setState(() {
//   //         selectedDate = selectedDay;
//   //         currentDate = focusedDay;
//   //       });
//   //     },
//   //   );
//   // }

//   // // empty notify list
//   // Widget _buildEmptyNotifyList(BuildContext context) => Padding(
//   //       padding: const EdgeInsets.only(top: 40),
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         crossAxisAlignment: CrossAxisAlignment.center,
//   //         children: [
//   //           SvgPicture.asset(
//   //             'assets/icons/medical-instructor.svg',
//   //             width: 200,
//   //             height: 200,
//   //           ),
//   //           const SizedBox(height: 10),
//   //           const Text(
//   //             'Opps! You don\'t \nhave any notification',
//   //             textAlign: TextAlign.center,
//   //             style: TextStyle(fontSize: 18, color: Colors.black54),
//   //           ),
//   //         ],
//   //       ),
//   //     );

//   // Add notify information
//   // Widget _buildAddNotifyButton(BuildContext context) => FloatingActionButton(
//   //       onPressed: () {
//   //         /*
//   //         setState(() {
//   //           _dummyListState = !_dummyListState;
//   //         });
//   //         */
//   //         //Get.toNamed("/addMedicineInformation");
//   //       },
//   //       child: const Icon(Icons.add),
//   //     );
// }

// class NotifyListView extends StatelessWidget {
//   const NotifyListView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bool empty = true; // for test
//     if (!empty) {
//       return SingleChildScrollView(
//         child: TestLocalPushNotification(),
//       );
//     } else {
//       return const NotifyListEmptyView();
//     }
//   }
// }

// class TestLocalPushNotification extends StatelessWidget {
//   const TestLocalPushNotification({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Column(
//       children: [
//         buildButton(
//           title: 'Simple Notification',
//           icon: Icons.notifications,
//           onClicked: () {
//             // NotificationApi.showNotification(
//             //   title: 'Sarah Abs',
//             //   body: 'Hey! Do we have everything we need for the lunch',
//             //   payload: 'sarah.abs',
//             // );
//           },
//         ),
//         buildButton(
//           title: 'Scheduled Notification',
//           icon: Icons.notifications_active,
//           onClicked: () {},
//         ),
//         buildButton(
//           title: 'Remove Notification',
//           icon: Icons.delete_forever,
//           onClicked: () {},
//         ),
//       ],
//     ));
//   }

//   buildButton({title, icon, onClicked}) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
//       child: ElevatedButton(
//         onPressed: onClicked,
//         child: Row(
//           children: [
//             Icon(icon),
//             SizedBox(
//               width: 10,
//             ),
//             Text(title)
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NotifyListEmptyView extends StatelessWidget {
//   const NotifyListEmptyView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 40),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SvgPicture.asset(
//             'assets/icons/medical-instructor.svg',
//             width: 200,
//             height: 200,
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Opps! You don\'t \nhave any notification',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 18, color: Colors.black54),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CalendarCard extends StatelessWidget {
//   CalendarCard({super.key});
//   CalendarFormat calendarFormat = CalendarFormat.week;
//   DateTime selectedDate = DateTime.now();
//   DateTime currentDate = DateTime.now();
//   @override
//   Widget build(BuildContext context) {
//     return TableCalendar(
//       locale: 'th',
//       focusedDay: currentDate,
//       calendarFormat: calendarFormat,
//       firstDay: DateTime(2020),
//       lastDay: DateTime(2024),
//       onFormatChanged: (format) {
//         // setState(() {
//         //   calendarFormat = format;
//         // });
//       },
//       startingDayOfWeek: StartingDayOfWeek.monday,
//       headerStyle: const HeaderStyle(
//         headerMargin: EdgeInsets.all(10),
//         titleCentered: true,
//         leftChevronVisible: false,
//         rightChevronVisible: false,
//         formatButtonShowsNext: false,
//       ),
//       calendarStyle: CalendarStyle(
//         todayDecoration: BoxDecoration(
//           color: Colors.green.shade400,
//           shape: BoxShape.circle,
//         ),
//         selectedDecoration: BoxDecoration(
//           color: Colors.blue.shade400,
//           shape: BoxShape.circle,
//         ),
//       ),
//       selectedDayPredicate: (day) {
//         return isSameDay(selectedDate, day);
//       },
//       onDaySelected: (selectedDay, focusedDay) {
//         // setState(() {
//         //   selectedDate = selectedDay;
//         //   currentDate = focusedDay;
//         // });
//       },
//     );
//   }
// }

// class AppBarReminer extends StatelessWidget {
//   const AppBarReminer({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       iconTheme: const IconThemeData(color: Colors.black),
//       backgroundColor: Colors.lightBlue,
//       elevation: 2,
//       automaticallyImplyLeading: true,
//       actions: const [
//         Icon(
//           Icons.notifications,
//           color: Colors.black,
//         ),
//         SizedBox(width: 10)
//       ],
//       title: const Text(
//         'รายการแจ้งเตือน',
//         style: TextStyle(
//           color: Colors.black,
//         ),
//       ),
//       centerTitle: true,
//     );
//   }
// }

// class NavigationMenu extends StatelessWidget {
//   const NavigationMenu({super.key});

//   // ------------- Variable ------------ //

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             _buildHeaderMenu(context),
//             _buildItemMenu(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderMenu(BuildContext context) => Material(
//         color: Colors.lightBlue,
//         child: SafeArea(
//           child: Container(
//             padding: const EdgeInsets.only(
//               top: 24,
//               bottom: 24,
//             ),
//             width: double.infinity,
//             child: Column(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     debugPrint('tap on avatar');
//                   },
//                   child: const CircleAvatar(
//                     radius: 50,
//                     backgroundImage: NetworkImage(
//                         'https://pbs.twimg.com/media/FF8JmgNXsAA8jB_?format=jpg&name=4096x4096'),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'K. Aditap'.toUpperCase(),
//                   style: const TextStyle(
//                     fontSize: 28,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 const Text(
//                   'aditap@kku.ac.th',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//   Widget _buildItemMenu(BuildContext context) => Container(
//         padding: const EdgeInsets.all(24),
//         child: Wrap(
//           runSpacing: 16,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.alarm),
//               title: const Text('Notify'),
//               onTap: () {
//                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//                   builder: (context) => const NotifyScreen(),
//                 ));
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.account_box),
//               title: const Text('profile'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: const Icon(Icons.assessment),
//               title: const Text('Report'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Setting'),
//               onTap: () {},
//             ),
//             ListTile(
//               leading: const Icon(Icons.list),
//               title: const Text('รายการยา'),
//               onTap: () async {
//                 Get.back();
//                 Get.to(
//                   () => const MedicineListScreen(),
//                   binding: MedicineInfoBinding(),
//                 );
//               },
//             ),
//           ],
//         ),
//       );
// }
