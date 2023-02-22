import 'package:flutter/material.dart';

class EmptyMedicineList extends StatelessWidget {
  EmptyMedicineList({super.key, required this.emptyDescription});

  String emptyDescription;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          Image.asset(
            "assets/images/empty_medicine_list.jpg",
            width: size.width * 0.8,
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          const Text(
            "ไม่พบรายการยา",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            emptyDescription,
            style: const TextStyle(
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
