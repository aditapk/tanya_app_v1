import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';

class PictureMedicineCard extends StatelessWidget {
  PictureMedicineCard({super.key});

  final String _emptyPicture = "assets/images/dummy_picture.jpg";

  //final medicineInfoState = Get.put(MedicineEditorState());
  final medicineInfoState = Get.find<MedicineEditorState>();

  Future<void> _takePhotoToGallerry() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      var directory = await getApplicationDocumentsDirectory();
      var name = basename(image.path);
      var localImage = await File(image.path).copy("${directory.path}/$name");
      await GallerySaver.saveImage(localImage.path);

      medicineInfoState.picture_path(localImage.path);
    } on PlatformException {
      //print("Failed take photo : $e");
    }
  }

  Future<void> _choosePhotoFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      medicineInfoState.picture_path(image.path);
    } on PlatformException {
      //print("Failed take photo : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Picture
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Obx(
            () => medicineInfoState.picture_path.value == ""
                ? Image.asset(
                    _emptyPicture,
                  )
                : Image.file(
                    File(medicineInfoState.picture_path.value),
                  ),
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            onPressed: () async => await _takePhotoToGallerry(),
            icon: const Icon(Icons.photo_camera),
          ),
        ),
        Positioned(
          left: 0,
          child: IconButton(
            onPressed: () async => await _choosePhotoFromGallery(),
            icon: const Icon(Icons.image),
          ),
        ),
      ],
    );
  }
}
