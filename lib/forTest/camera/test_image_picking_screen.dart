// // ignore_for_file: non_constant_identifier_names, must_be_immutable

// import 'dart:io';
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class TestImageState extends GetxController {
//   var image_path = "".obs;
// }

// class TestImagePickerApp extends StatelessWidget {
//   TestImagePickerApp({super.key});

//   var mystate = Get.put(TestImageState());
//   // File? _image;
//   // Future getImage(ImageSource source) async {
//   //   try {
//   //     final image = await ImagePicker().pickImage(source: source);
//   //     if (image == null) return;

//   //     if (source == ImageSource.camera) {
//   //       final image = await savePermanently(image.path);
//   //       await GallerySaver.saveImage(imageTemporary.path);
//   //     }

//   //     mystate.image_path(image.path);
//   //   } on PlatformException catch (e) {
//   //     print("Failed to pick image : $e");
//   //   }
//   //   // setState(() {
//   //   //   this._image = imageTemporary;
//   //   // });
//   // }

//   Future<void> getImageFromGallery() async {
//     try {
//       final image = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (image == null) return;

//       mystate.image_path(image.path);
//     } on PlatformException {
//       //print("Failed to pick image from gallery: $e");
//     }
//   }

//   Future<void> getImageFromCamera() async {
//     try {
//       final image = await ImagePicker().pickImage(source: ImageSource.camera);
//       if (image == null) return;

//       await GallerySaver.saveImage(image.path);
//       mystate.image_path(image.path);
//     } on PlatformException {
//       //print("Failed to pick image from camera");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("rebuild - widget");
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Pick an Image"),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             Obx(
//               () => mystate.image_path.value != ""
//                   ? Image.file(
//                       File(mystate.image_path.value),
//                       width: 300,
//                       height: 300,
//                     )
//                   : Image.network(
//                       "https://media.istockphoto.com/id/913088320/th/%E0%B9%80%E0%B8%A7%E0%B8%84%E0%B9%80%E0%B8%95%E0%B8%AD%E0%B8%A3%E0%B9%8C/%E0%B8%A3%E0%B9%89%E0%B8%B2%E0%B8%99%E0%B8%82%E0%B8%B2%E0%B8%A2%E0%B8%A2%E0%B8%B2.jpg?s=612x612&w=0&k=20&c=HHGbQCo3CRTwdGiWs9CHsbjQu_zCKoXNoPZSw2rrXj0=",
//                       width: 300,
//                       height: 300,
//                       fit: BoxFit.cover,
//                     ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             CustomButton(
//               title: "Pick Image from Gallery",
//               icon: Icons.image,
//               onClicked: getImageFromGallery,
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             CustomButton(
//               title: "Pick Image from Camera",
//               icon: Icons.camera,
//               onClicked: getImageFromCamera,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomButton extends StatelessWidget {
//   const CustomButton({
//     required this.title,
//     required this.icon,
//     required this.onClicked,
//     Key? key,
//   }) : super(key: key);
//   final String title;
//   final IconData icon;
//   final void Function()? onClicked;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 300,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: onClicked,
//         child: Row(
//           children: [
//             Icon(icon),
//             const SizedBox(
//               width: 20,
//             ),
//             Text(title),
//           ],
//         ),
//       ),
//     );
//   }
// }
