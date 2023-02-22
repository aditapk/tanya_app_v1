// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'components/number_of_dose_selection.dart';
import 'components/picture_medicine_card.dart';
import 'components/take_medicine_and_time_selection.dart';
import 'components/type_medicine_selection.dart';

class MedicineInfoEditorScreen extends StatefulWidget {
  MedicineInfoEditorScreen({this.medicineData, super.key});

  MedicineInfo? medicineData;

  @override
  State<MedicineInfoEditorScreen> createState() =>
      _MedicineInfoEditorScreenState();
}

class _MedicineInfoEditorScreenState extends State<MedicineInfoEditorScreen> {
  int? index;

  final _nameTextController = TextEditingController();

  final _detailTextController = TextEditingController();

  final _numberOfDoseController = TextEditingController();

  final String _emptyPicture = "assets/images/dummy_picture.jpg";

  final medicineInfoState = Get.find<MedicineEditorState>();

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
      medicineInfoState.picture_path(_emptyPicture);
    }
    medicineInfoState.moning_time(medicineData.period_time[0]);
    medicineInfoState.lunch_time(medicineData.period_time[1]);
    medicineInfoState.evening_time(medicineData.period_time[2]);
    medicineInfoState.bed_time(medicineData.period_time[3]);
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _detailTextController.dispose();
    _numberOfDoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // add data to state
    if (widget.medicineData != null) _updateCurrenState(widget.medicineData!);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
            widget.medicineData == null ? "เพิ่มรายการยา" : "แก้ไขรายการยา"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PictureMedicineCard(),
                const SizedBox(height: 30),
                // Name
                TextFormField(
                  controller: _nameTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ชื่อยา',
                  ),
                ),
                const SizedBox(height: 20),
                // Description
                TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _detailTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'รายละเอียดยา',
                  ),
                ),
                const SizedBox(height: 10),
                // Type
                const Text("ชนิดยา"),
                const SizedBox(height: 10),
                TypeMedicineSeletion(),
                const SizedBox(height: 20),
                // Number of Dose

                NumberOfDoseSelection(
                  controller: _numberOfDoseController,
                ),
                const SizedBox(height: 10),
                const Text("ช่วงเวลาการกิน"),
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
                            backgroundColor: Colors.green.shade400,
                          ),
                          onPressed: () async {
                            // add new data
                            if (widget.medicineData != null) {
                              await _updateMedicineInfoBox();
                            } else {
                              // create new in box database
                              await _createMedicineInfoBox();
                            }
                            Get.back();
                          },
                          child: const Text(
                            "ยืนยัน",
                            style: TextStyle(
                              fontSize: 25,
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
                            backgroundColor: Colors.red.shade300,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            "ยกเลิก",
                            style: TextStyle(
                              fontSize: 25,
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

    await widget.medicineData?.save();
  }

  Future<void> _createMedicineInfoBox() async {
    var medicineInfoBox = Hive.box<MedicineInfo>("user_medicine_info");

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
      picture_path: medicineInfoState.picture_path.value == _emptyPicture
          ? null
          : medicineInfoState.picture_path.value,
    );
    await medicineInfoBox.add(newMedicineData);
  }
}
