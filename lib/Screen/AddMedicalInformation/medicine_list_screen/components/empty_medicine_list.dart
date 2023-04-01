import 'package:flutter/material.dart';

class EmptyMedicineList extends StatelessWidget {
  const EmptyMedicineList({super.key, required this.emptyDescription});

  final String emptyDescription;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Image.asset(
            "assets/images/empty_medicine_list.png",
            width: size.width * 0.8,
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          const Text(
            "ไม่มีรายการยา",
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
