// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  ImageCard({this.image, super.key});
  String? image;

  final String _emptyPicture = "assets/images/dummy_picture.jpg";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: image == '' || image == null
            ? Image.asset(
                _emptyPicture,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              )
            : Image.file(
                File(image!),
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
      ),
    );
  }
}
