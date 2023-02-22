import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_editor_screen/medicine_info_editor_screen.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_list_screen/components/display_medicine_info_list.dart';
import 'package:tanya_app_v1/forTest/local_notify/style.dart';
import '../../GetXBinding/medicine_state_binding.dart';
import 'body_notify_list.dart';

class ShowNotifyListScreen extends StatefulWidget {
  const ShowNotifyListScreen({super.key});

  @override
  State<ShowNotifyListScreen> createState() => _ShowNotifyListScreenState();
}

class _ShowNotifyListScreenState extends State<ShowNotifyListScreen> {
  AppBar get myAppBar {
    return AppBar(
      title: Text(titlePageList[_selectedIndex]),
      centerTitle: true,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 3;
              });
            },
            child: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('th_TH');
  }

  List<String> titlePageList = <String>[
    "รายการแจ้งเตือน",
    "รายการยา",
    "ข้อมูลสรุป",
    "ข้อมูลผู้ใช้",
  ];
  List<Widget> bodyPageList = <Widget>[
    BodyOfNotifyListScreen(),
    DisplayMedicineInfoList(),
    Center(
      child: Text("สรุป"),
    ),
    Center(
      child: Text("ผู้ใช้"),
    )
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar,
      body: bodyPageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_outlined),
            label: "แจ้งเตือน",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "รายการยา",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            label: "สรุป",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "ผู้ใช้",
          )
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: _createMedicineInfo,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _createMedicineInfo() {
    Get.to(
      () => MedicineInfoEditorScreen(),
      binding: MedicineInfoBinding(),
      transition: Transition.leftToRightWithFade,
      duration: const Duration(seconds: 1),
    );
  }
}
