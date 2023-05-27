import 'package:flutter/material.dart';
import 'package:tanya_app_v1/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  final bool login;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "ยังไม่มีบัญชีผู้ใช้ ? " : "มีบัญชีผู้ใช้แล้ว ? ",
          style: const TextStyle(color: kPrimaryColor, fontSize: 18),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "สมัครสมาชิก" : "เข้าสู่ระบบ",
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        )
      ],
    );
  }
}
