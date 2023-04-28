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
// import 'package:printing/printing.dart';
//import 'package:open_file/open_file.dart';
//import 'package:open_file/open_file.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';
import 'package:tanya_app_v1/Model/user_login_model.dart';
//import 'package:intl/intl.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_editor_screen/medicine_info_editor_screen.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_list_screen/components/display_medicine_info_list.dart';
import 'package:tanya_app_v1/Screen/Login/login_screen_selection.dart';
import 'package:tanya_app_v1/Screen/Report/medical_report_screen.dart';
import 'package:tanya_app_v1/Screen/UserInfo/user_info_screen.dart';
//import 'package:tanya_app_v1/utils/style.dart';
import '../../GetXBinding/medicine_state_binding.dart';
//import 'body_notify_list.dart';
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
      elevation: 2,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.logout,
        ),
        onPressed: () async {
          var userLoginBox = Hive.box<UserLogin>('user_login');
          var userLogin = userLoginBox.get(0);
          userLogin!.logOut = true;
          await userLogin.save();
          Get.to(const LoginScreenSelection());
        },
      ),
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
    );
  }

  void _createMedicineInfo() {
    // ไปยังหน้า เพิ่มรายการยา
    Get.to(
      () => const MedicineInfoEditorScreen(),
      binding: MedicineInfoBinding(),
    );
  }

  void generatePDFReport() async {
    // start-end date
    final appState = Get.find<MedicineEditorState>();
    final startDateString = DateFormat.yMMMMd('th_TH')
        .formatInBuddhistCalendarThai(appState.filterStartDate.value);
    final endDateString = DateFormat.yMMMMd('th_TH')
        .formatInBuddhistCalendarThai(appState.filterEndDate.value);

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
    var userInfoBox = Hive.box<UserInfo>('user_info');
    var userInfo = userInfoBox.get(0);

    // medicine info
    var notifyInfoBox = Hive.box<NotifyInfoModel>('user_notify_info');
    var notifyInfo = notifyInfoBox.values.toList();
    List<NotifyInfoModel> notifyInfoInRange = [];
    notifyInfoInRange = notifyInfo.where((notify) {
      if (notify.date.isAfter(appState.filterStartDate.value) &&
          notify.date.isBefore(appState.filterEndDate.value)) {
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
