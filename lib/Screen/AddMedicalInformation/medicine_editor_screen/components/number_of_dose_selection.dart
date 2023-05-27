import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';

class NumberOfDoseSelection extends StatefulWidget {
  const NumberOfDoseSelection({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<NumberOfDoseSelection> createState() => _NumberOfDoseSelectionState();
}

class _NumberOfDoseSelectionState extends State<NumberOfDoseSelection> {
  // medicine state injection
  final medicineInfoState = Get.find<MedicineEditorState>();

  final List<String> items = ['One', 'Two', 'Three', 'Four'];
  final List<String> pillsType = ['เม็ด'];
  final List<String> waterType = ['ช้อนชา', 'ช้อนโต๊ะ', 'ซีซี', 'มิลลิลิตร'];
  final List<String> arrowType = ['ยูนิต', 'กรัม', 'มิลลิกรัม', 'ไมโครกรัม'];
  final List<String> dropType = ['หยด', 'ซีซี', 'มิลลิลิตร', 'ครั้ง', 'พัฟ'];

  @override
  void initState() {
    super.initState();
    if (medicineInfoState.nTake.value % 1 == 0) {
      widget.controller.text = medicineInfoState.nTake.toInt().toString();
    } else {
      widget.controller.text = medicineInfoState.nTake.value.toString();
    }
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                  int? slashIndex = value.indexOf("/");
                  if (slashIndex == -1) {
                    medicineInfoState.nTake(double.tryParse(value));
                  } else {
                    final splitted = value.split("/");
                    final prenum = splitted[0];
                    final posenum = splitted[1];
                    if (prenum.isNotEmpty && posenum.isNotEmpty) {
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
          Expanded(
            child: SizedBox(
              width: 159,
              child: Center(
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.blue)),
                  ),
                  onChanged: (value) {
                    medicineInfoState.selected_type_unit(value);
                  },
                  value: medicineInfoState.selected_type_unit.value,
                  items:
                      selectedListType(medicineInfoState.selected_type.value)!
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
          ),
        ],
      ),
    );
  }

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
      return "ขนาดการกิน";
    } else if (type == "arrow") {
      return "ขนาดการฉีด";
    } else if (type == "drop") {
      return "ขนาดการหยอด/พ่น";
    }
    return null;
  }

  String? get _nDoseError {
    final text = widget.controller.value.text;
    if (text.isEmpty) {
      return "ข้อผิดพลาด : กรุณาระบุขนาด";
    }
    // check number & support /
    final textNumber = double.tryParse(text);
    if (textNumber == null) {
      // check "/" in word
      int slashIdx = text.indexOf("/");
      if (slashIdx != -1) {
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
        if (textNumber > 30) {
          return "คำเตือน : ระบุขนาดเกิน 30 เม็ด";
        }
      }
      // check over for cc
      if (medicineInfoState.selected_type_unit.value == "ซีซี") {
        if (textNumber > 120) {
          return "คำเตือน : ระบุขนาดเกิน 120 ซีซี";
        }
      }
      // check over for ml
      if (medicineInfoState.selected_type_unit.value == "มิลลิลิตร") {
        if (textNumber > 45) {
          return "คำเตือน : ระบุขนาดเกิน 45 มิลลิลิตร";
        }
      }
    }
    //
    return null;
  }
}
