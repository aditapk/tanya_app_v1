import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TimeScheduleSelectionCard extends StatelessWidget {
  const TimeScheduleSelectionCard(
      {required this.title,
      required this.height,
      required this.onTap,
      required this.borderColor,
      required this.backgroundColor,
      required this.selection,
      super.key});

  final String title;
  final double height;
  final Function()? onTap;
  final Color borderColor;
  final Color backgroundColor;
  final bool selection;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 3.0,
          color: selection ? backgroundColor : null,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: selection
                  ? BorderSide(width: 3, color: borderColor)
                  : BorderSide.none),
          child: SizedBox(
            height: height,
            child: Center(
              child: AutoSizeText(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // _borderSelection(bool selectedState, Color borderColor) {
  //   return selectedState
  //       ? RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           side: BorderSide(
  //             width: 0,
  //             color: borderColor,
  //           ),
  //         )
  //       : RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         );
  // }
}
