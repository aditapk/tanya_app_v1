// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class DeleteMedicineInfoButton extends StatelessWidget {
  DeleteMedicineInfoButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      bottom: 10,
      child: IconButton(
        icon: const Icon(Icons.delete),
        color: Colors.red,
        onPressed: onPressed,
      ),
    );
  }
}
