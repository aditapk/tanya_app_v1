import 'dart:io';

import 'package:buddhist_datetime_dateformat_sns/buddhist_datetime_dateformat_sns.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import 'package:showcaseview/showcaseview.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';
import 'package:tanya_app_v1/Model/user_login_model.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_editor_screen/medicine_info_editor_screen.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_list_screen/components/display_medicine_info_list.dart';
import 'package:tanya_app_v1/Screen/Login/login_screen_selection.dart';
import 'package:tanya_app_v1/Screen/Report/medical_report_screen.dart';
import 'package:tanya_app_v1/Screen/UserInfo/user_info_screen.dart';
import 'package:tanya_app_v1/Services/hive_db_services.dart';
import 'package:tanya_app_v1/Services/notify_services.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../GetXBinding/medicine_state_binding.dart';
import 'Model/medicine_info_model.dart';
import 'Model/notify_info.dart';
import 'Model/user_info_model.dart';
import 'Screen/Notify/notify_screen.dart';

// for pdf
import 'package:pdf/widgets.dart' as pw;

class HomeAppScreen extends StatefulWidget {
  const HomeAppScreen({
    super.key,
    this.selectedPage,
    this.context,
    this.showHelp,
  });

  final int? selectedPage;
  final BuildContext? context;
  final bool? showHelp;

  @override
  State<HomeAppScreen> createState() => _HomeAppScreenState();
}

class _HomeAppScreenState extends State<HomeAppScreen> {
  @override
  void initState() {
    if (widget.showHelp ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          ShowCaseWidget.of(context)
              .startShowCase([helpShowCaseKey, helpDocShowCaseKey]));
    }
    super.initState();
  }

  void setBeginnerUsertoHive(bool value) {
    var userLoginBox = Hive.box<UserLogin>(HiveDatabaseName.USER_LOGIN);
    var userLogin = userLoginBox.get(0);
    userLogin!.beginningUse = value;
    userLogin.save();
  }

  @override
  void dispose() {
    // set not be beginner user
    setBeginnerUsertoHive(false);
    super.dispose();
  }

  final List<String> titlePageList = <String>[
    "รายการยา",
    "รายการแจ้งเตือน",
    "ข้อมูลสรุป",
    "ข้อมูลผู้ใช้",
  ];

  // help
  final helpShowCaseKey = GlobalKey();
  final helpDocShowCaseKey = GlobalKey();

  // Page Medicine List
  final addMedicineFloatingButtonShowCaseKey = GlobalKey();
  final changeImageOnCardShowCaseKey = GlobalKey();
  final toMedicineNotifyDetailShowCaseKey = GlobalKey();
  final editMedicineShowCaseKey = GlobalKey();
  final deleteMedicineShowCaseKey = GlobalKey();

  // Page Notify
  final chooseDateShowcaseKey = GlobalKey();

  // Page Report
  final chooseIntervalDateShowCaseKey = GlobalKey();
  final generatePDFFloatingButtonShowCaseKey = GlobalKey();

  // Page User Info
  final generalInfoShowCaseKey = GlobalKey();
  final medicineInfoShowCaseKey = GlobalKey();
  final appointmentInfoShowCase = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var pageController = Get.find<PageState>();
    return GetBuilder(
      init: pageController,
      builder: (controller) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: Showcase(
                key: helpDocShowCaseKey,
                targetBorderRadius: BorderRadius.circular(12),
                description: "ปุ่มข้อมูลการใช้งานเพิ่มเติม",
                child: PopupMenuButton(
                    offset: const Offset(10, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 3,
                            child: ListTile(
                              leading: Icon(Icons.help),
                              title: Text('คู่มือการใช้งาน'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 5,
                            child: ListTile(
                              leading: Icon(Icons.error),
                              title: Text('คำถามที่พบบ่อย'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 4,
                            child: ListTile(
                              leading: Icon(Icons.face),
                              title: Text('ตอบปัญหาการใช้งาน'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: ListTile(
                              leading: ImageIcon(
                                  AssetImage("assets/icons/remove-user-2.png")),
                              title: Text('ลบข้อมูลผู้ใช้'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('ลบข้อมูลทั้งหมด'),
                            ),
                          ),
                          PopupMenuItem(
                            value: 0,
                            child: ListTile(
                              leading: Icon(Icons.logout),
                              title: Text('ออกจากระบบ'),
                            ),
                          ),
                        ],
                    onSelected: (value) async {
                      switch (value) {
                        case 0:
                          var userLoginBox =
                              Hive.box<UserLogin>(HiveDatabaseName.USER_LOGIN);
                          var userLogin = userLoginBox.get(0);
                          userLogin!.logOut = true;
                          await userLogin.save();
                          await Get.offAll(() => const LoginScreenSelection());
                          break;
                        case 1:
                          Get.defaultDialog(
                              title: "ลบข้อมูลผู้ใช้",
                              middleText: "ข้อมูลผู้ใช้จะถูกลบออกจากระบบ",
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      var userInfoBox = Hive.box<UserInfo>(
                                          HiveDatabaseName.USER_INFO);
                                      var userInfo = userInfoBox.get(0);
                                      if (userInfo != null) {
                                        // clear user info
                                        var clearUserInfo = UserInfo();
                                        userInfoBox.putAt(0, clearUserInfo);
                                      }
                                      Get.back();
                                    },
                                    child: const Text(
                                      "ตกลง",
                                      style: TextStyle(fontSize: 16),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text(
                                      "ยกเลิก",
                                      style: TextStyle(fontSize: 16),
                                    )),
                              ]);
                          break;
                        case 2:
                          Get.defaultDialog(
                              title: "ลบข้อมูลทั้งหมด",
                              middleText: "ข้อมูลทั้งหมดจะถูกลบออกจากระบบ",
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      await NotifyService
                                          .localNotificationsPlugin
                                          .cancelAll();
                                      await HiveDatabaseService.deleteBox();
                                      await HiveDatabaseService.openAllBox();
                                      await Get.offAll(
                                          () => const LoginScreenSelection());
                                    },
                                    child: const Text(
                                      "ตกลง",
                                      style: TextStyle(fontSize: 16),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text(
                                      "ยกเลิก",
                                      style: TextStyle(fontSize: 16),
                                    )),
                              ]);
                          break;
                        case 3:
                          // open url
                          final Uri url = Uri.parse(Introduction.DOCUMENT_LINK);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            // have some problem for open url
                          }
                          break;
                        case 4:
                          String fbUrl = Introduction.FACEBOOK_LINK;
                          //final Uri url = Uri.parse(fbUrl);
                          if (await canLaunchUrlString(fbUrl)) {
                            await launchUrlString(fbUrl);
                          } else {
                            // have some problem for open url
                          }
                          break;
                        case 5:
                          final Uri url = Uri.parse(Introduction.FAQ_LINK);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            // have some problem for open url
                          }
                          break;
                      }
                    }),
              ),
              title: Text(titlePageList[controller.pageIndex]),
              centerTitle: true,
              actions: [
                Showcase(
                  key: helpShowCaseKey,
                  targetBorderRadius: BorderRadius.circular(12),
                  description: "ปุ่มแนะนำวิธีใช้งาน",
                  child: IconButton(
                      onPressed: () {
                        //if (_selectedIndex == 0) {
                        if (controller.pageIndex == 0) {
                          // handle empty case
                          var medicineBox = Hive.box<MedicineInfo>(
                              HiveDatabaseName.MEDICINE_INFO);
                          if (medicineBox.isEmpty) {
                            setState(() {
                              ShowCaseWidget.of(context).startShowCase([
                                addMedicineFloatingButtonShowCaseKey,
                              ]);
                            });
                          } else {
                            setState(() {
                              ShowCaseWidget.of(context).startShowCase([
                                changeImageOnCardShowCaseKey,
                                toMedicineNotifyDetailShowCaseKey,
                                editMedicineShowCaseKey,
                                deleteMedicineShowCaseKey,
                              ]);
                            });
                          }
                        } else if (controller.pageIndex == 1) {
                          setState(() {
                            ShowCaseWidget.of(context).startShowCase([
                              chooseDateShowcaseKey,
                            ]);
                          });
                        } else if (controller.pageIndex == 2) {
                          setState(() {
                            ShowCaseWidget.of(context).startShowCase([
                              chooseIntervalDateShowCaseKey,
                              generatePDFFloatingButtonShowCaseKey
                            ]);
                          });
                        } else if (controller.pageIndex == 3) {
                          setState(() {
                            ShowCaseWidget.of(context).startShowCase([
                              generalInfoShowCaseKey,
                              medicineInfoShowCaseKey,
                              appointmentInfoShowCase,
                            ]);
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.help_outline_rounded,
                        size: 24,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      _onItemTapped(3);
                    },
                    child: ValueListenableBuilder(
                      valueListenable:
                          Hive.box<UserInfo>(HiveDatabaseName.USER_INFO)
                              .listenable(),
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
            ),
            body: PageView(
              controller: controller.pageController,
              onPageChanged: _onPageChanged,
              children: [
                DisplayMedicineInfoList(
                  changeImageShowCaseKey: changeImageOnCardShowCaseKey,
                  toMedicineNotifyShowCaseKey:
                      toMedicineNotifyDetailShowCaseKey,
                  editMedicineShowCaseKey: editMedicineShowCaseKey,
                  deleteMedicineShowCaseKey: deleteMedicineShowCaseKey,
                ), //หน้า รายการยา
                NotifyScreen(
                  showcaseKey: chooseDateShowcaseKey,
                ), // หน้า รายการแจ้งเตือน
                MedicineReportScreen(
                  showcaseKey: chooseIntervalDateShowCaseKey,
                ),
                UserInfoScreen(
                  generalInfoShowCaseKey: generalInfoShowCaseKey,
                  medicalInfoShowCaseKey: medicineInfoShowCaseKey,
                  appointmentInfoShowCaseKey: appointmentInfoShowCase,
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0,
              currentIndex: controller.pageIndex,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.black54,
              onTap: _onItemTapped,
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
            floatingActionButton: controller.pageIndex == 0
                ? Showcase(
                    key: addMedicineFloatingButtonShowCaseKey,
                    targetBorderRadius: BorderRadius.circular(30),
                    description: "ปุ่มเพิ่มรายการยา",
                    child: FloatingActionButton(
                      onPressed: _createMedicineInfo,
                      child: const Icon(Icons.add),
                    ),
                  )
                : controller.pageIndex == 2
                    ? Showcase(
                        key: generatePDFFloatingButtonShowCaseKey,
                        targetBorderRadius: BorderRadius.circular(30),
                        description: "สร้างเอกสารสรุปการกินยา",
                        child: FloatingActionButton(
                          onPressed: generatePDFReport,
                          child: const Icon(Icons.picture_as_pdf),
                        ),
                      )
                    : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat);
      },
    );
  }

  void _createMedicineInfo() {
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
                // ignore: deprecated_member_use
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
    var pageController = Get.find<PageState>();

    if (pageController.pageIndex == 1) {
      _createMedicineInfo();
    }

    if (pageController.pageIndex == 2) {
      // print pdf
    }
  }

  void _onPageChanged(int newIndex) {
    var pageStateController = Get.find<PageState>();
    pageStateController.changePageIndexTo(newIndex);
  }

  void _onItemTapped(int newIndex) {
    var pageController = Get.find<PageState>();
    pageController.changePageto(newIndex);
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
