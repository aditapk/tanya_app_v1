// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PictureEditBottomSheet extends StatelessWidget {
  PictureEditBottomSheet({
    required this.onChoose,
    required this.onTakephoto,
    Key? key,
  }) : super(key: key);

  void Function()? onChoose;
  void Function()? onTakephoto;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: 140,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "เปลี่ยนรูปภาพ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onChoose,
                    child: Row(
                      children: const [
                        Icon(Icons.photo),
                        SizedBox(
                          width: 10,
                        ),
                        Text("เลือกจากคลังภาพ"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTakephoto,
                    child: Row(
                      children: const [
                        Icon(Icons.photo_camera),
                        SizedBox(
                          width: 10,
                        ),
                        Text("ถ่ายภาพ"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
