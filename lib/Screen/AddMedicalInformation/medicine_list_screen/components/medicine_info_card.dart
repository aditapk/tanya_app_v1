import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tanya_app_v1/GetXBinding/medicine_state_binding.dart';
import 'package:tanya_app_v1/Model/medicine_info_model.dart';
import 'package:tanya_app_v1/Model/notify_info.dart';
import 'package:tanya_app_v1/Screen/AddMedicalInformation/medicine_editor_screen/medicine_info_editor_screen.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import '../../../../Controller/medicine_info_controller.dart';
import '../../../Notify/components/add_notify_detail_screen.dart';
import 'delete_medicine_info_button.dart';
import 'edit_medicine_info_button.dart';
import 'image_card.dart';
import 'medicine_info_display_card.dart';
import 'picture_edit_bottomsheet.dart';

class MedicineInfoCard extends StatelessWidget {
  MedicineInfoCard({
    required this.index,
    required this.medicineData,
    super.key,
  });
  // notify state controller injection
  final notifyStateController = Get.put(NotificationState());

  // input of medicine information card
  final MedicineInfo? medicineData;
  final int index;

  // build widget function
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
      ),
      child: Stack(
        children: [
          GestureDetector(
            onLongPress: toMedicineNotifyPage,
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: medicineData?.color == null
                  ? Colors.blue.shade200
                  : Color(medicineData!.color),
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
                  ],
                ),
              ),
            ),
          ),
          // MedicineNotifyButton(
          //   onPressed: toMedicineNotifyPage,
          // ),
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

  // updating Medicine in Hive box
  updateImageMedicineBox(String imagePath) async {
    // update medicine box
    var medicineBox = Hive.box<MedicineInfo>(HiveDatabaseName.MEDICINE_INFO);
    var medicineList = medicineBox.values;
    for (var medicine in medicineList) {
      if (medicine.id == medicineData!.id) {
        medicine.picture_path = imagePath;
        await medicine.save();
      }
    }
  }

  // updating notify in Hive box
  updateImageNotifyBox(String imagePath) async {
    // update notify box
    var notifyBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
    var notifyList = notifyBox.values;
    for (var notify in notifyList) {
      if (notify.medicineInfo.id == medicineData!.id) {
        notify.medicineInfo.picture_path = imagePath;
        await notify.save();
      }
    }
  }

  // Take Photo
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

      await updateImageMedicineBox(localImage.path);
      await updateImageNotifyBox(localImage.path);

      Get.back();
    } on PlatformException {
      // print("Failed take photo : $e");
    }
  }

  // choose Photo from gallery
  Future<void> _choosePhotoFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      medicineData!.picture_path = image.path;
      await medicineData!.save();

      await updateImageMedicineBox(image.path);
      await updateImageNotifyBox(image.path);

      Get.back();
    } on PlatformException {
      // print("Failed take photo : $e");
    }
  }

  //
  toMedicineNotifyPage() async {
    bool? notified = await Get.to(
      () => AddNotifyDetailScreen(
        selectedDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        medicineData: medicineData,
      ),
      binding: AppInfoBinding(),
    );
    if (notified != null) {
      if (notified) {
        Get.snackbar('การแจ้งเตือน', 'แจ้งเตือนรายการยาเรียบร้อยแล้ว');
      }
    }
  }

  _editMedicineInfo() {
    Get.to(
      () => MedicineInfoEditorScreen(
        medicineData: medicineData,
        mode: 'edit',
      ),
      binding: AppInfoBinding(),
    );
  }

  deleteNotify(MedicineInfo medicineData) async {
    // get controller
    var notifyState = Get.find<NotificationState>();
    var notifyBox = Hive.box<NotifyInfoModel>(HiveDatabaseName.NOTIFY_INFO);
    var notifyList = notifyBox.values;
    for (var notify in notifyList) {
      if (notify.medicineInfo.id == medicineData.id) {
        await notifyState.medicineNotification.value.localNotificationsPlugin
            .cancel(notify.key);
        await notify.delete();
        // delete local notification
      }
    }
  }

  _deleteMedicineInfo() async {
    Get.defaultDialog(
      title: 'ลบรายการยา',
      content: GetBuilder<MedicineEditorState>(
        init: MedicineEditorState(),
        builder: (controller) => const Text(
          'รายการยาและการแจ้งเตือนที่เกี่ยวข้องกับยานี้\nจะถูกลบออกอย่างถาวร',
          textAlign: TextAlign.center,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'ตกลง',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () async {
            await deleteNotify(medicineData!);
            await medicineData!.delete();
            Get.back();
          },
        ),
        TextButton(
          child: const Text(
            'ยกเลิก',
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }
}

// sub widget
class MedicineNotifyButton extends StatelessWidget {
  const MedicineNotifyButton({
    super.key,
    required this.onPressed,
  });
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5,
      right: 5,
      child: IconButton(
        icon: const Icon(Icons.notification_add_rounded),
        onPressed: onPressed,
      ),
    );
  }
}
