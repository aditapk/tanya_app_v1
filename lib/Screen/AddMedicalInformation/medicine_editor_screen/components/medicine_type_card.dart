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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: selection ? Colors.yellowAccent.shade100 : null,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: selection
                ? BorderSide(
                    width: 5,
                    color: Colors.green.shade200,
                  )
                : BorderSide.none,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                image,
                height: 75,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // _borderSelected(bool selecteState) {
  //   if (selecteState) {
  //     return RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(30),
  //       side: const BorderSide(
  //         width: 4.0,
  //         color: Colors.green,
  //       ),
  //     );
  //   } else {
  //     return RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(30),
  //     );
  //   }
  // }
}
