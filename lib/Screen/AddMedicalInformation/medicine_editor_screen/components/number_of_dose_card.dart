import 'package:flutter/material.dart';

class NumberOfDoseCard extends StatelessWidget {
  const NumberOfDoseCard({
    required this.text,
    required this.selection,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final String text;
  final Function()? onTap;
  final bool selection;

  _borderSelection(bool select) {
    if (select) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          width: 0,
          color: Colors.green,
        ),
      );
    } else {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
          color: selection ? Colors.green[100] : null,
          shape: _borderSelection(selection),
          child: SizedBox(
            height: 50,
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
