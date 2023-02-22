// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tanya_app_v1/GetXBinding/medicine_state_binding.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_editor_screen/medicine_info_editor_screen.dart';

import 'delete_medicine_info_button.dart';
import 'edit_medicine_info_button.dart';
import 'image_card.dart';
import 'medicine_info_display_card.dart';
import 'picture_edit_bottomsheet.dart';

class MedicineInfoCard extends StatelessWidget {
  MedicineInfoCard({required this.medicineData, super.key});
  MedicineInfo? medicineData;

  Future<void> _takePhotoToGallerry() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      var directory = await getApplicationDocumentsDirectory();
      var name = basename(image.path);
      var localImage = await File(image.path).copy("${directory.path}/$name");
      await GallerySaver.saveImage(localImage.path);

      medicineData!.picture_path = localImage.path;

      await medicineData!.save();

      Get.back();
    } on PlatformException {
      // print("Failed take photo : $e");
    }
  }

  Future<void> _choosePhotoFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      medicineData!.picture_path = image.path;
      await medicineData!.save();

      Get.back();
    } on PlatformException {
      // print("Failed take photo : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Stack(
        children: [
          Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blue[100],
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      right: 5,
                    ),
                    child: GestureDetector(
                      child: ImageCard(
                        image: medicineData?.picture_path,
                      ),
                      onTap: () {
                        Get.bottomSheet(
                          PictureEditBottomSheet(
                            onChoose: () async =>
                                await _choosePhotoFromGallery(),
                            onTakephoto: () async =>
                                await _takePhotoToGallerry(),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: MedicineInfoDisplayCard(
                      medicineData: medicineData,
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  )
                ],
              ),
            ),
          ),
          EditMedicineInfoButton(
            onPressed: _editMedicineInfo,
          ),
          DeleteMedicineInfoButton(
            onPressed: _deleteMedicineInfo,
          ),
        ],
      ),
    );
  }

  _editMedicineInfo() {
    Get.to(
      () => MedicineInfoEditorScreen(
        medicineData: medicineData,
      ),
      binding: MedicineInfoBinding(),
    );
  }

  _deleteMedicineInfo() async => await medicineData!.delete();
}
