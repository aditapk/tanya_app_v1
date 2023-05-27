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

import '../../../../constants.dart';

class PictureMedicineCard extends StatefulWidget {
  const PictureMedicineCard({super.key});

  @override
  State<PictureMedicineCard> createState() => _PictureMedicineCardState();
}

class _PictureMedicineCardState extends State<PictureMedicineCard> {
  // medicine state info injecion
  final medicineInfoState = Get.find<MedicineEditorState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Picture
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Obx(
            () => medicineInfoState.picture_path.value == ""
                ? Image.asset(
                    emptyPicture,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(medicineInfoState.picture_path.value),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: IconButton(
            onPressed: () async => await _takePhotoToGallerry(),
            icon: const Icon(
              Icons.photo_camera,
            ),
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
              pickerColor: medicineInfoState.color.value,
              availableColors: colors,
              onChangeColor: (color) {
                medicineInfoState.color.value = color;
              },
            ),
          ),
        ),
      ],
    );
  }

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
}

class ColorSelection extends StatelessWidget {
  const ColorSelection({
    super.key,
    required this.pickerColor,
    required this.onChangeColor,
    required this.availableColors,
  });
  final Function(Color color) onChangeColor;
  final List<Color> availableColors;
  final Color pickerColor;

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
                color: pickerColor,
              ),
              child: IconButton(
                onPressed: chooseColor,
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

  chooseColor() {
    Get.defaultDialog(
      title: 'เลือกสีสำหรับรายการยา',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      content: ChooseColorWidget(
        pickerColor: pickerColor,
        availableColors: availableColors,
        onChangeColor: onChangeColor,
      ),
    );
  }
}

class ChooseColorWidget extends StatelessWidget {
  const ChooseColorWidget({
    super.key,
    required this.pickerColor,
    required this.availableColors,
    required this.onChangeColor,
  });

  final Color pickerColor;
  final List<Color> availableColors;
  final Function(Color) onChangeColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 250,
          height: 280,
          child: BlockPicker(
            pickerColor: pickerColor,
            availableColors: availableColors,
            onColorChanged: onChangeColor,
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
    );
  }
}
