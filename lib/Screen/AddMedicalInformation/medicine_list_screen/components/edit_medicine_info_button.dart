// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class EditMedicineInfoButton extends StatelessWidget {
  EditMedicineInfoButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      child: IconButton(
        icon: const Icon(Icons.edit),
        color: Colors.black87,
        onPressed: onPressed,
      ),
    );
  }
}
