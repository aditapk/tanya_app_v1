import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../Model/user_info_model.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  @override
  Widget build(BuildContext context) {
    // get user_info box
    var userInfo = Hive.box<UserInfo>('user_info').get(0);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              UserAvatarPicture(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                          valueListenable:
                              Hive.box<UserInfo>('user_info').listenable(),
                          builder: (_, userInfoBox, __) {
                            if (userInfoBox.values.isEmpty) {
                              return Text('ยังไม่ระบุข้อมูลผู้ใช้');
                            } else {
                              var userInfo = userInfoBox.get(0);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'ชื่อ ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                            text: userInfo?.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'ที่อยู่ ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                            text: userInfo?.address,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: 'แพทย์ผู้รักษา ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                            text: userInfo?.doctorName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal)),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.33,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    // setState(() {
                    //   userInfoDisplay = userInfo;
                    // });

                    Get.defaultDialog(
                      title: 'ระบุข้อมูลผู้ใช้',
                      titleStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                      content: TextFieldUserInfo(
                        userInfo: userInfo,
                      ),
                    );
                  },
                  child: Text(userInfo == null ? 'เพิ่ม' : 'แก้ไข'),
                ),
              ),
              //TextFieldUserInfo(),
              AppointmentWithDoctorInfo()
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentWithDoctorInfo extends StatelessWidget {
  const AppointmentWithDoctorInfo({
    super.key,
  });
  static const TextStyle textHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'นัดหมาย',
            style: textHeaderStyle,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.calendar_month_outlined,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'วันที่',
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.access_alarm_outlined,
                      ),
                    ),
                    border: OutlineInputBorder(),
                    hintText: 'เวลา',
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('เพิ่ม'),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class TextFieldUserInfo extends StatefulWidget {
  static const TextStyle textHeaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  UserInfo? userInfo;
  TextFieldUserInfo({
    required this.userInfo,
    super.key,
  });

  @override
  State<TextFieldUserInfo> createState() => _TextFieldUserInfoState();
}

class _TextFieldUserInfoState extends State<TextFieldUserInfo> {
  TextEditingController nameTextController = TextEditingController();

  TextEditingController addressTextController = TextEditingController();

  TextEditingController doctorTextController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    if (widget.userInfo != null) {
      if (widget.userInfo!.name != null) {
        nameTextController.text = widget.userInfo!.name!;
      }
      if (widget.userInfo!.address != null) {
        addressTextController.text = widget.userInfo!.address!;
      }
      if (widget.userInfo!.doctorName != null) {
        doctorTextController.text = widget.userInfo!.doctorName!;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ชื่อ',
            style: TextFieldUserInfo.textHeaderStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: nameTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'ยังไม่ระบุ',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'ที่อยู่',
            style: TextFieldUserInfo.textHeaderStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: addressTextController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'ยังไม่ระบุ',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'แพทย์ผู้รักษา',
            style: TextFieldUserInfo.textHeaderStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: doctorTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'ยังไม่ระบุ',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (widget.userInfo == null) {
                  var userInfoBox = Hive.box<UserInfo>('user_info');
                  var userInfoNew = UserInfo(
                    name: nameTextController.text.isNotEmpty
                        ? nameTextController.text
                        : null,
                    address: addressTextController.text.isNotEmpty
                        ? addressTextController.text
                        : null,
                    doctorName: doctorTextController.text.isNotEmpty
                        ? doctorTextController.text
                        : null,
                  );
                  await userInfoBox.add(userInfoNew);
                } else {
                  if (nameTextController.text.isNotEmpty) {
                    widget.userInfo!.name = nameTextController.text;
                  }
                  if (addressTextController.text.isNotEmpty) {
                    widget.userInfo!.address = addressTextController.text;
                  }
                  if (doctorTextController.text.isNotEmpty) {
                    widget.userInfo!.doctorName = doctorTextController.text;
                  }
                  await widget.userInfo!.save();
                }

                Get.back();
              },
              child: Text('บันทึกข้อมูล'),
            ),
          ),
        ],
      ),
    );
  }
}

class UserAvatarPicture extends StatelessWidget {
  UserAvatarPicture({
    this.userInfo,
    super.key,
  });

  UserInfo? userInfo;
  Icon userTempAvatar = const Icon(
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
      );
    }
    return const Icon(
      Icons.person,
      size: 80 * 2 * 0.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    var userInfoBox = Hive.box<UserInfo>('user_info');
    var userInfo = userInfoBox.get(0);
    return ValueListenableBuilder(
      valueListenable: Hive.box<UserInfo>('user_info').listenable(),
      builder: (_, userInfoBox, __) {
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
