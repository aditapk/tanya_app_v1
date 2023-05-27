import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tanya_app_v1/utils/constans.dart';

import '../../../Model/user_info_model.dart';

class UserAvatarPicture extends StatelessWidget {
  const UserAvatarPicture({
    this.userInfo,
    super.key,
  });

  final UserInfo? userInfo;
  final Icon userTempAvatar = const Icon(
    Icons.person,
    size: 80 * 2 * 0.7,
    color: Colors.white,
  );

  Future<void> _takePhotoToGallerry() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      var directory = await getApplicationDocumentsDirectory();
      var name = basename(image.path);
      var localImage = await File(image.path).copy("${directory.path}/$name");
      await GallerySaver.saveImage(localImage.path);

      var userInfoBox = Hive.box<UserInfo>(HiveDatabaseName.USER_INFO);
      var userInfo = userInfoBox.get(0);
      if (userInfo != null) {
        userInfo.picturePath = localImage.path;
        await userInfo.save();
      } else {
        var userData = UserInfo(
          picturePath: localImage.path,
        );
        await userInfoBox.add(userData);
      }
    } on PlatformException {
      //print("Failed take photo : $e");
    }
  }

  Future<void> _choosePhotoFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      var userInfoBox = Hive.box<UserInfo>(HiveDatabaseName.USER_INFO);
      var userInfo = userInfoBox.get(0);
      if (userInfo != null) {
        userInfo.picturePath = image.path;
        await userInfo.save();
      } else {
        var userData = UserInfo(picturePath: image.path);
        await userInfoBox.add(userData);
      }
    } on PlatformException {
      //print("Failed take photo : $e");
    }
  }

  getAvarPictureChild(UserInfo? userInfo) {
    if (userInfo != null) {
      if (userInfo.picturePath != null) {
        return ClipOval(
          child: Image.file(
            File(userInfo.picturePath!),
            fit: BoxFit.cover,
            width: 160,
            height: 160,
          ),
        );
      }
      return const Icon(
        Icons.person,
        size: 80 * 2 * 0.7,
      );
    }
    return const Icon(
      Icons.person,
      size: 80 * 2 * 0.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    //var userInfoBox = Hive.box<UserInfo>('user_info');

    return ValueListenableBuilder(
      valueListenable:
          Hive.box<UserInfo>(HiveDatabaseName.USER_INFO).listenable(),
      builder: (_, userInfoBox, __) {
        var userInfo = userInfoBox.get(0);
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: Theme.of(context).primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    radius: 80,
                    child: getAvarPictureChild(userInfo),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 130,
                  child: GestureDetector(
                    onTap: () {
                      _takePhotoToGallerry();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 20,
                      child: Icon(Icons.photo_camera),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 130,
                  child: GestureDetector(
                    onTap: () {
                      _choosePhotoFromGallery();
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 20,
                      child: Icon(Icons.image),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
