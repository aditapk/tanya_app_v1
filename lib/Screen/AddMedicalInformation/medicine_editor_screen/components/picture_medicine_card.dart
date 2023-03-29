import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tanya_app_v1/Controller/medicine_info_controller.dart';

class PictureMedicineCard extends StatefulWidget {
  PictureMedicineCard({super.key});

  @override
  State<PictureMedicineCard> createState() => _PictureMedicineCardState();
}

class _PictureMedicineCardState extends State<PictureMedicineCard> {
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
          right: 10,
          top: 10,
          child: IconButton(
            onPressed: () async => await _takePhotoToGallerry(),
            icon: const Icon(Icons.photo_camera),
          ),
        ),
        Positioned(
          right: 10,
          top: 60,
          child: IconButton(
            onPressed: () async => await _choosePhotoFromGallery(),
            icon: const Icon(Icons.image),
          ),
        ),
        Positioned(
          right: 10,
          top: 100,
          child: Obx(
            () => ColorSelection(
              pickrColor: medicineInfoState.color.value,
              availableColors: colors,
              onColorChange: (color) {
                medicineInfoState.color.value = color;
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ColorSelection extends StatelessWidget {
  const ColorSelection({
    super.key,
    required this.pickrColor,
    required this.onColorChange,
    required this.availableColors,
  });
  final Function(Color color) onColorChange;
  final List<Color> availableColors;
  final Color pickrColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: pickrColor,
              ),
              child: IconButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'เลือกสีสำหรับรายการยา',
                    titleStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    content: Column(
                      children: [
                        SizedBox(
                          width: 250,
                          height: 280,
                          child: BlockPicker(
                            pickerColor: pickrColor,
                            availableColors: availableColors,
                            onColorChanged: onColorChange,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16)),
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                'ตกลง',
                                style: TextStyle(fontSize: 20),
                              )),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.colorize_sharp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
