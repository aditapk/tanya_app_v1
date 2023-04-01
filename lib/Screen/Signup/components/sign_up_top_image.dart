import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:tanya_app_v1/constants.dart';

class SignUpScreenTopImage extends StatelessWidget {
  const SignUpScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'สมัครสมาชิก',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const Text(
          'เพื่อเข้าใช้งานแอปพลิเคชั่นเตือนกินยา',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        const SizedBox(height: defaultPadding),
        Row(
          children: [
            Expanded(
                child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.85,
                    child: Lottie.asset('assets/lotties/online-doctor.json'))
                //SvgPicture.asset("assets/icons/signup.svg"),
                ),
          ],
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
  }
}
