import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

      var userInfoBox = Hive.box<UserInfo>('user_info');
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

      var userInfoBox = Hive.box<UserInfo>('user_info');
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
        color: Colors.white70,
      );
    }
    return const Icon(
      Icons.person,
      size: 80 * 2 * 0.7,
      color: Colors.white70,
    );
  }

  @override
  Widget build(BuildContext context) {
    //var userInfoBox = Hive.box<UserInfo>('user_info');

    return ValueListenableBuilder(
      valueListenable: Hive.box<UserInfo>('user_info').listenable(),
      builder: (_, userInfoBox, __) {
        var userInfo = userInfoBox.get(0);
        return Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.shade300,
                radius: 80,
                child: getAvarPictureChild(userInfo),
              ),
              Positioned(
                bottom: 0,
                right: 0,
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
                left: 0,
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
        );
      },
    );
  }
}
