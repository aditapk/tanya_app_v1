import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:intl/intl.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_editor_screen/medicine_info_editor_screen.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_list_screen/components/display_medicine_info_list.dart';
import 'package:tanya_app_v1/Screen/UserInfo/user_info_screen.dart';
//import 'package:tanya_app_v1/utils/style.dart';
import '../../GetXBinding/medicine_state_binding.dart';
//import 'body_notify_list.dart';
import 'Model/user_info_model.dart';
import 'Screen/Notify/notify_screen.dart';
//import 'forTest/local_notify/body_notify_list.dart';

class HomeAppScreen extends StatefulWidget {
  HomeAppScreen({super.key, this.selectedPage});

  int? selectedPage;

  @override
  State<HomeAppScreen> createState() => _HomeAppScreenState();
}

class _HomeAppScreenState extends State<HomeAppScreen> {
  AppBar get myAppBar {
    return AppBar(
      automaticallyImplyLeading: false,
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
            child: ValueListenableBuilder(
              valueListenable: Hive.box<UserInfo>('user_info').listenable(),
              builder: (_, userInfoBox, __) {
                var userInfo = userInfoBox.get(0);
                if (userInfo != null) {
                  if (userInfo.picturePath != null) {
                    return CircleAvatar(
                      child: ClipOval(
                        child: Image.file(
                          File(userInfo.picturePath!),
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    );
                  }
                  return const CircleAvatar(
                    child: Icon(Icons.person),
                  );
                }
                return const CircleAvatar(
                  child: Icon(Icons.person),
                );
              },
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
    if (widget.selectedPage != null) {
      _selectedIndex = widget.selectedPage!;
    }
  }

  List<String> titlePageList = <String>[
    "รายการแจ้งเตือน",
    "รายการยา",
    "ข้อมูลสรุป",
    "ข้อมูลผู้ใช้",
  ];

  List<Widget> bodyPageList = const <Widget>[
    NotifyScreen(), // หน้า รายการแจ้งเตือน
    DisplayMedicineInfoList(), //หน้า รายการยา
    Center(
      child: Text("สรุป"),
    ),
    UserInfoScreen(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
    if (_selectedIndex == 1) {
      // ไปยังหน้า เพิ่มรายการยา
      Get.to(
        () => MedicineInfoEditorScreen(),
        binding: MedicineInfoBinding(),
      );
    }
    if (_selectedIndex == 0) {
      debugPrint('test notification');
    }
  }
}
