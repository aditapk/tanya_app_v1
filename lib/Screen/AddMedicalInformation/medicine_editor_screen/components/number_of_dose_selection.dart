import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';

import 'number_of_dose_card.dart';
import 'package:fraction/fraction.dart';

class NumberOfDoseSelection extends StatefulWidget {
  NumberOfDoseSelection({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<NumberOfDoseSelection> createState() => _NumberOfDoseSelectionState();
}

class _NumberOfDoseSelectionState extends State<NumberOfDoseSelection> {
  //final medicineInfoState = Get.put(MedicineEditorState());
  final medicineInfoState = Get.find<MedicineEditorState>();

  final List<String> items = ['One', 'Two', 'Three', 'Four'];

  final List<String> pillsType = ['เม็ด'];

  final List<String> waterType = ['ช้อนชา', 'ช้อนโต๊ะ', 'cc', 'ml'];

  final List<String> arrowType = [
    'Unit',
    'g (gram)',
    'mg (miligram)',
    '\u00B5g (microgram)'
  ];

  final List<String> dropType = ['หยด'];

  List<String>? selectedListType(String type) {
    if (type == "pills") {
      return pillsType;
    } else if (type == "water") {
      return waterType;
    } else if (type == "arrow") {
      return arrowType;
    } else if (type == "drop") {
      return dropType;
    } else {
      return null;
    }
  }

  String? doseDisplay(String type) {
    if (type == "pills" || type == "water") {
      return "ขนาดรับประทาน";
    } else if (type == "arrow") {
      return "ขนาดฉีด";
    } else if (type == "drop") {
      return "จำนวนหยด";
    }
    return null;
  }

  String? get _nDoseError {
    final text = widget.controller.value.text;
    if (text.isEmpty) {
      return "ข้อผิดพลาด : กรุณาระบุขนาด";
    }
    // check number & support /
    final text_number = double.tryParse(text);
    if (text_number == null) {
      // check "/" in word
      int slash_idx = text.indexOf("/");
      if (slash_idx != -1) {
        final splitted = text.split("/");
        final prenum = splitted[0];
        final postnum = splitted[1];
        if (prenum.isEmpty || postnum.isEmpty) {
          return "ข้อผิดพลาด : กรุณาระบุเป็นตัวเลข";
        }
        return null;
      }
      return "ข้อผิดพลาด : กรุณาระบุเป็นตัวเลข";
    } else {
      // check over for เม็ด
      if (medicineInfoState.selected_type_unit.value == "เม็ด") {
        if (text_number > 30) {
          return "คำเตือน : ระบุขนาดเกิน 30 เม็ด";
        }
      }
      // check over for cc
      if (medicineInfoState.selected_type_unit.value == "cc") {
        if (text_number > 120) {
          return "คำเตือน : ระบุขนาดเกิน 120 cc";
        }
      }
      // check over for ml
      if (medicineInfoState.selected_type_unit.value == "ml") {
        if (text_number > 45) {
          return "คำเตือน : ระบุขนาดเกิน 45 ml";
        }
      }
    }
    //
    return null;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.text =
        medicineInfoState.nTake.value.toFraction().toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: doseDisplay(medicineInfoState.selected_type.value),
                errorText: _nDoseError,
              ),
              keyboardType: TextInputType.text,
              onChanged: (value) {
                if (_nDoseError == null ||
                    _nDoseError == "คำเตือน : ระบุขนาดเกิน 30 เม็ด" ||
                    _nDoseError == "คำเตือน : ระบุขนาดเกิน 120 cc" ||
                    _nDoseError == "คำเตือน : ระบุขนาดเกิน 45 ml") {
                  // check slash /
                  int? slash_ind = value.indexOf("/");
                  if (slash_ind == -1) {
                    medicineInfoState.nTake(double.tryParse(value));
                  } else {
                    final splitted = value.split("/");
                    final prenum = splitted[0];
                    final posenum = splitted[1];
                    if (!prenum.isEmpty && !posenum.isEmpty) {
                      final number = int.tryParse(splitted[0])! /
                          int.tryParse(splitted[1])!;
                      medicineInfoState.nTake(number);
                    }
                  }
                }
                setState(() {
                  _nDoseError;
                });
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 159,
            child: Center(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(width: 1, color: Colors.blue)),
                ),
                onChanged: (value) {
                  medicineInfoState.selected_type_unit(value);
                },
                value: medicineInfoState.selected_type_unit.value,
                items: selectedListType(medicineInfoState.selected_type.value)!
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
    // Obx(
    //   () => Row(
    //     children: [
    //       NumberOfDoseCard(
    //         text: "1",
    //         onTap: () {
    //           medicineInfoState.nTake(1);
    //         },
    //         selection: medicineInfoState.nTake.value == 1,
    //       ),
    //       NumberOfDoseCard(
    //         text: "2",
    //         onTap: () {
    //           medicineInfoState.nTake(2);
    //         },
    //         selection: medicineInfoState.nTake.value == 2,
    //       ),
    //       NumberOfDoseCard(
    //         text: "3",
    //         onTap: () {
    //           medicineInfoState.nTake(3);
    //         },
    //         selection: medicineInfoState.nTake.value == 3,
    //       ),
    //       NumberOfDoseCard(
    //         text: "4",
    //         onTap: () {
    //           medicineInfoState.nTake(4);
    //         },
    //         selection: medicineInfoState.nTake.value == 4,
    //       ),
    //       NumberOfDoseCard(
    //         text: "5",
    //         onTap: () {
    //           medicineInfoState.nTake(5);
    //         },
    //         selection: medicineInfoState.nTake.value == 5,
    //       ),
    //     ],
    //   ),
    // );
  }
}
