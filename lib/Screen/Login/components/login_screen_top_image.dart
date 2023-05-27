import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tanya_app_v1/constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "เข้าสู่ระบบ",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "แอปพลิเคชันเตือนกินยา",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        const SizedBox(height: defaultPadding * 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                  height: MediaQuery.of(context).size.width * 0.85,
                  child: Lottie.asset('assets/lotties/medicine-capsule.json')),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding * 1),
      ],
    );
  }
}
