import 'package:flutter/material.dart';

class MedicineTypeCard extends StatelessWidget {
  const MedicineTypeCard({
    required this.image,
    required this.selection,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String image;
  final Function()? onTap;

  final bool selection;

  _borderSelected(bool selecteState) {
    if (selecteState) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          width: 4.0,
          color: Colors.green,
        ),
      );
    } else {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 3.0,
          shape: _borderSelected(selection),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                image,
                height: 100 * 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
