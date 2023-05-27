// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../constants.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({this.image, super.key});
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: image == '' || image == null
            ? Image.asset(
                emptyPicture,
                fit: BoxFit.cover,
                width: 100,
                height: 120,
              )
            : Image.file(
                File(image!),
                fit: BoxFit.cover,
                width: 100,
                height: 120,
              ),
      ),
    );
  }
}
