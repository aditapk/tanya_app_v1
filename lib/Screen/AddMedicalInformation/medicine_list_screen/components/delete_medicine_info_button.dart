// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class DeleteMedicineInfoButton extends StatelessWidget {
  DeleteMedicineInfoButton({
    required this.onPressed,
    required this.index,
    required this.showcaseKey,
    Key? key,
  }) : super(key: key);
  void Function()? onPressed;
  final int index;
  final GlobalKey showcaseKey;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: index != 0
          ? IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.black87,
              onPressed: onPressed,
            )
          : Showcase(
              key: showcaseKey,
              targetBorderRadius: BorderRadius.circular(30),
              description: "ลบรายการยา",
              child: IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.black87,
                onPressed: onPressed,
              ),
            ),
    );
  }
}
