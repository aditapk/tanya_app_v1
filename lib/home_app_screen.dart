import 'dart:io';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';
import 'package:tanya_app_v1/Model/user_login_model.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_editor_screen/medicine_info_editor_screen.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_list_screen/components/display_medicine_info_list.dart';
import 'package:tanya_app_v1/Screen/Login/login_screen_selection.dart';
import 'package:tanya_app_v1/Screen/Report/medical_report_screen.dart';
import 'package:tanya_app_v1/Screen/UserInfo/user_info_screen.dart';
import 'package:tanya_app_v1/utils/constans.dart';
import '../../GetXBinding/medicine_state_binding.dart';
import 'Model/notify_info.dart';
import 'Model/user_info_model.dart';
import 'Screen/Notify/notify_screen.dart';
//import 'forTest/local_notify/body_notify_list.dart';
// for pdf
import 'package:pdf/widgets.dart' as pw;

class HomeAppScreen extends StatefulWidget {
  const HomeAppScreen({super.key, this.selectedPage});

  final int? selectedPage;

  @override
  State<HomeAppScreen> createState() => _HomeAppScreenState();
}

class _HomeAppScreenState extends State<HomeAppScreen> {
  AppBar get myAppBar {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: PopupMenuButton(
          offset: const Offset(10, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder: (context) => const [
                PopupMenuItem(
                    value: 0,
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('ออกจากระบบ'),
                    ))
              ],
          onSelected: (value) async {
            switch (value) {
              case 0:
                var userLoginBox =
                    Hive.box<UserLogin>(HiveDatabaseName.USER_LOGIN);
                var userLogin = userLoginBox.get(0);
                userLogin!.logOut = true;
                await userLogin.save();
                Get.offAll(() => const LoginScreenSelection());
                break;
            }
          }),
      title: Text(titlePageList[_selectedIndex]),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              _onItemTapped(3);
            },
            child: ValueListenableBuilder(
              valueListenable:
                  Hive.box<UserInfo>(HiveDatabaseName.USER_INFO).listenable(),
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
                  return const DummyAvatarWidget();
                }
                return const DummyAvatarWidget();
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: _selectedIndex);
    super.initState();
    initializeDateFormatting('th_TH');
    if (widget.selectedPage != null) {
      _selectedIndex = widget.selectedPage!;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int newIndex) {
    setState(() {
      _selectedIndex = newIndex;
    });
  }

  void _onItemTapped(int newIndex) {
    _pageController.animateToPage(newIndex,
        duration: const Duration(microseconds: 300), curve: Curves.easeInOut);
  }

  final List<String> titlePageList = <String>[
    "รายการยา",
    "รายการแจ้งเตือน",
    "ข้อมูลสรุป",
    "ข้อมูลผู้ใช้",
  ];

  final List<Widget> bodyPageList = <Widget>[
    const DisplayMedicineInfoList(), //หน้า รายการยา
    const NotifyScreen(), // หน้า รายการแจ้งเตือน
    const MedicineReportScreen(),
    const UserInfoScreen(),
  ];

  late PageController _pageController;

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: myAppBar,
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: bodyPageList,
        ),
        //bodyPageList[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.black54,
          onTap: _onItemTapped,
          // (index) {
          //   setState(() {
          //     _selectedIndex = index;
          //   });
          // },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "รายการยา",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm_outlined),
              label: "แจ้งเตือน",
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
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: _createMedicineInfo,
                child: const Icon(Icons.add),
              )
            : _selectedIndex == 2
                ? FloatingActionButton(
                    onPressed: generatePDFReport,
                    child: const Icon(Icons.picture_as_pdf),
                  )
                : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat);
  }

  void _createMedicineInfo() {
    // ไปยังหน้า เพิ่มรายการยา
    Get.to(
      () => const MedicineInfoEditorScreen(),
      binding: AppInfoBinding(),
    );
  }

  void generatePDFReport() async {
    // start-end date
    final reportState = Get.find<ReportFilterState>();
    final startDateString = DateFormat.yMMMMd('th_TH')
        .formatInBuddhistCalendarThai(reportState.filterStartDate.value);
    final endDateString = DateFormat.yMMMMd('th_TH')
        .formatInBuddhistCalendarThai(reportState.filterEndDate.value);

    // Header
    final font =
        await rootBundle.load("assets/fonts/TH Sarabun New Regular.ttf");
    final ttf = pw.Font.ttf(font);
    final currentDate = DateTime.now();
    final thDateString =
        DateFormat.yMMMMd('th_TH').formatInBuddhistCalendarThai(currentDate);
    final currentTime = TimeOfDay.now();
    var hour = currentTime.hour;
    hour = hour != 24 ? hour : 0;
    // user data
    var userInfoBox = Hive.box<UserInfo>(HiveDatabaseName.USER_INFO);
    var userInfo = userInfoBox.get(0);

    // medicine info
    var notifyInfoBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
    var notifyInfo = notifyInfoBox.values.toList();
    List<NotifyInfoModel> notifyInfoInRange = [];
    notifyInfoInRange = notifyInfo.where((notify) {
      if (notify.date.isAfter(reportState.filterStartDate.value) &&
          notify.date.isBefore(reportState.filterEndDate.value)) {
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
    var notifyList = notifySet.toList();

    // find number of notify each medicine
    Map<String, int> nNotifyEachMedicine = {};
    Map<String, int> nNotifyCompleteEachMedicine = {};
    Map<String, String> medicineNameEachNotify = {};

    for (var notify in notifyList) {
      nNotifyCompleteEachMedicine[notify] = 0;
      nNotifyEachMedicine[notify] = 0;
      medicineNameEachNotify[notify] = '';
    }

    for (var notify in notifyInfoInRange) {
      var notifyName = notify.name;
      if (notify.status == 0) {
        nNotifyCompleteEachMedicine.update(notifyName, (value) => value + 1);
      }
      nNotifyEachMedicine.update(notifyName, (value) => value + 1);
      medicineNameEachNotify.update(
          notifyName, (value) => notify.medicineInfo.name);
    }
    final List<List<dynamic>> notifyReport = [
      [
        'ชื่อยา',
        'จำนวนครั้งที่กินยา',
        'จำนวนครั้งที่ต้องกิน',
        'เปอร์เซนต์การกินยา'
      ]
    ];
    for (var notify in notifyList) {
      notifyReport.add([
        medicineNameEachNotify[notify],
        nNotifyCompleteEachMedicine[notify].toString(),
        nNotifyEachMedicine[notify].toString(),
        '${(nNotifyCompleteEachMedicine[notify]! / nNotifyEachMedicine[notify]! * 100).toStringAsFixed(0)} %',
      ]);
    }
    // create pdf document
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Row(
                    children: [
                      pw.Text(
                          'รายงานสรุปการกินยา วันที่ $thDateString เวลา ${hour == 0 ? '00' : hour}.${currentTime.minute < 10 ? '0${currentTime.minute}' : currentTime.minute} น.',
                          style: pw.TextStyle(
                              font: ttf,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),
                ),
                pw.Text(
                  'ชื่อ ${userInfo?.name ?? 'ไม่ระบุ'}',
                  style: pw.TextStyle(font: ttf),
                ),
                pw.Text(
                  'สรุปการกินยาตั้งแต่ วันที่ $startDateString ถึง วันที่ $endDateString',
                  style: pw.TextStyle(font: ttf),
                ),
                pw.Table.fromTextArray(
                  headerStyle: pw.TextStyle(font: ttf),
                  cellStyle: pw.TextStyle(font: ttf),
                  cellAlignments: {
                    1: pw.Alignment.center,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center
                  },
                  context: context,
                  data: notifyReport,
                ),
              ]);
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final dateString = DateFormat.MMMd('th_TH').format(DateTime.now());
    final file = File('${tempDir.path}/Report_$dateString.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  void floatingAction() {
    if (_selectedIndex == 1) {
      _createMedicineInfo();
    }
    if (_selectedIndex == 2) {
      // print pdf
    }
  }
}

class DummyAvatarWidget extends StatelessWidget {
  const DummyAvatarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.blue.shade100,
      child: const Icon(Icons.person),
    );
  }
}
