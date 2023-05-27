// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/utils/constans.dart';
import '../../../constants.dart';
import 'components/number_of_dose_selection.dart';
import 'components/picture_medicine_card.dart';
import 'components/take_medicine_and_time_selection.dart';
import 'components/type_medicine_selection.dart';

class MedicineInfoEditorScreen extends StatefulWidget {
  const MedicineInfoEditorScreen({
    this.medicineData,
    super.key,
    this.mode,
  });

  final MedicineInfo? medicineData;
  final String? mode; // can be "edit", "create"

  @override
  State<MedicineInfoEditorScreen> createState() =>
      _MedicineInfoEditorScreenState();
}

class _MedicineInfoEditorScreenState extends State<MedicineInfoEditorScreen> {
  final medicineInfoState = Get.find<MedicineEditorState>();
  int? index;
  final _nameTextController = TextEditingController();
  final _detailTextController = TextEditingController();
  final _numberOfDoseController = TextEditingController();

  @override
  void dispose() {
    _nameTextController.dispose();
    _detailTextController.dispose();
    _numberOfDoseController.dispose();
    super.dispose();
  }

  List<Color> colors = [
    Colors.blue.shade200,
    Colors.pink.shade200,
    Colors.green.shade200,
    Colors.yellow.shade200,
    Colors.cyan.shade200,
    Colors.lime.shade200,
    Colors.amber.shade200,
    Colors.brown.shade200,
    Colors.blue.shade400,
    Colors.pink.shade400,
    Colors.green.shade400,
    Colors.yellow.shade400,
    Colors.cyan.shade400,
    Colors.lime.shade400,
    Colors.amber.shade400,
    Colors.brown.shade400,
  ];

  @override
  Widget build(BuildContext context) {
    // add data to state
    if (widget.medicineData != null) {
      _updateCurrenState(widget.medicineData!);
      //print(widget.medicineData!.id);
    } else {
      var boxMedicineInfo =
          Hive.box<MedicineInfo>(HiveDatabaseName.MEDICINE_INFO);
      var nMedicine = boxMedicineInfo.length;
      medicineInfoState.color.value = colors[nMedicine % colors.length];
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          (widget.medicineData == null) ? "เพิ่มรายการยา" : "แก้ไขรายการยา",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PictureMedicineCard(),
                const SizedBox(
                  height: 20,
                ),
                // Name
                MedicineNameWidget(nameTextController: _nameTextController),
                const SizedBox(height: 20),
                // Description
                MedicineDescriptionWidget(
                    detailTextController: _detailTextController),
                const SizedBox(height: 20),
                // Type
                const TypeMedicineSelection(),
                // const SizedBox(height: 5),
                // TypeMedicineSeletion(),
                // const SizedBox(height: 20),
                // Number of Dose
                NumberOfDoseSelection(
                  controller: _numberOfDoseController,
                ),
                const SizedBox(height: 20),
                const Text(
                  "ช่วงเวลาการกิน",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                // Time Schedule
                TakeMedicineAndTimeSelection(),
                const SizedBox(height: 20),
                // Confirmation
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.green.shade400,
                          ),
                          onPressed: () async {
                            // add new data
                            if (widget.medicineData != null) {
                              if (checkCompletedDataSelection() == null) {
                                await _updateMedicineInfoBox();
                                Get.back();
                              } else {
                                // pop up error
                                await Get.defaultDialog(
                                    title: "ข้อผิดพลาด",
                                    titleStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade400),
                                    middleText: errorMessage[
                                        checkCompletedDataSelection()]!);
                              }
                            } else {
                              // create new in box database
                              if (checkCompletedDataSelection() == null) {
                                await _createMedicineInfoBox();
                                Get.back();
                              } else {
                                // pop up error
                                await Get.defaultDialog(
                                    title: "ข้อผิดพลาด",
                                    titleStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade400),
                                    middleText: errorMessage[
                                        checkCompletedDataSelection()]!);
                              }
                            }
                          },
                          child: const Text(
                            "ยืนยัน",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.red.shade400,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            "ยกเลิก",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateCurrenState(MedicineInfo medicineData) {
    // name in Textfield
    _nameTextController.text = medicineData.name;
    // description in Textfield
    _detailTextController.text = medicineData.description;
    // number of dose
    _numberOfDoseController.text = medicineData.nTake.toString();

    // update data to widget state
    //medicineInfoState.name(medicineData.name); // update name
    //medicineInfoState.description(medicineData.description); // update description
    medicineInfoState.selected_type(medicineData.type); // update type
    medicineInfoState.selected_type_unit(medicineData.unit);
    medicineInfoState.nTake(medicineData.nTake); // update nTake
    medicineInfoState.order(medicineData.order); // updat order

    if (medicineData.picture_path != null) {
      medicineInfoState.picture_path(medicineData.picture_path);
    } else {
      medicineInfoState.picture_path(emptyPicture);
    }
    medicineInfoState.moning_time(medicineData.period_time[0]);
    medicineInfoState.lunch_time(medicineData.period_time[1]);
    medicineInfoState.evening_time(medicineData.period_time[2]);
    medicineInfoState.bed_time(medicineData.period_time[3]);

    medicineInfoState.color.value = Color(medicineData.color);
  }

  Future<void> _updateMedicineInfoBox() async {
    // update in box database
    widget.medicineData!.name = _nameTextController.text;
    widget.medicineData!.description = _detailTextController.text;
    widget.medicineData!.type = medicineInfoState.selected_type.value;
    widget.medicineData!.unit = medicineInfoState.selected_type_unit.value;
    widget.medicineData!.nTake = medicineInfoState.nTake.value;
    widget.medicineData!.order = medicineInfoState.order.value;
    widget.medicineData!.period_time = [
      medicineInfoState.moning_time.value,
      medicineInfoState.lunch_time.value,
      medicineInfoState.evening_time.value,
      medicineInfoState.bed_time.value,
    ];
    widget.medicineData!.picture_path = medicineInfoState.picture_path.value;
    widget.medicineData!.color = medicineInfoState.color.value.value;

    await widget.medicineData!.save();

    // update on notify Box
    var notifyBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
    var medicineBox = Hive.box<MedicineInfo>(HiveDatabaseName.MEDICINE_INFO);
    var medicine = medicineBox.get(widget.medicineData!.id);
    if (notifyBox.isNotEmpty) {
      var notifyList = notifyBox.values;
      for (var notify in notifyList) {
        if (notify.medicineInfo.id == widget.medicineData!.id) {
          notify.medicineInfo.name = medicine!.name;
          notify.medicineInfo.description = medicine.description;
          notify.medicineInfo.type = medicine.type;
          notify.medicineInfo.unit = medicine.unit;
          notify.medicineInfo.nTake = medicine.nTake;
          notify.medicineInfo.order = medicine.order;
          notify.medicineInfo.period_time = medicine.period_time;
          notify.medicineInfo.picture_path = medicine.picture_path;
          notify.medicineInfo.color = medicine.color;
          await notify.save();
        }
      }
    }
  }

  Future<void> _createMedicineInfoBox() async {
    var medicineInfoBox =
        Hive.box<MedicineInfo>(HiveDatabaseName.MEDICINE_INFO);

    var newMedicineData = MedicineInfo(
      name: _nameTextController.text,
      description: _detailTextController.text,
      type: medicineInfoState.selected_type.value,
      unit: medicineInfoState.selected_type_unit.value,
      nTake: medicineInfoState.nTake.value,
      order: medicineInfoState.order.value,
      period_time: [
        medicineInfoState.moning_time.value,
        medicineInfoState.lunch_time.value,
        medicineInfoState.evening_time.value,
        medicineInfoState.bed_time.value,
      ],
      picture_path: medicineInfoState.picture_path.value == emptyPicture
          ? null
          : medicineInfoState.picture_path.value,
      color: medicineInfoState.color.value.value,
    );
    int key = await medicineInfoBox.add(newMedicineData);
    // update key
    var medicineInfo = medicineInfoBox.get(key);
    medicineInfo!.id = key;
    await medicineInfo.save();
  }

  Map<int, String> errorMessage = {
    0: "กรุณากำหนดชื่อยา",
    1: "กรุณากำหนดรายละเอียดยา",
    2: "กรุณากำหนดขนาดยา",
    3: "กรุณากำหนดช่วงเวลาการกินยา"
  };

  int? checkCompletedDataSelection() {
    if (_nameTextController.text.isEmpty) {
      return 0;
    }
    if (_detailTextController.text.isEmpty) {
      return 1;
    }
    if (_numberOfDoseController.text.isEmpty) {
      return 2;
    }
    if (medicineInfoState.moning_time.isFalse &&
        medicineInfoState.lunch_time.isFalse &&
        medicineInfoState.evening_time.isFalse &&
        medicineInfoState.bed_time.isFalse) {
      return 3;
    }
    return null;
  }
}

class TypeMedicineSelection extends StatelessWidget {
  const TypeMedicineSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ชนิดยา",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TypeMedicineSeletion(),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MedicineDescriptionWidget extends StatelessWidget {
  const MedicineDescriptionWidget({
    super.key,
    required TextEditingController detailTextController,
  }) : _detailTextController = detailTextController;

  final TextEditingController _detailTextController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      controller: _detailTextController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: 'รายละเอียดยา',
      ),
    );
  }
}

class MedicineNameWidget extends StatelessWidget {
  const MedicineNameWidget({
    super.key,
    required TextEditingController nameTextController,
  }) : _nameTextController = nameTextController;

  final TextEditingController _nameTextController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _nameTextController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: 'ชื่อยา',
      ),
    );
  }
}
