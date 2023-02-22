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

  _borderSelection(bool selectedState, Color borderColor) {
    return selectedState
        ? RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              width: 0,
              color: borderColor,
            ),
          )
        : RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 3.0,
          color: selection ? backgroundColor : null,
          shape: _borderSelection(selection, borderColor),
          child: SizedBox(
            height: height,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
